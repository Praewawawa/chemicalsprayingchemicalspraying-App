// screen/mqtt_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/foundation.dart';

enum WaterLevelStatus { empty, half, full }

class MqttService {
  static final MqttService _instance = MqttService._internal();
  factory MqttService() => _instance;

  MqttService._internal() {
    currentPosition.addListener(() {
      _currentPositionController.add(currentPosition.value);
    });
  }

  final String server = "49b6aef9efa2446282d4d2b466bafdcd.s1.eu.hivemq.cloud";
  final int port = 8883;
  final String username = "chemicalspraying";
  final String password = "@Dm!np159753";

  late MqttServerClient client;

  double windSpeed = 0.0;
  double battery = 0.0;
  double chemical = 0.0; // ดึงจาก topic "water"
  WaterLevelStatus waterLevel = WaterLevelStatus.empty;

  double _distance = 0.0;
  double get distance => _distance;
  set distance(double value) {
    _distance = value;
    onUpdate?.call();
  }

  ValueNotifier<LatLng?> currentPosition = ValueNotifier(null);
  ValueNotifier<double?> altitude = ValueNotifier(null);

  final StreamController<LatLng?> _currentPositionController = StreamController.broadcast();
  Stream<LatLng?> get currentPositionStream => _currentPositionController.stream;

  Function()? onUpdate;

  bool _connected = false;
  bool get isConnected => _connected;

  final Set<String> _subscribedTopics = {};

  Future<void> connect() async {
    if (_connected) return;

    client = MqttServerClient.withPort(server, _generateClientId(), port)
      ..secure = true
      ..securityContext = SecurityContext.defaultContext
      ..keepAlivePeriod = 20
      ..onDisconnected = _onDisconnected
      ..onConnected = _onConnected
      ..onSubscribed = (String topic) => print('Subscribed: $topic');

    try {
      await client.connect(username, password);
    } catch (e) {
      print('MQTT Connect error: $e');
      return;
    }

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      _connected = true;

      _subscribeIfNeeded("Wind", _handleWind);
      _subscribeIfNeeded("battery", _handleBattery);
      _subscribeIfNeeded("waterLevel", _handleWaterLevel);

      // ✅ ใช้ topic "water" สำหรับ chemical level
      _subscribeIfNeeded("water", _handleChemical);

      _subscribeIfNeeded("distance", _handleDistance);
      _subscribeIfNeeded("pixhawk/gps", _handleCurrentPosition);
      _subscribeIfNeeded("pump_lavel", _handleSprayStatus);
      _subscribeIfNeeded("sub_pump_lavel", _handleSprayStatus);
    } else {
      print('MQTT Connection failed - disconnecting');
      client.disconnect();
    }
  }

  void _subscribeIfNeeded(String topic, Function(String) callback) {
    if (_subscribedTopics.contains(topic)) return;
    _subscribedTopics.add(topic);

    client.subscribe(topic, MqttQos.atMostOnce);
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> events) {
      for (var event in events) {
        if (event.topic == topic) {
          final recMess = event.payload as MqttPublishMessage;
          final msg = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
          callback(msg);
        }
      }
    });
  }

  void disconnect() {
    if (_connected) {
      client.disconnect();
      _connected = false;
      print('MQTT Disconnected by user');
    }
  }

  void listen(String topic, void Function(String) onMessage) {
    if (!_subscribedTopics.contains(topic)) {
      _subscribedTopics.add(topic);
      client.subscribe(topic, MqttQos.atMostOnce);
      client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
        for (var message in messages) {
          if (message.topic == topic) {
            final recMess = message.payload as MqttPublishMessage;
            final payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
            onMessage(payload);
          }
        }
      });
    }
  }

  void _handleWind(String msg) {
    windSpeed = double.tryParse(msg) ?? 0.0;
    onUpdate?.call();
  }

  void _handleBattery(String msg) {
    battery = double.tryParse(msg) ?? 0.0;
    onUpdate?.call();
  }

  void _handleWaterLevel(String msg) {
    switch (msg.toLowerCase()) {
      case 'full':
        waterLevel = WaterLevelStatus.full;
        break;
      case 'half':
        waterLevel = WaterLevelStatus.half;
        break;
      default:
        waterLevel = WaterLevelStatus.empty;
    }
    onUpdate?.call();
  }

  void _handleChemical(String msg) {
    chemical = double.tryParse(msg) ?? 0.0;
    onUpdate?.call();
  }

  void _handleDistance(String msg) {
    distance = double.tryParse(msg) ?? 0.0;
  }

  void _handleCurrentPosition(String msg) {
    try {
      final data = jsonDecode(msg);
      final lat = data['latitude'];
      final lon = data['longitude'];
      final alt = data['altitude'];

      if (lat is num && lon is num) {
        currentPosition.value = LatLng(lat.toDouble(), lon.toDouble());
        altitude.value = (alt is num) ? alt.toDouble() : null;
        onUpdate?.call();
      } else {
        print('Latitude or Longitude is not a number: $msg');
      }
    } catch (e) {
      print('Invalid JSON position: $msg');
    }
  }

  void publish(String topic, String message) {
    if (!_connected) {
      print('MQTT not connected. Cannot publish to $topic');
      return;
    }
    final builder = MqttClientPayloadBuilder()..addString(message);
    client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
  }

  void publishSprayLevel(int sprayLevel) {
    print("spray level: $sprayLevel");
    const String topic = "sub_pump_lavel";
    publish(topic, sprayLevel.toString());
  }

  void publishStartNavigation() {
    publish("waypoint/start", "start");
  }

  void publishStopNavigation() {
    publish("waypoint/start", "stop");
  }

  void publishReturnHome() {
    publish("waypoint/home", "return");
  }

  void publishTargetPosition(LatLng position) {
    final String topic = "waypoint/control/target";
    final String message = "${position.latitude},${position.longitude}";
    publish(topic, message);
  }

  void _onConnected() {
    print('MQTT Connected');
  }

  void _onDisconnected() {
    _connected = false;
    print('MQTT Disconnected');
  }

  String _generateClientId() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyyMMddHHmmss');
    final random = Random().nextInt(99999);
    return 'client-${formatter.format(now)}-$random';
  }

  ValueNotifier<bool> sprayStatus = ValueNotifier(false);
  ValueNotifier<int> sprayLevel = ValueNotifier<int>(1);

  void _handleSprayStatus(String msg) {
    sprayStatus.value = msg.toUpperCase() == 'ON';
    onUpdate?.call();
  }

  void dispose() {
    _currentPositionController.close();
    currentPosition.dispose();
    altitude.dispose();
    sprayStatus.dispose();
    sprayLevel.dispose();
  }
}
