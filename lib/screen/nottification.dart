// screen/nottification.dart

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart'; 
import 'package:mqtt_client/mqtt_server_client.dart'; // mqtt_client
import 'package:intl/intl.dart';
import 'package:chemicalspraying/constants/colors.dart';
import 'package:chemicalspraying/router/routes.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'dart:convert';

class NotificationItem {
  final int id;
  final String title;
  final String subtitle;
  final String avatar;
  final String time;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.avatar,
    required this.time,
    this.isRead = false,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      avatar: json['icon'] ?? '🔔',
      time: json['created_at'] ?? '',
      isRead: json['is_read'] == 1,
    );
  }
}

@RoutePage(name: 'NotificationRoute')
class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  late MqttServerClient client;
  List<NotificationItem> notifications = [];
  late TabController _tabController;

  int _selectedIndex = 4;
  final List<PageRouteInfo> _routes = const [
    AddprofileRoute(),
    ControlRoute(),
    NotificationSettingRoute(),
    NotificationRoute(),
    ProfileRoute(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    context.router.replace(_routes[index]);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _setupMqtt();
  }

/// ฟังก์ชันนี้จะถูกเรียกเมื่อมีการเชื่อมต่อ MQTT
  void _setupMqtt() async {
    client = MqttServerClient('test.mosquitto.org', 'flutter_client_${DateTime.now().millisecondsSinceEpoch}'); // เปลี่ยนเป็น broker ที่คุณใช้
    /*client.port = 1883;
    client.keepAlivePeriod = 60;
    client.onBadCertificate = (X509Certificate cert) => true;*/
    client.logging(on: false);
    client.onConnected = () {
      print('MQTT Connected'); 
      client.subscribe('rc/notification', MqttQos.atLeastOnce);
    };
    client.onDisconnected = () => print('MQTT Disconnected');
    client.onSubscribed = (topic) => print('Subscribed to $topic');

    try {
      await client.connect();
    } catch (e) {
      print('MQTT Error: $e');
      client.disconnect();
    }

    client.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
      final String payload =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      _handleMessage(payload);
    });
  }

/// ฟังก์ชันนี้จะถูกเรียกเมื่อมีการรับข้อความจาก MQTT
  void _handleMessage(String payload) {
    final time = DateFormat('HH:mm:ss').format(DateTime.now());

    late String title, subtitle, avatar;

    if (payload.contains('wind')) {
      title = "แจ้งเตือนลมแรง";
      subtitle = "ลมแรงเกิน 10 m/s";
      avatar = "🌬️";
    } else if (payload.contains('battery')) {
      title = "แบตเตอรี่ต่ำ";
      subtitle = "ระดับแบตเตอรี่เหลือ 15%";
      avatar = "🔋";
    } else if (payload.contains('robot')) {
      title = "สัญญาณหุ่นยนต์ขาดหาย";
      subtitle = "หุ่นยนต์ไม่ตอบสนอง 3 วินาที";
      avatar = "🤖";
    } else if (payload.contains('sensor')) {
      title = "แจ้งเตือนเซ็นเซอร์";
      subtitle = "เซ็นเซอร์ความชื้นไม่ทำงาน";
      avatar = "💧";
    } else {
      title = "ภารกิจสำเร็จ";
      subtitle = "การพ่นสารเคมีเสร็จสิ้น";
      avatar = "✅";
    }

    setState(() {
      notifications.insert(
        0,
        NotificationItem(
          id: DateTime.now().millisecondsSinceEpoch, // ใช้ timestamp เป็น id ชั่วคราว
          title: title,
          subtitle: subtitle,
          avatar: avatar,
          time: time,
          isRead: false,
        ),
      );
    });
  }

/// ฟังก์ชันนี้จะกรองการแจ้งเตือนตามแท็บที่เลือก
  List<NotificationItem> _filteredNotifications() {
    switch (_tabController.index) {
      case 1:
        return notifications.where((n) => !n.isRead).toList();
      case 2:
        return notifications.where((n) => n.isRead).toList();
      default:
        return notifications;
    }
  }

/// ฟังก์ชันนี้จะสร้าง ListTile สำหรับการแจ้งเตือนแต่ละรายการ
  Widget _buildListTile(NotificationItem item, int index) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.pink.shade100,
        child: Text(item.avatar, style: const TextStyle(fontSize: 18)),
      ),
      title: Text(item.title,
          style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(item.subtitle),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(item.time, style: const TextStyle(fontSize: 12)),
          if (!item.isRead)
            const Icon(Icons.circle, color: mainColor, size: 10),
        ],
      ),
      onTap: () {
        setState(() {
          notifications[index] = NotificationItem(
            id: item.id,
            title: item.title,
            subtitle: item.subtitle,
            avatar: item.avatar,
            time: item.time,
            isRead: true,
          );
        });
      }
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    client.disconnect();
    super.dispose();
  }

/// ฟังก์ชันนี้จะถูกเรียกเมื่อมีการสร้าง widget
  @override
  Widget build(BuildContext context) {
    final currentNotifications = _filteredNotifications();

    return Scaffold(
      backgroundColor: const Color(0xFFF0FAFF),
      appBar: AppBar(
        title: const Text('การแจ้งเตือน', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: mainColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: mainColor,
          onTap: (_) => setState(() {}),
          tabs: const [
            Tab(text: 'ทั้งหมด'),
            Tab(text: 'ใหม่'),
            Tab(text: 'อ่านแล้ว'),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: currentNotifications.length,
        itemBuilder: (context, index) {
          return _buildListTile(currentNotifications[index], index);
        },
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
