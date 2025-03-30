import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../router/routes.gr.dart';
import 'package:chemicalspraying/router/routes.gr.dart'; // ✅ แก้ให้ถูก

@RoutePage(name: 'ControlRoute')
class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  int _selectedIndex = 1;

  final List<PageRouteInfo> _routes = [
    AddprofileRoute(),
    ControlRoute(),
    NotificationSettingRoute(),
    NotificationSettingRoute(), // เปลี่ยน NotificationRoute -> NotificationSettingRoute ชั่วคราว จนกว่า generate route จริง
    ProfileRoute(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    context.router.replace(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.pop(),
        ),
        title: const Text("ควบคุมการทำงาน"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF0FAFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Switch Mode', style: TextStyle(fontWeight: FontWeight.bold)),
                  Switch(
                    value: true,
                    onChanged: (val) {},
                    activeColor: Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildControlPad(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _StatusCard(title: 'ความเร็วลม', value: '4.23 km/s'),
                  _StatusCard(title: 'แบตเตอรี่', value: '100%'),
                  _StatusCard(title: 'ปริมาณสารเคมี', value: '100%'),
                ],
              ),
              const SizedBox(height: 20),
              const _TimerControl(),
              const SizedBox(height: 20),
              const _SpeedControl(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "หน้าหลัก"),
          BottomNavigationBarItem(icon: Icon(Icons.control_camera_outlined), label: "ควบคุม"),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: "ตั้งค่า"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), label: "แจ้งเตือน"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "โปรไฟล์"),
        ],
      ),
    );
  }

  Widget _buildControlPad() {
    return SizedBox(
      width: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(top: 0, child: _controlButton(Icons.arrow_drop_up)),
          Positioned(bottom: 0, child: _controlButton(Icons.arrow_drop_down)),
          Positioned(left: 0, child: _controlButton(Icons.arrow_left)),
          Positioned(right: 0, child: _controlButton(Icons.arrow_right)),
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.text_fields, color: Colors.grey),
                Text('Auto', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _controlButton(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Icon(icon, color: Colors.white),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatusCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _TimerControl extends StatelessWidget {
  const _TimerControl();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Timer", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Switch(value: true, onChanged: (v) {}, activeColor: Colors.green),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text("00 : 01 : 0"),
            ),
          ],
        ),
      ],
    );
  }
}

class _SpeedControl extends StatelessWidget {
  const _SpeedControl();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Speed", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Switch(value: true, onChanged: (v) {}, activeColor: Colors.green),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text("1"),
            ),
          ],
        ),
      ],
    );
  }
}
