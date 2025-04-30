// screen/setting.dart
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../router/routes.gr.dart';
import '../constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:chemicalspraying/constants/colors.dart';
import 'package:chemicalspraying/services/api_service.dart'; // ✅ เพิ่ม

@RoutePage(name: 'NotificationSettingRoute')
class NotificationSettingPage extends StatefulWidget {
  const NotificationSettingPage({Key? key}) : super(key: key);

  @override
  State<NotificationSettingPage> createState() => _NotificationSettingPageState();
}

class _NotificationSettingPageState extends State<NotificationSettingPage> {
  int _selectedIndex = 3; // index ของหน้า ตั้งค่า
  bool speedAlert = true;
  bool batteryAlert = false;
  bool chemicalAlert = true;
  bool routeAlert = false;

  final List<PageRouteInfo> _routes = [
    AddprofileRoute(),
    ControlRoute(),
    NotificationSettingRoute(),
    NotificationRoute(),
    ProfileRoute(),
  ];

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings(); // ✅ โหลดข้อมูลจาก API
  }

  Future<void> _loadNotificationSettings() async {
    try {
      final response = await ApiService.get('/notifications/settings/1'); // user_id จริง
      setState(() {
        speedAlert = response['speed_alert'] ?? true;
        batteryAlert = response['battery_alert'] ?? false;
        chemicalAlert = response['chemical_alert'] ?? true;
        routeAlert = response['route_alert'] ?? false;
      });
    } catch (e) {
      print("❌ Load failed: $e");
    }
  }

  Future<void> _saveNotificationSettings() async {
    try {
      await ApiService.put('/notifications/settings/1', {
        'speed_alert': speedAlert,
        'battery_alert': batteryAlert,
        'chemical_alert': chemicalAlert,
        'route_alert': routeAlert,
      });
    } catch (e) {
      print("❌ Save failed: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    context.router.replace(_routes[index]);
  }

  Widget buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeColor: mainColor,
            thumbColor: Colors.white,
            trackColor: Colors.black12,
          ),
        ),
        const Divider(thickness: 1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ตั้งค่าการแจ้งเตือน',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xFFF5FAFF),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildSwitchTile(
              title: "ข้อความแจ้งเตือนความเร็วลม",
              subtitle: "แจ้งเตือนเมื่อความเร็วลมเกินกำหนด",
              value: speedAlert,
              onChanged: (value) {
                setState(() => speedAlert = value);
                _saveNotificationSettings();
              },
            ),
            buildSwitchTile(
              title: "ข้อความแจ้งเตือนปริมาณแบตเตอรี่",
              subtitle: "แจ้งเตือนเมื่อแบตเตอรี่ต่ำ",
              value: batteryAlert,
              onChanged: (value) {
                setState(() => batteryAlert = value);
                _saveNotificationSettings();
              },
            ),
            buildSwitchTile(
              title: "ข้อความแจ้งเตือนปริมาณสารเคมี",
              subtitle: "แจ้งเตือนเมื่อปริมาณสารเคมีต่ำ",
              value: chemicalAlert,
              onChanged: (value) {
                setState(() => chemicalAlert = value);
                _saveNotificationSettings();
              },
            ),
            buildSwitchTile(
              title: "ข้อความแจ้งเตือนเส้นทางการเดินรถ",
              subtitle: "แจ้งเตือนเมื่อรถออกนอกเส้นทาง",
              value: routeAlert,
              onChanged: (value) {
                setState(() => routeAlert = value);
                _saveNotificationSettings();
              },
            ),
          ],
        ),
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
}
