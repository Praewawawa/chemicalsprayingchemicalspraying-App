// screen/nottification.dart
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:chemicalspraying/constants/colors.dart';
import 'package:chemicalspraying/router/routes.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'dart:convert';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

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
  int _selectedIndex = 2;

  final List<PageRouteInfo> _routes = const [
    AddprofileRoute(),
    ControlRoute(),
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
    _initializeNotifications();
    _setupMqtt();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showSystemNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'your_channel_id',
      'Notifications',
      channelDescription: 'Notification channel for alerts',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      platformDetails,
    );
  }

  void _setupMqtt() async {
    client = MqttServerClient(
      'test.mosquitto.org',
      'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
    );
    client.port = 1883;
    client.keepAlivePeriod = 60;
    client.logging(on: false);
    client.onConnected = () {
      print('✅ MQTT Connected');
      client.subscribe('rc/notification', MqttQos.atLeastOnce);
    };
    client.onDisconnected = () {
      print('MQTT Disconnected');
      Future.delayed(const Duration(seconds: 5), _setupMqtt); // auto reconnect
    };
    client.onSubscribed = (topic) => print('📌 Subscribed to $topic');

    try {
      await client.connect();
    } catch (e) {
      print('MQTT Connection Error: $e');
      client.disconnect();
    }

    client.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
      final String payload =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      _handleMessage(payload);
    });
  }

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
      title = "ปริมาณสารเคมีต่ำ";
      subtitle = "ระดับปริมารสารเคมีเหลือ 20%";
      avatar = "💧";
    } else if (payload.contains('sensor')) {
      title = "แจ้งเตือนการควบคุม";
      subtitle = "รถเริ่มการทำงาน";
      avatar = "🤖";
    } else {
      title = "ภารกิจสำเร็จ";
      subtitle = "การพ่นสารเคมีเสร็จสิ้น";
      avatar = "✅";
    }

    setState(() {
      notifications.insert(
        0,
        NotificationItem(
          id: DateTime.now().millisecondsSinceEpoch,
          title: title,
          subtitle: subtitle,
          avatar: avatar,
          time: time,
          isRead: false,
        ),
      );
    });

    _showSystemNotification(title, subtitle);
  }

  void _markAllAsRead() {
    setState(() {
      notifications = notifications
          .map((n) => NotificationItem(
                id: n.id,
                title: n.title,
                subtitle: n.subtitle,
                avatar: n.avatar,
                time: n.time,
                isRead: true,
              ))
          .toList();
    });
  }

  void _confirmDeleteAll() {
    if (notifications.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: const Text('คุณต้องการลบการแจ้งเตือนทั้งหมดหรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                notifications.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ลบการแจ้งเตือนทั้งหมดแล้ว')),
              );
            },
            child: const Text('ลบทั้งหมด', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

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

  Widget _buildListTile(NotificationItem item, int index) {
  return Dismissible(
    key: Key(item.id.toString()),
    direction: DismissDirection.endToStart,
    background: Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Icon(Icons.delete, color: Colors.white),
    ),
    onDismissed: (_) {
      setState(() {
        notifications.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ลบการแจ้งเตือนแล้ว')),
      );
    },
    child: GestureDetector(
      onTap: () {
        setState(() {
          final notif = notifications[index];
          if (!notif.isRead) {
            notifications[index] = NotificationItem(
              id: notif.id,
              title: notif.title,
              subtitle: notif.subtitle,
              avatar: notif.avatar,
              time: notif.time,
              isRead: true,
            );
            // เปลี่ยนแท็บไป "อ่านแล้ว" ถ้าอยู่ใน "ใหม่"
            if (_tabController.index == 1) {
              _tabController.animateTo(2);
            }
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.pink.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(item.avatar, style: const TextStyle(fontSize: 22)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(item.subtitle, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(item.time,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey)),
                    if (!item.isRead)
                      const Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Icon(Icons.circle, size: 10, color: mainColor),
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}


  @override
  void dispose() {
    _tabController.dispose();
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.disconnect();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentNotifications = _filteredNotifications();

    return Scaffold(
      backgroundColor: const Color(0xFFF0FAFF),
      appBar: AppBar(
        title: const Text('การแจ้งเตือน', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: const Text('อ่านทั้งหมด', style: TextStyle(color: mainColor)),
          ),
          TextButton(
            onPressed: _confirmDeleteAll,
            child: const Text('ลบทั้งหมด', style: TextStyle(color: Colors.red)),
          ),
        ],
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
      body: currentNotifications.isEmpty
          ? const Center(child: Text('ไม่มีการแจ้งเตือน'))
          : ListView.builder(
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
