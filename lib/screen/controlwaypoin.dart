// screen/controlwaypoin.dart
import 'dart:async';
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:chemicalspraying/router/routes.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:chemicalspraying/constants/colors.dart';
import 'package:chemicalspraying/screen/mqtt_service.dart';

class ControlwaypoinPage extends StatefulWidget {
  const ControlwaypoinPage({super.key});

  @override
  State<ControlwaypoinPage> createState() => _ControlwaypoinPageState();
}

class Waypoint {
  final double latitude;
  final double longitude;
  final double altitude;

  Waypoint({
    required this.latitude,
    required this.longitude,
    required this.altitude,
  });

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'altitude': altitude,
      };

  factory Waypoint.fromJson(Map<String, dynamic> json) => Waypoint(
        latitude: json['latitude'],
        longitude: json['longitude'],
        altitude: json['altitude'],
      );
}

class _ControlwaypoinPageState extends State<ControlwaypoinPage> {
  List<Waypoint> waypoints = [];
  LatLng? currentPosition;
  final MqttService mqtt = MqttService();
  final MapController _mapController = MapController();
  String _statusMessage = '';
  bool _isLoading = false;
  bool _isSystemRunning = false;
  bool _mqttConnected = false;

  StreamSubscription<LatLng?>? positionSubscription;
  Timer? _connectionCheckTimer;

  final TextEditingController altitudeController =
      TextEditingController(text: "5");

  @override
  void initState() {
    super.initState();
    //currentPosition = LatLng(19.0539432, 99.9395183);
    loadWaypoints();
    initMqttAndListen();
  }

  @override
  void dispose() {
    positionSubscription?.cancel();
    _connectionCheckTimer?.cancel();
    mqtt.disconnect();
    altitudeController.dispose();
    super.dispose();
  }

  Future<void> saveWaypoints() async {
    final prefs = await SharedPreferences.getInstance();
    final waypointList = waypoints.map((w) => w.toJson()).toList();
    await prefs.setString('saved_waypoints', jsonEncode(waypointList));
  }

  Future<void> loadWaypoints() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('saved_waypoints');
    if (jsonString != null) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      setState(() {
        waypoints = decoded.map((e) => Waypoint.fromJson(e)).toList();
      });
    }
  }

  Future<void> initMqttAndListen() async {
    while (mounted && !_mqttConnected) {
      try {
        await mqtt.connect();
        if (mqtt.isConnected) {
          setState(() {
            _mqttConnected = true;
            _statusMessage = "MQTT เชื่อมต่อสำเร็จ";
          });
          break;
        }
      } catch (e) {
        setState(() {
          _statusMessage = "พยายามเชื่อมต่อ MQTT ล้มเหลว: $e";
        });
      }
      await Future.delayed(const Duration(seconds: 5));
    }

    positionSubscription = mqtt.currentPositionStream.listen((pos) {
      if (pos != null) {
        setState(() {
          currentPosition = pos;
        });
        _mapController.move(pos, _mapController.camera.zoom);
      }
    });

    _connectionCheckTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (mqtt.isConnected != _mqttConnected) {
        setState(() {
          _mqttConnected = mqtt.isConnected;
          if (!_mqttConnected) {
            _statusMessage = "MQTT หลุดการเชื่อมต่อ กำลังพยายามเชื่อมต่อใหม่...";
            reconnectMqtt();
          } else {
            _statusMessage = "MQTT เชื่อมต่อแล้ว";
          }
        });
      }
    });
  }

  void reconnectMqtt() async {
    while (mounted && !_mqttConnected) {
      try {
        await mqtt.connect();
        if (mqtt.isConnected) {
          setState(() {
            _mqttConnected = true;
            _statusMessage = "MQTT เชื่อมต่อใหม่สำเร็จ";
          });
          break;
        }
      } catch (e) {
        setState(() {
          _statusMessage = "พยายามเชื่อมต่อ MQTT ใหม่ล้มเหลว: $e";
        });
      }
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  void _addWaypoint(LatLng point) {
    double altitude = 5;

    try {
      altitude = double.parse(altitudeController.text);
    } catch (_) {}

    setState(() {
      waypoints.add(Waypoint(
        latitude: point.latitude,
        longitude: point.longitude,
        altitude: altitude,
      ));
    });
    saveWaypoints();
  }

  void _removeWaypoint(int index) {
    setState(() {
      waypoints.removeAt(index);
    });
    saveWaypoints();
  }

  Future<void> _editWaypointDialog(int index) async {
    final wp = waypoints[index];

    final latController =
        TextEditingController(text: wp.latitude.toStringAsFixed(10));
    final lonController =
        TextEditingController(text: wp.longitude.toStringAsFixed(10));
    final altController =
        TextEditingController(text: wp.altitude.toString());

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("แก้ไข Waypoint"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: latController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: "Latitude"),
              ),
              TextField(
                controller: lonController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: "Longitude"),
              ),
              TextField(
                controller: altController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: "Altitude (m)"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("ยกเลิก"),
            ),
            ElevatedButton(
              onPressed: () {
                final double? lat = double.tryParse(latController.text);
                final double? lon = double.tryParse(lonController.text);
                final double? alt = double.tryParse(altController.text);

                if (lat == null || lon == null || alt == null) {
                  setState(() {
                    _statusMessage = "ค่าที่กรอกไม่ถูกต้อง";
                  });
                  return;
                }

                setState(() {
                  waypoints[index] = Waypoint(
                    latitude: lat,
                    longitude: lon,
                    altitude: alt,
                  );
                  _statusMessage = "แก้ไข Waypoint สำเร็จ";
                });

                saveWaypoints();
                Navigator.of(context).pop();
              },
              child: const Text("บันทึก"),
            ),
          ],
        );
      },
    );
  }

  void publishMission(List<Waypoint> mission) {
    if (!_mqttConnected) {
      setState(() {
        _statusMessage = "MQTT ยังไม่เชื่อมต่อ ไม่สามารถส่ง Waypoints ได้";
      });
      return;
    }

    final missionList = mission
        .map((point) => {
              "latitude": point.latitude,
              "longitude": point.longitude,
              "altitude": point.altitude,
            })
        .toList();

    final msg = jsonEncode({"mission": missionList});
    mqtt.publish("waypoint/control/target", msg);

    setState(() {
      _statusMessage = "ส่ง Waypoints สำเร็จ";
    });
  }

  void toggleSystem() {
    if (!_mqttConnected) {
      setState(() {
        _statusMessage = "MQTT ยังไม่เชื่อมต่อ ไม่สามารถสั่งงานระบบได้";
      });
      return;
    }

    setState(() {
      _isSystemRunning = !_isSystemRunning;
      _statusMessage = '';
    });

    mqtt.publish(
        "system/control",
        jsonEncode({
          "command":
              _isSystemRunning ? "waypointcontrol_start" : "waypointcontrol_stop"
        }));
  }

  Widget _buildStartStopButton() {
    return ElevatedButton(
      onPressed: _mqttConnected && !_isLoading ? toggleSystem : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: _isSystemRunning ? Colors.red : mainColor,
        minimumSize: const Size(60, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        _isSystemRunning ? 'หยุด' : 'เริ่ม',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMqttStatus() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(
            _mqttConnected ? Icons.cloud_done : Icons.cloud_off,
            color: _mqttConnected ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Text(
            _mqttConnected ? "MQTT: เชื่อมต่อแล้ว" : "MQTT: ยังไม่เชื่อมต่อ",
            style: TextStyle(
              color: _mqttConnected ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
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
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                context.router.replace(const ControlRoute());
              },
            ),
            const Spacer(),
            const Text(
              'Control Waypoint',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildMqttStatus(),
          Expanded(
            flex: 3,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: currentPosition ?? LatLng(0.0, 0.0),
                initialZoom: 16,
                onTap: (tapPosition, point) => _addWaypoint(point),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: waypoints
                          .map((w) => LatLng(w.latitude, w.longitude))
                          .toList(),
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
                      Waypoint point = entry.value;
                      return Marker(
                        point: LatLng(point.latitude, point.longitude),
                        width: 40,
                        height: 40,
                        child: GestureDetector(
                          onLongPress: () => _removeWaypoint(index),
                          onTap: () => _editWaypointDialog(index),
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
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 120),
            child: ListView.builder(
              itemCount: waypoints.length,
              itemBuilder: (context, index) {
                final wp = waypoints[index];
                return ListTile(
                  dense: true,
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: -4),
                  title: Text(
                    'Waypoint ${index + 1}: '
                    'Lat ${wp.latitude.toStringAsFixed(10)}, '
                    'Lon ${wp.longitude.toStringAsFixed(10)}, '
                    'Alt ${wp.altitude} m',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon:
                            const Icon(Icons.edit, color: Colors.blue, size: 20),
                        onPressed: () => _editWaypointDialog(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete,
                            color: Colors.red, size: 20),
                        onPressed: () => _removeWaypoint(index),
                      ),
                    ],
                  ),
                );
              },
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
                    "${waypoints.length} Waypoints  |  Lat ${waypoints.isNotEmpty ? waypoints.last.latitude.toStringAsFixed(10) : '-'}  |  Lon ${waypoints.isNotEmpty ? waypoints.last.longitude.toStringAsFixed(10) : '-'}  |  Alt ${waypoints.isNotEmpty ? waypoints.last.altitude : '-'}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed:
                      _mqttConnected && waypoints.isNotEmpty && !_isLoading
                          ? () => publishMission(waypoints)
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    minimumSize: const Size(60, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'ส่ง Waypoints',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                _buildStartStopButton(),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              _statusMessage,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              controller: altitudeController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: "Altitude (m)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
