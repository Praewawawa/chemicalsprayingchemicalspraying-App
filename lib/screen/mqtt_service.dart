// screen/mqtt_service.dart
import 'dart:math';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  static final MqttService _instance = MqttService._internal();
  factory MqttService() => _instance;
  MqttService._internal();

  final String server = "e2b1728dd2a940b0af5f00fd181cdd5e.s2.eu.hivemq.cloud";
  final int port = 8883;
  final String username = "PutawanKusumot";
  final String password = "Tawan09052544";

  late MqttServerClient client;
  double windSpeed = 0.0;
  double battery = 0.0;
  bool waterLevel = false;
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
    client.onSubscribed = (String topic) => print('Subscribed: \$topic');

    try {
      await client.connect(username, password);
    } catch (e) {
      print('MQTT Connect error: \$e');
      return;
    }

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      _connected = true;
      _subscribe("Wind", (msg) => _handleWind(msg));
      _subscribe("battery", (msg) => _handleBattery(msg));
      _subscribe("waterLevel", (msg) => _handleWaterLevel(msg));
    } else {
      client.disconnect();
    }
  }

  void _subscribe(String topic, Function(String) callback) {
    client.subscribe(topic, MqttQos.atMostOnce);
    client.updates?.listen((c) {
      final recMess = c.first.payload as MqttPublishMessage;
      final msg = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      callback(msg);
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
    waterLevel = (msg == "full");
    onUpdate?.call();
  }

  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder()..addString(message);
    client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
  }

  void _onConnected() => print('MQTT Connected');
  void _onDisconnected() => _connected = false;

  String _generateClientId() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyyMMddHHmmss');
    final random = Random().nextInt(99999);
    return 'client-\${formatter.format(now)}-\$random';
  }
}
