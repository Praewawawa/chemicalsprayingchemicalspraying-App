// screen/mqtt_service.dart
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
  MqttService._internal();

  final String server = "49b6aef9efa2446282d4d2b466bafdcd.s1.eu.hivemq.cloud";
  final int port = 8883;
  final String username = "chemicalspraying";
  final String password = "@Dm!np159753";

  late MqttServerClient client;

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

  Function()? onUpdate;

  bool _connected = false;
  bool get isConnected => _connected;

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
      _subscribe("Wind", _handleWind);
      _subscribe("battery", _handleBattery);
      _subscribe("waterLevel", _handleWaterLevel);
      _subscribe("chemical", _handleChemical);
      _subscribe("distance", _handleDistance);
      _subscribe("currentPosition", _handleCurrentPosition);
    } else {
      client.disconnect();
    }
  }

  void _subscribe(String topic, Function(String) callback) {
    client.subscribe(topic, MqttQos.atMostOnce);

    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> events) {
      for (var event in events) {
        final receivedTopic = event.topic;
        if (receivedTopic == topic) {
          final recMess = event.payload as MqttPublishMessage;
          final msg = MqttPublishPayload.bytesToStringAsString(
              recMess.payload.message);
          callback(msg);
        }
      }
    });
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
      final parts = msg.split(',');
      if (parts.length == 2) {
        final lat = double.parse(parts[0]);
        final lon = double.parse(parts[1]);
        currentPosition.value = LatLng(lat, lon);
        onUpdate?.call();
      }
    } catch (e) {
      print('Invalid position: $msg');
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
    const String topic = "sprayLevel";
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

  // ฟังก์ชันเพิ่มพิกัดเป้าหมายใหม่ให้ Pi เคลื่อนที่ไป
  void publishTargetPosition(LatLng position) {
    final String topic = "waypoint/target";
    final String message = "${position.latitude},${position.longitude}";
    publish(topic, message);
  }

  void _onConnected() => print('MQTT Connected');

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

  void listen(String topic, void Function(String) onMessage) {
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
