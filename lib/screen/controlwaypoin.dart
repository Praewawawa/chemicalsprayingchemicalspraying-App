// screen/controlwaypoin.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;

class WaypointMapTemplate extends StatefulWidget {
  const WaypointMapTemplate({super.key});

  @override
  State<WaypointMapTemplate> createState() => _WaypointMapTemplateState();
}

class _WaypointMapTemplateState extends State<WaypointMapTemplate> {
  List<LatLng> waypoints = [];

  // Add waypoint
  void _addWaypoint(LatLng point) {
    setState(() {
      waypoints.add(point);
    });
  }

  // Remove waypoint
  void _removeWaypoint(int index) {
    setState(() {
      waypoints.removeAt(index);
    });
  }

  // Save waypoints to file
  Future<void> _saveWaypoints() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/waypoints.json');
    final data = waypoints
        .map((point) => {'lat': point.latitude, 'lon': point.longitude})
        .toList();
    await file.writeAsString(jsonEncode({'waypoints': data}));
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('บันทึกสำเร็จ')));
  }

  // Load waypoints from file
  Future<void> _loadWaypoints() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/waypoints.json');
    if (!file.existsSync()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('ไฟล์ไม่พบ')));
      return;
    }
    final data = jsonDecode(await file.readAsString());
    setState(() {
      waypoints = List.from(data['waypoints'])
          .map((e) => LatLng(e['lat'], e['lon']))
          .toList();
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('โหลดสำเร็จ')));
  }

  // Publish waypoints via MQTT
  Future<void> _publishWaypoints() async {
    final client = mqtt.MqttClient('broker.hivemq.com', '');
    client.logging(on: false);
    client.port = 1883;
    client.keepAlivePeriod = 20;
    client.onDisconnected = () {
      print('MQTT Disconnected');
    };

    try {
      await client.connect();
    } catch (e) {
      print('MQTT Connection failed: $e');
      client.disconnect();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('เชื่อมต่อ MQTT ไม่สำเร็จ')),
      );
      return;
    }

    final topic = 'chemicalspraying/waypoints';
    final payload = jsonEncode({
      'waypoints': waypoints
          .map((p) => {'lat': p.latitude, 'lon': p.longitude})
          .toList()
    });

    final builder = mqtt.MqttClientPayloadBuilder();
    builder.addString(payload);

    client.publishMessage(topic, mqtt.MqttQos.atLeastOnce, builder.payload!);
    print('Published waypoints to $topic');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ส่ง Waypoints ไปยัง MQTT Broker เรียบร้อย')),
    );

    await Future.delayed(const Duration(seconds: 1));
    client.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FAFF),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Waypoint Map Template'),
        actions: [
          IconButton(onPressed: _saveWaypoints, icon: const Icon(Icons.save)),
          IconButton(onPressed: _loadWaypoints, icon: const Icon(Icons.folder_open)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(19.0332772, 99.89286762),
                initialZoom: 13.0,
                interactionOptions: const InteractionOptions(
                  flags: ~InteractiveFlag.doubleTapZoom,
                ),
                onTap: (tapPosition, point) {
                  _addWaypoint(point);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(points: waypoints, strokeWidth: 3, color: Colors.green),
                  ],
                ),
                MarkerLayer(
                  markers: waypoints.asMap().entries.map((entry) {
                    int index = entry.key;
                    LatLng point = entry.value;
                    return Marker(
                      point: point,
                      width: 40,
                      height: 40,
                      builder: (ctx) => GestureDetector(
                        onLongPress: () => _removeWaypoint(index),
                        child: const Icon(Icons.location_on, color: Colors.green, size: 40),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: _publishWaypoints,
                    child: const Text("ส่งไป Pi"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    onPressed: () => setState(() => waypoints.clear()),
                    child: const Text("ล้างทั้งหมด"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
