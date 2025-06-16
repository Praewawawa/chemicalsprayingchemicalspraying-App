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
  final Set<String> _subscribedTopics = {};
  final Map<String, Function(String)> _topicCallbacks = {};

  double windSpeed = 0.0;
  double battery = 0.0;
  double chemical = 0.0;
  WaterLevelStatus waterLevel = WaterLevelStatus.empty;

  double _distance = 0.0;
  double get distance => _distance;
  set distance(double value) {
    _distance = value;
    onUpdate?.call();
  }

  ValueNotifier<LatLng?> currentPosition = ValueNotifier(null);
  ValueNotifier<double?> altitude = ValueNotifier(null);
  ValueNotifier<bool> sprayStatus = ValueNotifier(false);
  ValueNotifier<int> sprayLevel = ValueNotifier(1);

  final StreamController<LatLng?> _currentPositionController =
      StreamController.broadcast();
  Stream<LatLng?> get currentPositionStream =>
      _currentPositionController.stream;

  Function()? onUpdate;

  bool _connected = false;
  bool get isConnected => _connected;

  Future<void> connect() async {
    if (_connected) return;

    client = MqttServerClient.withPort(server, _generateClientId(), port);
    client.secure = true;
    client.securityContext = SecurityContext.defaultContext;
    client.keepAlivePeriod = 20;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.logging(on: false);

    try {
      await client.connect(username, password);
    } catch (e) {
      print('MQTT Connect error: $e');
      _connected = false;
      client.disconnect();
      return;
    }

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      _connected = true;
      print("MQTT Connected");

      _setupUpdatesListener();

      _subscribe("Wind", _handleWind);
      _subscribe("battery", _handleBattery);
      _subscribe("water", _handleChemical);
      _subscribe("distance", _handleDistance);
      _subscribe("pixhawk/gps", _handleCurrentPosition);
      _subscribe("pump_lavel", _handleSprayStatus);
      _subscribe("pump_status", _handleSprayStatus);
    } else {
      print('MQTT Connection failed: ${client.connectionStatus}');
      client.disconnect();
    }
  }

  void _setupUpdatesListener() {
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> events) {
      for (var event in events) {
        final topic = event.topic;
        final recMess = event.payload as MqttPublishMessage;
        final msg =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        _topicCallbacks[topic]?.call(msg);
      }
    });
  }

  void _subscribe(String topic, Function(String) callback) {
    if (!_connected || _subscribedTopics.contains(topic)) return;
    _subscribedTopics.add(topic);
    _topicCallbacks[topic] = callback;
    client.subscribe(topic, MqttQos.atMostOnce);
  }

  void listen(String topic, void Function(String) onMessage) {
    _subscribe(topic, onMessage);
  }

  void publish(String topic, String message) {
    if (!_connected) {
      print('MQTT not connected. Cannot publish to $topic');
      return;
    }
    final builder = MqttClientPayloadBuilder()..addString(message);
    client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
  }

  void publishSprayLevel(int level) {
    sprayLevel.value = level;
    publish("sub_pump_lavel", level.toString());
  }

  void publishSprayStatus(bool isOn) {
    sprayStatus.value = isOn;
    publish("pump_status", isOn ? "ON" : "OFF");
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
    final msg = "${position.latitude},${position.longitude}";
    publish("waypoint/control/target", msg);
  }

  void disconnect() {
    if (_connected) {
      client.disconnect();
      _connected = false;
      _resetValues();
      print('MQTT Disconnected by user');
    }
  }

  void _onConnected() {
    print('MQTT Connected Callback');
  }

  void _onDisconnected() {
    _connected = false;
    print('MQTT Disconnected');
    _resetValues();

    Future.delayed(Duration(seconds: 5), () {
      print('Attempting reconnect...');
      connect();
    });
  }

  void _resetValues() {
    windSpeed = 0.0;
    battery = 0.0;
    chemical = 0.0;
    distance = 0.0;
    currentPosition.value = null;
    altitude.value = null;
    sprayStatus.value = false;
    sprayLevel.value = 1;
  }

  void _handleWind(String msg) {
    windSpeed = double.tryParse(msg) ?? 0.0;
    onUpdate?.call();
  }

  void _handleBattery(String msg) {
    battery = double.tryParse(msg) ?? 0.0;
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
        print('Invalid lat/lon types: $msg');
      }
    } catch (e) {
      print('Error parsing GPS JSON: $msg');
    }
  }

  void _handleSprayStatus(String msg) {
    if (msg.toUpperCase() == 'ON') {
      sprayStatus.value = true;
    } else if (msg.toUpperCase() == 'OFF') {
      sprayStatus.value = false;
    }
    onUpdate?.call();
  }

  String _generateClientId() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyyMMddHHmmss');
    final random = Random().nextInt(99999);
    return 'client-${formatter.format(now)}-$random';
  }

  void dispose() {
    _currentPositionController.close();
    currentPosition.dispose();
    altitude.dispose();
    sprayStatus.dispose();
    sprayLevel.dispose();
  }
}
