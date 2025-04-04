
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:chemicalspraying/router/routes.gr.dart'; // ✅ แก้ให้ถูก


@RoutePage(name: 'AddprofileRoute') // <- ให้ auto_route สร้าง AddprofileRoute ให้เรา
class AddprofilePage extends StatefulWidget { // <-- เปลี่ยนชื่อ widget
  AddprofilePage({super.key});

  @override
  State<AddprofilePage> createState() => _AddprofilePageState(

  );
}

class _AddprofilePageState extends State<AddprofilePage> {
  int _selectedIndex = 0;
  // สร้างตัวแปรเพื่อเก็บค่าความเร็วลม
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
      appBar: AppBar(
      ),
      backgroundColor: const Color(0xFFF0FAFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              _buildWindSpeedIndicator(),
              const SizedBox(height: 24),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 3 / 3.2,
                children: const [
                  BatteryCard(),
                  SprayControlCard(),
                  DistanceCard(),
                  ChemicalCard(),
                ],
              ),
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
          BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), label: "แจ้งเตือน"),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: "ตั้งค่า"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "โปรไฟล์"),
        ],
      ),
    );
  }

  Widget _buildWindSpeedIndicator() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.green.shade300, width: 2),
            ),
          ),
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.green, width: 14),
              gradient: RadialGradient(
                colors: [Colors.green.shade50, Colors.white],
                center: Alignment.center,
                radius: 0.9,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('N↑', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              SizedBox(height: 4),
              Text('4.23', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              Text('km/s', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}

class BatteryCard extends StatelessWidget {
  const BatteryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      title: "แบตเตอรี่",
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 150,
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Text("80%", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class SprayControlCard extends StatefulWidget {
  const SprayControlCard({super.key});

  @override
  State<SprayControlCard> createState() => _SprayControlCardState();
}

class _SprayControlCardState extends State<SprayControlCard> {
  int sprayLevel = 2;

  void _increaseLevel() {
    if (sprayLevel < 3) setState(() => sprayLevel++);
  }

  void _decreaseLevel() {
    if (sprayLevel > 1) setState(() => sprayLevel--);
  }

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      title: "ตั้งค่าระบบฉีดพ่น",
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              IconButton(
                onPressed: _increaseLevel,
                icon: const Icon(Icons.arrow_drop_up, color: Colors.green, size: 30),
              ),
              Text("ระดับที่ ${sprayLevel - 1}", style: const TextStyle(color: Colors.grey, fontSize: 14)),
              Text("ระดับที่ $sprayLevel", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text("ระดับที่ ${sprayLevel + 1}", style: const TextStyle(color: Colors.grey, fontSize: 14)),
              IconButton(
                onPressed: _decreaseLevel,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.green, size: 30),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text("เปิด", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Text("สถานะการทำงาน", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }
}

class DistanceCard extends StatelessWidget {
  const DistanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      title: "เส้นทางการทำงาน",
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Icon(Icons.directions_walk),
          Text("10 Km", style: TextStyle(fontWeight: FontWeight.bold)),
          Icon(Icons.arrow_forward_ios, size: 10, color: Colors.green),
        ],
      ),
    );
  }
}

class ChemicalCard extends StatelessWidget {
  const ChemicalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      title: "ปริมาณสารเคมี",
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 150,
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Container(
            height: 80,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Text("50%", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

Widget _buildCard({required String title, required Widget child}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Expanded(child: child),
        ],
      ),
    ),
  );
}