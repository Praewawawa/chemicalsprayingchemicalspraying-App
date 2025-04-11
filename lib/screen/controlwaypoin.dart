import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:chemicalspraying/router/routes.gr.dart';
import 'package:chemicalspraying/constants/colors.dart'; // <-- เปลี่ยนให้ตรงกับที่เก็บสีในโปรเจกต์ของคุณ

@RoutePage(name: 'ControlwaypointRoute')
class ControlwaypoinPage extends StatefulWidget {
  const ControlwaypoinPage({super.key});

  @override
  State<ControlwaypoinPage> createState() => _ControlwaypoinPageState();
  // <-- เปลี่ยนชื่อ widget
}

class _ControlwaypoinPageState extends State<ControlwaypoinPage> {
  int _selectedIndex = 1; // index ให้ตรงกับ bottom nav
  List<LatLng> waypoints = [];

  // ---- 1. เพิ่มจุด ----
  void _addWaypoint(LatLng point) {
    setState(() {
      waypoints.add(point);
    });
  }

  // ---- 2. ลบจุด ----
  void _removeWaypoint(int index) {
    setState(() {
      waypoints.removeAt(index);
    });
  }

  // ---- 3. ส่ง Waypoints ไปยัง Raspberry Pi ----
  Future<void> _sendToRaspberryPi() async {
    final url = Uri.parse('http://<IP-ADDRESS-PI>:5000/waypoints'); // <-- เปลี่ยนเป็น IP จริงของ Pi

    final data = waypoints
        .map((point) => {'lat': point.latitude, 'lon': point.longitude})
        .toList();

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'waypoints': data}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ส่งข้อมูลสำเร็จ")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ส่งข้อมูลไม่สำเร็จ")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FAFF),
      appBar: AppBar(
        actions: [
        Switch(
          value: true,
          onChanged: (value) {
            if (!value) {
              context.router.replace(const ControlRoute());
            }
          },
          activeColor: Colors.green,
        ),
    ],

        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // --------- Map ---------
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
                // --------- Polyline ---------
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: waypoints,
                      strokeWidth: 3,
                      color: Colors.green,
                    ),
                  ],
                ),
                // --------- Markers ---------
                MarkerLayer(
                  markers: waypoints.asMap().entries.map((entry) {
                    int index = entry.key;
                    LatLng point = entry.value;
                    return Marker(
                      point: point,
                      width: 40,
                      height: 40,
                      child: GestureDetector(
                          onLongPress: () => _removeWaypoint(index),
                          child: const Icon(Icons.location_on, color: Colors.green, size: 40),
                      ),
                  );
                  }).toList(),
                ),
              ],
            ),
          ),
          // --------- Info ---------
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFF0FAFF),
              border: Border(top: BorderSide(color: Colors.grey)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "${waypoints.length} Waypoints  |  Lat ${waypoints.isNotEmpty ? waypoints.last.latitude.toStringAsFixed(6) : '-'}  |  Lon ${waypoints.isNotEmpty ? waypoints.last.longitude.toStringAsFixed(6) : '-'}",
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(width: 8),
                const Text("Relay"),
                const SizedBox(width: 4),
                SizedBox(
                  width: 60,
                  height: 30,
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                    ),
                    controller: TextEditingController(text: "5000"),
                  ),
                ),
              ],
            ),
          ),
          // --------- Control Buttons ---------
          Row(
            children: [
          const SizedBox(width: 8),
          Expanded(           
            child: ElevatedButton(
              onPressed: _sendToRaspberryPi,
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                minimumSize: const Size(60, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'เริ่ม',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() => waypoints.clear());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                minimumSize: const Size(60, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'ยกเลิก',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

            ],
          ),
        ],
      ),
    );
  }
}
