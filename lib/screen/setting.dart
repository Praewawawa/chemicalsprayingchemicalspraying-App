import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../router/routes.gr.dart';
import '../constants/colors.dart';

@RoutePage(name: 'NotificationSettingRoute')
class NotificationSettingPage extends StatefulWidget {
  const NotificationSettingPage({Key? key}) : super(key: key);

  @override
  State<NotificationSettingPage> createState() => _NotificationSettingPageState();
}

class _NotificationSettingPageState extends State<NotificationSettingPage> {
  int _selectedIndex = 1; // index ของหน้า ตั้งค่า
  bool speedAlert = true;
  bool batteryAlert = true;
  bool chemicalAlert = true;
  bool routeAlert = true;

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
        title: const Text('ตั้งค่าการแจ้งเตือน',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF5FAFF),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildSwitchTile(
              title: "ข้อความแจ้งเตือนความเร็วลม",
              subtitle: "ข้อความแจ้งเตือนเมื่อความเร็วลมเกินกำหนด",
              value: speedAlert,
              onChanged: (value) => setState(() => speedAlert = value),
            ),
            buildSwitchTile(
              title: "ข้อความแจ้งเตือนปริมาณแบตเตอรี่",
              subtitle: "ข้อความแจ้งเตือนเมื่อปริมาณแบตเตอรี่ต่ำกว่ากำหนด",
              value: batteryAlert,
              onChanged: (value) => setState(() => batteryAlert = value),
            ),
            buildSwitchTile(
              title: "ข้อความแจ้งเตือนปริมาณสารเคมี",
              subtitle: "ข้อความแจ้งเตือนเมื่อปริมาณสารเคมีต่ำกว่ากำหนด",
              value: chemicalAlert,
              onChanged: (value) => setState(() => chemicalAlert = value),
            ),
            buildSwitchTile(
              title: "ข้อความแจ้งเตือนเส้นทางการเดินรถ",
              subtitle: "ข้อความแจ้งเตือนเมื่อรถออกนอกเส้นทาง",
              value: routeAlert,
              onChanged: (value) => setState(() => routeAlert = value),
            ),
          ],
        ),
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

  Widget buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.green,
      ),
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../router/routes.gr.dart';

@RoutePage(name: 'NotificationSettingRoute')
class NotificationSettingPage extends StatelessWidget {
  const NotificationSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ตั้งค่าการแจ้งเตือน")),
      body: const Center(child: Text("Notification Setting Page")),
    );
  }
}

class _NotificationSettingPageState extends State<NotificationSettingPage> {
  int _selectedIndex = 1; // index ของหน้า ตั้งค่า
  bool speedAlert = true;
  bool batteryAlert = true;
  bool chemicalAlert = true;
  bool routeAlert = true;



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
        title: const Text('ตั้งค่าการแจ้งเตือน',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF5FAFF),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildSwitchTile(
              title: "ข้อความแจ้งเตือนความเร็วลม",
              subtitle: "ข้อความแจ้งเตือนเมื่อความเร็วลมเกินกำหนด",
              value: speedAlert,
              onChanged: (value) => setState(() => speedAlert = value),
            ),
            buildSwitchTile(
              title: "ข้อความแจ้งเตือนปริมาณแบตเตอรี่",
              subtitle: "ข้อความแจ้งเตือนเมื่อปริมาณแบตเตอรี่ต่ำกว่ากำหนด",
              value: batteryAlert,
              onChanged: (value) => setState(() => batteryAlert = value),
            ),
            buildSwitchTile(
              title: "ข้อความแจ้งเตือนปริมาณสารเคมี",
              subtitle: "ข้อความแจ้งเตือนเมื่อปริมาณสารเคมีต่ำกว่ากำหนด",
              value: chemicalAlert,
              onChanged: (value) => setState(() => chemicalAlert = value),
            ),
            buildSwitchTile(
              title: "ข้อความแจ้งเตือนเส้นทางการเดินรถ",
              subtitle: "ข้อความแจ้งเตือนเมื่อรถออกนอกเส้นทาง",
              value: routeAlert,
              onChanged: (value) => setState(() => routeAlert = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.green,
      ),
    );
  }
}*/
