// screen/control.dart
import 'dart:async'; // 👈 สำหรับ Timer
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chemicalspraying/constants/colors.dart';
import 'package:http/http.dart' as http;
import '../router/routes.gr.dart';
import 'dart:convert';
import 'package:chemicalspraying/services/api_service.dart'; // ✅ เพิ่ม


@RoutePage(name: 'ControlRoute')
class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  int _selectedIndex = 1;
  bool isCustomMode = false;
  Timer? _holdTimer;

  final List<PageRouteInfo> _routes = [
    AddprofileRoute(),
    ControlRoute(),
    NotificationSettingRoute(),
    NotificationRoute(),
    ProfileRoute(),
  ];

// ✅ ฟังก์ชันตั้งค่าโหมด
  Future<void> setControlMode(String mode) async {
  try {
    await ApiService.post('/control', {
      "device_id": 1, // เปลี่ยนเป็น device จริง
      "mode": mode,
    });
    print('✅ ตั้งค่าโหมดสำเร็จ: $mode');
  } catch (e) {
    print('❌ ตั้งค่าโหมดล้มเหลว: $e');
  }
}

// ✅ ฟังก์ชันดึงโหมดปัจจุบัน
Future<void> getControlMode() async {
  try {
    final data = await ApiService.get('/control/1'); // เปลี่ยน device_id
    setState(() {
      isCustomMode = (data['mode'] == "Auto");
    });
    print('🎛 โหมดปัจจุบัน: ${data['mode']}');
  } catch (e) {
    print('❌ ดึงโหมดล้มเหลว: $e');
  }
}


  // ✅ ส่งคำสั่ง HTTP ไปยัง Flask Server
  Future<void> sendCommand(String command) async {
    print('👉 ส่ง: $command');
    final url = Uri.parse('http://192.168.46.46:5000/control'); // ปรับตาม IP จริง
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"direction": command}),
      );
      if (response.statusCode == 200) {
        print('✅ สำเร็จ: $command');
      } else {
        print('❌ ล้มเหลว: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❗ error: $e');
    }
  }

  void sendArm() => sendCommand("ARM");  // ใช้คำสั่ง "ARM" แทน "arm"
  void sendDisarm() => sendCommand("DISARM");  // ใช้คำสั่ง "DISARM"

  void _startSendingCommand(String command) {
    sendCommand(command); // ส่งทันทีรอบแรก
    _holdTimer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      sendCommand(command);
    });
  }

  void _stopSendingCommand() {
    _holdTimer?.cancel();
    _holdTimer = null;
    sendCommand("stop");
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    context.router.replace(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FAFF),
      appBar: AppBar(
        title: const Text(
          "RC Control Panel",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CupertinoSwitch(
              value: isCustomMode,
              onChanged: (value) async {
              setState(() => isCustomMode = value);

              await setControlMode(value ? "Auto" : "Manual"); // ✅ อัปเดตโหมดไป Node.js

              if (value) {
                context.router.replace(const ControlwaypointRoute());
              }
            },

              activeColor: Colors.green,
              thumbColor: Colors.white,
              trackColor: Colors.black12,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _actionButton("ARM", Colors.green, sendArm),
              const SizedBox(width: 20),
              _actionButton("DISARM", Colors.amber, sendDisarm),
            ],
          ),
          const SizedBox(height: 30),
          Center(
            child: Table(
              defaultColumnWidth: const FixedColumnWidth(70),
              children: [
                TableRow(children: [
                  _padded(_directionButton(Icons.north_west, 'forward_left')),
                  _padded(_directionButton(Icons.arrow_upward, 'forward')),
                  _padded(_directionButton(Icons.north_east, 'forward_right')),
                ]),
                TableRow(children: [
                  _padded(_directionButton(Icons.arrow_back, 'left')),
                  _padded(_stopButton()),
                  _padded(_directionButton(Icons.arrow_forward, 'right')),
                ]),
                TableRow(children: [
                  _padded(_directionButton(Icons.south_west, 'backward_left')),
                  _padded(_directionButton(Icons.arrow_downward, 'backward')),
                  _padded(_directionButton(Icons.south_east, 'backward_right')),
                ]),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: mainColor,
        unselectedItemColor: grayColor,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sensors),
            label: 'ควบคุม',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'ตั้งค่า',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: 'แจ้งเตือน',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'โปรไฟล์',
          ),
        ],
      ),
    );
  }

  Widget _padded(Widget child) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: child,
    );
  }

  Widget _directionButton(IconData icon, String command) {
    return GestureDetector(
      onTapDown: (_) => _startSendingCommand(command),
      onTapUp: (_) => _stopSendingCommand(),
      onTapCancel: () => _stopSendingCommand(),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 28, color: Colors.black87),
      ),
    );
  }

  Widget _stopButton() {
    return GestureDetector(
      onTap: () => sendCommand("stop"),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'STOP',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _actionButton(String label, Color color, void Function() onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(120, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
