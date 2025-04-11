import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../router/routes.gr.dart';
import 'package:chemicalspraying/router/routes.gr.dart';
import 'package:chemicalspraying/constants/colors.dart'; // เปลี่ยนให้ตรงกับที่เก็บสีในโปรเจกต์ของคุณ

@RoutePage(name: 'ControlRoute') // ตั้งชื่อ route ได้ตามใจ
class ControlScreen extends StatefulWidget { // ← ชื่อ Widget จริง ต้องไม่ใช้ชื่อ route
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  int _selectedIndex = 1;

  final List<PageRouteInfo> _routes = [
    AddprofileRoute(),               // 0 -> Home
    ControlRoute(),                  // 1 -> Control
    NotificationRoute(),             // 2 -> Notification (แจ้งเตือน)
    NotificationSettingRoute(),      // 3 -> Setting (ตั้งค่า)
    ProfileRoute(),                  // 4 -> Profile
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
    backgroundColor: const Color(0xFFF0FAFF),
    appBar: AppBar(
      actions: [
    Switch(
      value: false,
      onChanged: (value) {
        if (value) {
          context.router.replace(const ControlwaypointRoute());
          // เปลี่ยนหน้าไปที่ ControlWaypointRoute
        }
      },
      activeColor: Colors.green,
    ),
],
    ),
    body: Column(
      children: [
        SizedBox(height: 8),
        // Control Pad
        Center(
          child: Column(
            children: [
              Icon(Icons.arrow_drop_up, size: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_left, size: 40),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[400],
                    ),
                    child: Text("Auto"),
                  ),
                  Icon(Icons.arrow_right, size: 40),
                ],
              ),
              Icon(Icons.arrow_drop_down, size: 40),
            ],
          ),
        ),
        SizedBox(height: 20),
        // Status
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatusCard(title: 'ความเร็วลม', value: '4.23 km/s'),
            _StatusCard(title: 'แบตเตอรี่', value: '100%'),
            _StatusCard(title: 'ปริมาณสารเคมี', value: '100%'),
          ],
        ),
        SizedBox(height: 20),
        // Timer
        _TimerControl(),
        SizedBox(height: 20),
        // Speed
        _SpeedControl(),
      ],
    ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: mainColor,         // ✅ สีไอคอนที่ถูกเลือก
        unselectedItemColor: grayColor,       // ✅ สีไอคอนที่ไม่ถูกเลือก
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
/*import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../router/routes.gr.dart';
import 'package:chemicalspraying/router/routes.gr.dart';

@RoutePage(name: 'ControlRoute') // ตั้งชื่อ route ได้ตามใจ
class ControlPage extends StatelessWidget {
  const ControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ควบคุม")),
      body: const Center(child: Text("Control Page")),
    );
  }
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
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {},
      ),
      actions: [
    Switch(
      value: false,
      onChanged: (value) {
        if (value) {
          context.router.replace(const ControlwaypointRoute());
          // เปลี่ยนหน้าไปที่ ControlWaypointRoute
        }
      },
      activeColor: Colors.green,
    ),
],
    ),
    body: Column(
      children: [
        SizedBox(height: 8),
        // Control Pad
        Center(
          child: Column(
            children: [
              Icon(Icons.arrow_drop_up, size: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_left, size: 40),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[400],
                    ),
                    child: Text("Auto"),
                  ),
                  Icon(Icons.arrow_right, size: 40),
                ],
              ),
              Icon(Icons.arrow_drop_down, size: 40),
            ],
          ),
        ),
        SizedBox(height: 20),
        // Status
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatusCard(title: 'ความเร็วลม', value: '4.23 km/s'),
            _StatusCard(title: 'แบตเตอรี่', value: '100%'),
            _StatusCard(title: 'ปริมาณสารเคมี', value: '100%'),
          ],
        ),
        SizedBox(height: 20),
        // Timer
        _TimerControl(),
        SizedBox(height: 20),
        // Speed
        _SpeedControl(),
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
}*/
