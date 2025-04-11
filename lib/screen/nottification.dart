import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../router/routes.gr.dart';
import 'package:chemicalspraying/router/routes.gr.dart'; // ✅ แก้ให้ถูก
import 'package:chemicalspraying/constants/colors.dart'; // ✅ แก้ให้ถูก

@RoutePage(name: 'NotificationRoute')
class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int _selectedIndex = 2; // index ให้ตรงกับ bottom nav

  // ✅ ต้องใส่ const หน้า route constructor
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
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: DefaultTabController(
              length: 3,
              child: TabBar(
                labelColor: Colors.black,
                indicatorColor: Colors.green,
                tabs: const [
                  Tab(text: "ทั่วไป"),
                  Tab(text: "ปริมาณแบตเตอรี่"),
                  Tab(text: "ปริมาณสารเคมี"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Notification List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildNotificationCard(
                  context,
                  icon: Icons.battery_alert,
                  title: "ปริมาณแบตเตอรี่",
                  subtitle: "ปริมาณแบตเตอรี่ต่ำกว่า 10% โปรดชาร์จแบตเตอรี่ก่อนออกงาน",
                  time: "1 นาทีที่แล้ว",
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationDetailPage(title: "ปริมาณแบตเตอรี่")));
                  },
                ),
                _buildNotificationCard(
                  context,
                  icon: Icons.local_drink,
                  title: "ปริมาณสารเคมี",
                  subtitle: "ปริมาณสารเคมีลดลงต่ำกว่า 20% โปรดเติมปริมาณสารเคมี",
                  time: "3 นาทีที่แล้ว",
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationDetailPage(title: "ปริมาณสารเคมี")));
                  },
                ),
                _buildNotificationCard(
                  context,
                  icon: Icons.speed,
                  title: "ความเร็วลม",
                  subtitle: "ความเร็วลมสูงเกินไปอาจทำให้สารเคมีกระจายตัวไม่สม่ำเสมอ",
                  time: "8 นาทีที่แล้ว",
                ),
              ],
            ),
          ),
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

  Widget _buildNotificationCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required String time,
      VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.red[100],
            child: Icon(icon, color: Colors.red),
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle),
          trailing: Text(time, style: const TextStyle(fontSize: 12)),
        ),
      ),
    );
  }
}

//✅ NotificationDetailPage (หน้าแสดงรายละเอียด)

class NotificationDetailPage extends StatelessWidget {
  final String title;

  const NotificationDetailPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Text(
          "รายละเอียดของ $title",
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}