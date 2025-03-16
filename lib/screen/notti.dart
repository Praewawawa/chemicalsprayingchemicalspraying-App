import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';


@RoutePage()

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotificationScreen(),
    );
  }
}

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Text("แจ้งเตือน", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(text: "ทั่วไป"),
            Tab(text: "ปริมาณแบตเตอรี่"),
            Tab(text: "ปริมาณสารเคมี"),
            Tab(text: "ความเร็วลม"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationList(),
          _buildNotificationList(),
          _buildNotificationList(),
          _buildNotificationList(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "หน้าหลัก"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "ตั้งค่า"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "แจ้งเตือน"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "โปรไฟล์"),
        ],
      ),
    );
  }

  Widget _buildNotificationList() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildNotificationItem(Icons.battery_alert, "ปริมาณแบตเตอรี่",
            "แบตเตอรี่ของเครื่องต่ำกว่า 10% โปรดชาร์จก่อนการใช้งาน", "1 นาทีที่แล้ว", Colors.red),
        _buildNotificationItem(Icons.water_drop, "ปริมาณสารเคมี",
            "ปริมาณสารเคมีของถังต่ำกว่า 20% โปรดเติมก่อนการฉีดพ่น", "3 นาทีที่แล้ว", Colors.orange),
        _buildNotificationItem(Icons.air, "ความเร็วลม",
            "ความเร็วลมสูงเกินค่าที่กำหนด อาจมีผลต่อการใช้งาน", "8 นาทีที่แล้ว", Colors.redAccent),
      ],
    );
  }

  Widget _buildNotificationItem(
      IconData icon, String title, String subtitle, String time, Color color) {
    return ListTile(
      leading: Icon(icon, color: color, size: 36),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: Text(time, style: TextStyle(color: Colors.grey)),
      contentPadding: EdgeInsets.symmetric(vertical: 8),
    );
  }
}
