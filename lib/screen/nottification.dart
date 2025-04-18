/*import 'package:auto_route/auto_route.dart';
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
    NotificationSettingRoute(),       // 3 -> Setting (ตั้งค่า)
    NotificationRoute(),             // 2 -> Notification (แจ้งเตือน)     
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
}*/

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:intl/intl.dart';
import 'package:chemicalspraying/constants/colors.dart';
import 'package:chemicalspraying/router/routes.gr.dart';
import 'package:auto_route/auto_route.dart';

class NotificationItem {
  final String title;     // ✅ เพิ่ม title
  final String subtitle;  // ✅ เพิ่ม subtitle
  final String avatar;    // ✅ เพิ่ม avatar emoji
  final String time;
  final bool isRead;

  NotificationItem({
    required this.title,
    required this.subtitle,
    required this.avatar,
    required this.time,
    this.isRead = false,
  });
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

  int _selectedIndex = 4; // ← ย้ายจาก class Widget มาไว้ใน State class
  final List<PageRouteInfo> _routes = const [ // ← เพิ่ม const
    AddprofileRoute(),               // 0 -> Home
    ControlRoute(),                  // 1 -> Control
    NotificationSettingRoute(),      // 3 -> Setting (ตั้งค่า)
    NotificationRoute(),             // 2 -> Notification (แจ้งเตือน)
    ProfileRoute(),                  // 4 -> Profile
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

  void _setupMqtt() async {
    client = MqttServerClient('test.mosquitto.org', 'flutter_client');
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

  void _handleMessage(String payload) {
    final time = DateFormat('HH:mm:ss').format(DateTime.now());

    /*setState(() {
      notifications.insert(
        0,
        NotificationItem(
          type: payload.contains('wind')
              ? 'wind'
              : payload.contains('battery')
                  ? 'battery'
                  : 'other',
          message: payload,
          time: time,
          isRead: false,
        ),
      );
    });*/
    // ✅ สมมุติข้อความแจ้งเตือนจาก payload (หรือจะ decode JSON ก็ได้)
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
          title: title,
          subtitle: subtitle,
          avatar: avatar,
          time: time,
          isRead: false,
        ),
      );
    });
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
