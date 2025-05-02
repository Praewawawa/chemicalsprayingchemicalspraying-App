// screen/controlwaypoin.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:chemicalspraying/router/routes.gr.dart';
import 'package:chemicalspraying/constants/colors.dart'; // <-- เปลี่ยนให้ตรงกับที่เก็บสีในโปรเจกต์ของคุณ
import 'package:flutter/cupertino.dart';
import 'package:chemicalspraying/services/api_service.dart'; // <-- เพิ่ม import สำหรับ API service


@RoutePage(name: 'ControlwaypointRoute')
class ControlwaypoinPage extends StatefulWidget {
  const ControlwaypoinPage({super.key});

  @override
  State<ControlwaypoinPage> createState() => _ControlwaypoinPageState();
  // <-- เปลี่ยนชื่อ widget
}


class _ControlwaypoinPageState extends State<ControlwaypoinPage> {
  int _selectedIndex = 1;
  List<LatLng> waypoints = [];
  LatLng? currentPosition;
  int currentWaypointIndex = 0;
  


  
// ---- เพิ่มจุดมาร์ก waypoint ----

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

  
  void startVehicleSimulation() {
    if (waypoints.isEmpty) return;

    currentWaypointIndex = 0;

    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (currentWaypointIndex >= waypoints.length) {
        timer.cancel();
        return;
      }

      setState(() {
        currentPosition = waypoints[currentWaypointIndex];
      });

      currentWaypointIndex++;
    });
  }

  // ---- 3. ฟังก์ชันส่ง waypoint ทีละจุดไปที่ API ----
  Future<void> sendWaypointsToServer() async {
    try {
      for (LatLng point in waypoints) {
        await ApiService.post(
          '/gps',
          {
            "device_id": 1,
            "lat": point.latitude,
            "lng": point.longitude,
            "timestamp": DateTime.now().toIso8601String()
          },
        );
      }

      await ApiService.post(
        '/control',
        {
          "device_id": 1,
          "mode": "Auto"
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ส่ง Waypoints ไปยังเซิร์ฟเวอร์สำเร็จ")),
      );
    } catch (e) {
      print("❌ Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("เกิดข้อผิดพลาดในการส่งข้อมูล")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FAFF),
      appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 70, // เพิ่มความสูงสำหรับ ListTile
      automaticallyImplyLeading: false,
      title: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        trailing: CupertinoSwitch(
          value: true,
          onChanged: (value) {
            if (!value) {
              context.router.replace(const ControlRoute()); // <-- เปลี่ยนเป็นหน้าที่ต้องการเมื่อปิดสวิตช์
            }
          },
          activeColor: mainColor,     // ใช้ mainColor ที่กำหนดไว้ใน constants/colors.dart
          thumbColor: Colors.white,
          trackColor: Colors.black12,
        ),
      ),
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
              
              // --------- Polyline สีเขียว-เทา ---------
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: waypoints.sublist(0, currentWaypointIndex.clamp(0, waypoints.length)),
                    strokeWidth: 3,
                    color: Colors.grey,
                  ),
                  Polyline(
                    points: waypoints.sublist(currentWaypointIndex.clamp(0, waypoints.length)),
                    strokeWidth: 3,
                    color: Colors.green,
                  ),
                ],
              ),
  
              
              // --------- Markers Waypoints ---------

              MarkerLayer(
            markers: [
              if (currentPosition != null)
                Marker(
                  point: currentPosition!,
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.directions_car, color: Colors.blue, size: 36),
                ),
              ...waypoints.asMap().entries.map((entry) {
                int index = entry.key;
                LatLng point = entry.value;
                return Marker(
                  point: point,
                  width: 40,
                  height: 40,
                  child: GestureDetector(
                    onLongPress: () => _removeWaypoint(index),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(Icons.location_on, color: Colors.green, size: 40),
                        Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
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
                onPressed: () {
                  sendWaypointsToServer();
                  startVehicleSimulation();
                },
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

