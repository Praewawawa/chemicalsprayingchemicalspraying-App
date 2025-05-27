// screen/control.dart
import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chemicalspraying/constants/colors.dart';
import 'package:http/http.dart' as http;
import '../router/routes.gr.dart';
import 'dart:convert';

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
    NotificationRoute(),
    ProfileRoute(),
  ];

  Future<void> sendCommand(String command) async {
    print('👉 ส่ง: $command');
    final url = Uri.parse('http://192.168.137.207:5000/control');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"direction": command}),
      );
      if (response.statusCode == 200) {
        print('✅ สำเร็จ: $command');
      } else {
        print('❌ ล้มเหลว: ${response.statusCode}');
        showErrorDialog('server error: ${response.statusCode}');
      }
    } catch (e) {
      print('❗ error: $e');
      showErrorDialog('ไม่สามารถเชื่อมต่อกับ server: $e');
    }
  }

  void showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void sendArm() => sendCommand("arm");
  void sendDisarm() => sendCommand("disarm");

  // เริ่มส่งคำสั่งซ้ำทุก 200ms ขณะกดปุ่ม
  void _startSendingCommand(String command) {
    if (_holdTimer != null) return; // ป้องกัน Timer ซ้อนกัน
    sendCommand(command);
    _holdTimer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      sendCommand(command);
    });
  }

  // หยุดส่งคำสั่งและส่งคำสั่ง stop
  void _stopSendingCommand() {
    _holdTimer?.cancel();
    _holdTimer = null;
    sendCommand("stop");
  }

  // เมื่อกดเลือกแท็บ
  void _onItemTapped(int index) {
    if (_selectedIndex == index) return; // ไม่เปลี่ยน route ถ้าเลือกแท็บเดิม
    setState(() {
      _selectedIndex = index;
    });
    context.router.replace(_routes[index]);
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    super.dispose();
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
              onChanged: (value) {
                setState(() => isCustomMode = value);
                if (value) {
                  context.router.replace(const ControlwaypointRoute());
                } else {
                  context.router.replace(const ControlRoute());
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
          const Spacer(),
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
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _actionButton("ARM", Colors.green, sendArm),
              const SizedBox(width: 20),
              _actionButton("DISARM", Colors.amber, sendDisarm),
            ],
          ),
          const SizedBox(height: 160),
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

  // Padding รอบๆ Widget
  Widget _padded(Widget child) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: child,
    );
  }

  // ปุ่มทิศทาง ใช้ GestureDetector เพื่อจับการกดค้างและปล่อยปุ่ม
  Widget _directionButton(IconData icon, String command) {
    return SizedBox(
      width: 60,
      height: 60,
      child: GestureDetector(
        onTapDown: (_) => _startSendingCommand(command),
        onTapUp: (_) => _stopSendingCommand(),
        onTapCancel: () => _stopSendingCommand(),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.zero,
            elevation: 4,
          ),
          child: Icon(icon, size: 28, color: Colors.black87),
        ),
      ),
    );
  }

  // ปุ่ม STOP
  Widget _stopButton() {
    return SizedBox(
      width: 60,
      height: 60,
      child: ElevatedButton(
        onPressed: () => sendCommand("stop"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          padding: EdgeInsets.zero,
        ),
        child: const Text(
          'STOP',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // ปุ่ม ARM และ DISARM
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
