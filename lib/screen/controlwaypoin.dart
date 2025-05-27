// screen/controlwaypoin.dart
import 'dart:async'; 
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:chemicalspraying/constants/colors.dart';
import 'package:chemicalspraying/services/api_service.dart';
import 'package:chemicalspraying/screen/mqtt_service.dart';

@RoutePage(name: 'ControlwaypointRoute')
class ControlwaypoinPage extends StatefulWidget {
  const ControlwaypoinPage({super.key});

  @override
  State<ControlwaypoinPage> createState() => _ControlwaypoinPageState();
}

class _ControlwaypoinPageState extends State<ControlwaypoinPage> {
  List<LatLng> waypoints = [];
  LatLng? currentPosition;
  final MqttService mqtt = MqttService();
  final MapController _mapController = MapController();
  String _statusMessage = '';
  bool _isLoading = false;
  StreamSubscription<LatLng?>? positionSubscription;

  final TextEditingController relayController = TextEditingController(text: "5000");

  @override
  void initState() {
    super.initState();
    initMqttAndListen();
  }

  @override
  void dispose() {
    positionSubscription?.cancel();
    mqtt.disconnect();
    relayController.dispose();
    super.dispose();
  }

  void initMqttAndListen() async {
    await mqtt.connect();

    positionSubscription = mqtt.currentPositionStream.listen((pos) {
      if (pos != null) {
        setState(() {
          currentPosition = pos;
        });
        _mapController.move(pos, _mapController.camera.zoom);
      }
    });
  }

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

  Future<void> sendWaypointsToServerAndMqtt() async {
    setState(() {
      _isLoading = true;
      _statusMessage = "กำลังส่งข้อมูล...";
    });

    try {
      for (LatLng point in waypoints) {
        // ส่งข้อมูลไป server
        await ApiService.post(
          '/gps',
          {
            "device_id": 1,
            "lat": point.latitude,
            "lng": point.longitude,
            "timestamp": DateTime.now().toIso8601String()
          },
        );

        // ส่ง waypoint ผ่าน MQTT ไป topic waypoint/control/target (รูปแบบ JSON)
        mqtt.publishTargetPosition(point);
      }

      // สั่งเปลี่ยน mode เป็น Auto
      await ApiService.post('/control', {
        "device_id": 1,
        "mode": "Auto"
      });

      // สั่งเริ่ม navigation ผ่าน MQTT
      mqtt.publishStartNavigation();

      setState(() {
        _statusMessage = "ส่ง Waypoints สำเร็จ";
      });
    } catch (e) {
      print("❌ Error: $e");
      setState(() {
        _statusMessage = "เกิดข้อผิดพลาดในการส่งข้อมูล";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FAFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        title: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          trailing: CupertinoSwitch(
            value: true,
            onChanged: (value) {
              if (!value) {
                context.router.replaceNamed('/control');
              }
            },
            activeColor: mainColor,
            thumbColor: Colors.white,
            trackColor: Colors.black12,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: currentPosition ?? LatLng(0.0, 0.0),
                initialZoom: 16,
                onTap: (tapPosition, point) => _addWaypoint(point),
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: waypoints,
                      strokeWidth: 3,
                      color: Colors.green,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    if (currentPosition != null)
                      Marker(
                        point: currentPosition!,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.directions_car,
                          color: Colors.blue,
                          size: 36,
                        ),
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
                              const Icon(
                                Icons.location_on,
                                color: Colors.green,
                                size: 40,
                              ),
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
                    controller: relayController,
                  ),
                ),
              ],
            ),
          ),
          if (_statusMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                _statusMessage,
                style: TextStyle(
                  color: _statusMessage.contains("สำเร็จ")
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: CircularProgressIndicator(),
            ),
          Row(
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : sendWaypointsToServerAndMqtt,
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
                  onPressed: _isLoading
                      ? null
                      : () {
                          setState(() {
                            waypoints.clear();
                            _statusMessage = '';
                          });
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
