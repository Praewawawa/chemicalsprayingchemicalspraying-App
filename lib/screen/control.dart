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
  Timer? _sendTimer;

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
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void sendArm() => sendCommand("arm");
  void sendDisarm() => sendCommand("disarm");

// ฟังก์ชันนี้จะถูกเรียกเมื่อปุ่มถูกกด
  void _startSendingCommand(String command) {
    sendCommand(command);
    _holdTimer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      sendCommand(command);
    });
  }

// ฟังก์ชันนี้จะถูกเรียกเมื่อปุ่มถูกปล่อย
  void _stopSendingCommand() {
    _holdTimer?.cancel();
    _holdTimer = null;
    sendCommand("stop");
  }

// ฟังก์ชันนี้จะถูกเรียกเมื่อมีการเลือก BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    context.router.replace(_routes[index]);
  }




  @override
  void dispose() {
    _holdTimer?.cancel(); // ✅ เคลียร์ Timer
    super.dispose();
  }

// ฟังก์ชันนี้จะถูกเรียกเมื่อ Widget ถูกสร้าง
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

// ฟังก์ชันนี้ใช้สำหรับการ Padding รอบๆ Widget
  Widget _padded(Widget child) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: child,
    );
  }
// ฟังก์ชันนี้ใช้สำหรับการสร้างปุ่มทิศทาง
Widget _directionButton(IconData icon, String command) {
  return InkWell(
    onTapDown: (_) => _startSendingCommand(command),
    onTapUp: (_) => _stopSendingCommand(),
    onTapCancel: () => _stopSendingCommand(),
    borderRadius: BorderRadius.circular(12),  // ให้ effect อยู่ในกรอบมุมโค้ง
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



  // สำหรับปุ่ม STOP
Widget _stopButton() {
  return InkWell(
    onTap: () => sendCommand("stop"),
    borderRadius: BorderRadius.circular(12), // ให้ ripple อยู่ในกรอบมุมโค้ง
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

// สำหรับปุ่ม ARM และ DISARM
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
