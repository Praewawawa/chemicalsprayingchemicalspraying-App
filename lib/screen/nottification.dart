import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:chemicalspraying/router/routes.gr.dart'; // ✅ แก้ให้ถูก



@RoutePage( name: 'NotificationRoute')  // ใช้ @RoutePage() เพื่อให้ AutoRoute สร้างเส้นทางสำหรับหน้า

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'แจ้งเตือน',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Tabs
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTab('ทั่วไป', true),
                _buildTab('ปริมาณแบตเตอรี่', false, badge: '2'),
                _buildTab('ปริมาณสารเคมี', false),
                _buildTab('ความเร็วลม', false),
              ],
            ),
          ),
          const Divider(),

          // Notification List
          Expanded(
            child: ListView(
              children: [
                _buildNotification(
                  icon: Icons.battery_alert,
                  title: 'ปริมาณแบตเตอรี่',
                  subtitle: 'ปริมาณแบตเตอรี่ต่ำกว่า 10% โปรดชาร์จแบตเตอรี่ของคุณ',
                  time: '1 นาทีที่แล้ว',
                ),
                _buildNotification(
                  icon: Icons.water_drop,
                  title: 'ปริมาณสารเคมี',
                  subtitle: 'ปริมาณสารเคมีลดลงต่ำกว่า 20% โปรดเติมปริมาณสารเคมีของคุณ',
                  time: '3 นาทีที่แล้ว',
                ),
                _buildNotification(
                  icon: Icons.wind_power,
                  title: 'ความเร็วลม',
                  subtitle: 'ความเร็วลมสูงเกินไปอาจทำให้สารเคมีกระจายตัวไม่สม่ำเสมอ',
                  time: '8 นาทีที่แล้ว',
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'หน้าแรก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'แจ้งเตือน',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'โปรไฟล์',
          ),
        ],
        currentIndex: 1,
        onTap: (index) {},
      ),
    );
  }

  // -------------------------------
  // Widgets

  Widget _buildTab(String title, bool selected, {String? badge}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (badge != null)
              Container(
                margin: const EdgeInsets.only(left: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
        if (selected)
          const SizedBox(height: 2),
        if (selected)
          Container(
            height: 2,
            width: 20,
            color: Colors.green,
          ),
      ],
    );
  }

  Widget _buildNotification({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: Text(
        time,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
    );
  }
}
