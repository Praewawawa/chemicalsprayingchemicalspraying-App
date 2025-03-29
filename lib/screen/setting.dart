import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';


@RoutePage( name: 'NotificationSettingRoute') // ใช้ @RoutePage() เพื่อให้ AutoRoute สร้างเส้นทางสำหรับหน้า
/// หน้าแสดงการตั้งค่าการแจ้งเตือน

class NotificationSettingPage extends StatefulWidget {
  const NotificationSettingPage({Key? key}) : super(key: key);

  @override
  State<NotificationSettingPage> createState() => _NotificationSettingPageState();
}

class _NotificationSettingPageState extends State<NotificationSettingPage> {
  bool speedAlert = true;
  bool batteryAlert = true;
  bool chemicalAlert = true;
  bool routeAlert = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFF),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildSwitchTile(
              title: "ข้อความแจ้งเตือนความเร็วลม",
              subtitle: "ข้อความแจ้งเตือนเมื่อความเร็วลมเกินกำหนด",
              value: speedAlert,
              onChanged: (value) {
                setState(() {
                  speedAlert = value;
                });
              },
            ),
            buildSwitchTile(
              title: "ข้อความแจ้งเตือนปริมาณแบตเตอรี่",
              subtitle: "ข้อความแจ้งเตือนเมื่อปริมาณแบตเตอรี่ต่ำกว่ากำหนด",
              value: batteryAlert,
              onChanged: (value) {
                setState(() {
                  batteryAlert = value;
                });
              },
            ),
            buildSwitchTile(
              title: "ข้อความแจ้งเตือนปริมาณสารเคมี",
              subtitle: "ข้อความแจ้งเตือนเมื่อปริมาณสารเคมีต่ำกว่ากำหนด",
              value: chemicalAlert,
              onChanged: (value) {
                setState(() {
                  chemicalAlert = value;
                });
              },
            ),
            buildSwitchTile(
              title: "ข้อความแจ้งเตือนเส้นทางการเดินรถ",
              subtitle: "ข้อความแจ้งเตือนเมื่อรถออกนอกเส้นทาง",
              value: routeAlert,
              onChanged: (value) {
                setState(() {
                  routeAlert = value;
                });
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'ตั้งค่า',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'แจ้งเตือน',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'โปรไฟล์',
          ),
        ],
        currentIndex: 1,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          // สามารถเขียนการเปลี่ยนหน้าได้ตามต้องการ
        },
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
