import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../router/routes.gr.dart';
import 'package:chemicalspraying/constants/colors.dart';

@RoutePage(name: 'ControlRoute')
class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  int _selectedIndex = 1;
  bool isCustomMode = false;
  late MqttServerClient client;

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
    _connectMQTT(); // ✅ เพิ่มการเชื่อมต่อ MQTT
  }

  Future<void> _connectMQTT() async {
    client = MqttServerClient('test.mosquitto.org', 'flutter_client'); // ✅ ใช้ MQTT server
    client.port = 1883;
    client.logging(on: false);
    client.keepAlivePeriod = 20;
    client.onConnected = () => print('MQTT Connected');
    client.onDisconnected = () => print('MQTT Disconnected');
    client.onSubscribed = (topic) => print('Subscribed to \$topic');

    try {
      await client.connect();
    } catch (e) {
      print('MQTT connection failed: \$e');
      client.disconnect();
    }
  }

  void sendControl(String direction) {
    final builder = MqttClientPayloadBuilder(); // ✅ สร้าง payload
    builder.addString(direction);
    client.publishMessage('rc/control', MqttQos.atLeastOnce, builder.payload!);
    print('Sent MQTT command: \$direction');
  }

  void sendArm() => sendControl("arm"); // ✅ ฟังก์ชัน ARM
  void sendDisarm() => sendControl("disarm"); // ✅ ฟังก์ชัน DISARM

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
      appBar: AppBar(
        title: const Text("RC Control Panel",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                const SizedBox(width: 8),
                CupertinoSwitch(
                  value: isCustomMode,
                  onChanged: (value) {
                    setState(() => isCustomMode = value);
                    if (value) {
                      context.router.replace(const ControlwaypointRoute());
                    }
                  },
                  activeColor: Colors.green,
                  thumbColor: Colors.white,
                  trackColor: Colors.black12,
                ),
              ],
            ),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          // ✅ ปุ่ม ARM / DISARM แบบกดได้
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _actionButton("ARM", Colors.green, sendArm),
              const SizedBox(width: 20),
              _actionButton("DISARM", Colors.amber, sendDisarm),
            ],
          ),

          const SizedBox(height: 30),

          // ✅ ปุ่มควบคุมทิศทางแบบ Table และมีระยะห่าง
          Center(
            child: Table(
              defaultColumnWidth: FixedColumnWidth(70),
              children: [
                TableRow(
                  children: [
                    _padded(_directionButton(Icons.north_west, 'forward_left')),
                    _padded(_directionButton(Icons.arrow_upward, 'forward')),
                    _padded(_directionButton(Icons.north_east, 'forward_right')),
                  ],
                ),
                TableRow(
                  children: [
                    _padded(_directionButton(Icons.arrow_back, 'left')),
                    _padded(_stopButton()),
                    _padded(_directionButton(Icons.arrow_forward, 'right')),
                  ],
                ),
                TableRow(
                  children: [
                    _padded(_directionButton(Icons.south_west, 'backward_left')),
                    _padded(_directionButton(Icons.arrow_downward, 'backward')),
                    _padded(_directionButton(Icons.south_east, 'backward_right')),
                  ],
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

  Widget _padded(Widget child) {
    return Padding(
      padding: const EdgeInsets.all(5.0), // ✅ เพิ่มระยะห่าง
      child: child,
    );
  }

  Widget _directionButton(IconData icon, String command) {
    return GestureDetector(
      onTap: () => sendControl(command), // ✅ ส่งคำสั่ง MQTT เมื่อกด
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 28, color: Colors.black87),
      ),
    );
  }

  Widget _stopButton() {
    return GestureDetector(
      onTap: () => sendControl("stop"), // ✅ ส่ง stop command
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'STOP',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _actionButton(String label, Color color, void Function() onPressed) {
    return ElevatedButton(
      onPressed: onPressed, // ✅ ส่งคำสั่ง arm / disarm
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(120, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
