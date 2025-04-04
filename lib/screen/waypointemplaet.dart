// ✅ Template เต็ม พร้อม Offline Map + Save/Load + MQTT Placeholder

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:mqtt_client/mqtt_client.dart'; <-- ไว้เปิดตอนต้องการใช้ MQTT

class WaypointMapTemplate extends StatefulWidget {
  const WaypointMapTemplate({super.key});

  @override
  State<WaypointMapTemplate> createState() => _WaypointMapTemplateState();
}

class _WaypointMapTemplateState extends State<WaypointMapTemplate> {
  List<LatLng> waypoints = [];

  // ---------------------- Add & Remove Waypoint ----------------------
  void _addWaypoint(LatLng point) {
    setState(() {
      waypoints.add(point);
    });
  }

  void _removeWaypoint(int index) {
    setState(() {
      waypoints.removeAt(index);
    });
  }

  // ---------------------- Save Waypoint ----------------------
  Future<void> _saveWaypoints() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/waypoints.json');
    final data = waypoints
        .map((point) => {'lat': point.latitude, 'lon': point.longitude})
        .toList();
    await file.writeAsString(jsonEncode({'waypoints': data}));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('บันทึกสำเร็จ')));
  }

  // ---------------------- Load Waypoint ----------------------
  Future<void> _loadWaypoints() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/waypoints.json');
    if (!file.existsSync()) return;
    final data = jsonDecode(await file.readAsString());
    setState(() {
      waypoints = List.from(data['waypoints'])
          .map((e) => LatLng(e['lat'], e['lon']))
          .toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('โหลดสำเร็จ')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FAFF),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: const Text('Waypoint Map Template'),
        actions: [
          IconButton(onPressed: _saveWaypoints, icon: const Icon(Icons.save)),
          IconButton(onPressed: _loadWaypoints, icon: const Icon(Icons.folder_open))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(19.0332772, 99.89286762),
                zoom: 16,
                onTap: (tapPosition, point) => _addWaypoint(point),
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
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
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    // <-- future : MQTT Publish
                  },
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
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
 