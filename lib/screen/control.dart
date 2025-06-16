// screen/control.dart
import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:chemicalspraying/screen/mqtt_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chemicalspraying/constants/colors.dart';
import 'package:http/http.dart' as http;
import '../router/routes.gr.dart';
import 'dart:convert';
import 'package:chemicalspraying/services/mqtt_service.dart';

@RoutePage(name: 'ControlRoute')
class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  int _selectedIndex = 1;
  bool isCustomMode = false;
  Timer? _holdTimer;
  bool isControlOn = false;

  late MqttService mqttService;
  Timer? _reconnectTimer;

  final List<PageRouteInfo> _routes = [
    AddprofileRoute(),
    ControlRoute(),
    NotificationRoute(),
    ProfileRoute(),
  ];

  @override
  void initState() {
    super.initState();
    mqttService = MqttService();
    mqttService.connect();

    // ตั้ง timer ทุก 2 วินาที ตรวจสอบสถานะ ถ้ายังไม่เชื่อมต่อให้รีเชื่อมต่อ
    _reconnectTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mqttService.isConnected) {
        mqttService.connect();
      }
      // สั่งให้ UI อัพเดตสถานะ
      if (mounted) setState(() {});
    });
  }

  void _toggleControl() {
    if (!mqttService.isConnected) {
      showErrorDialog('MQTT not connected');
      return;
    }

    final payload = isControlOn ? 'manual_stop' : 'manual_start';
    mqttService.publish('system/control', payload);

    setState(() {
      isControlOn = !isControlOn;
    });
  }

  Future<void> sendCommand(String command) async {
    print('👉 Sending command: $command');
    final url = Uri.parse('http://192.168.137.207:5000/control');

    final appStart = DateTime.now(); // Start timing before sending

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"direction": command}),
      );

      final appEnd = DateTime.now(); // Time after receiving response

      if (response.statusCode == 200) {
        print('✅ Success: $command');
        final json = jsonDecode(response.body);

        // Total round-trip time: App -> Flask -> App (milliseconds)
        final appRoundTrip = appEnd.difference(appStart).inMilliseconds;

        // Flask to Pixhawk and Pixhawk to Flask response time (seconds)
        final flaskToPixhawk =
            (json["Timeapp"]["flask_to_pixhawk"] as num?)?.toDouble() ?? 0;
        final pixhawkToFlask =
            (json["Timeapp"]["pixhawk_to_flask_response"] as num?)
                    ?.toDouble() ??
                0;

        // Combined Flask-Pixhawk round-trip time in milliseconds (3 decimal places)
        final flaskPixhawkRoundTrip =
            ((flaskToPixhawk + pixhawkToFlask) * 1000);

        // Total time including decimal 3 places
        final totalTime = appRoundTrip + flaskPixhawkRoundTrip;

        print("⏱ Timing Summary:");
        print(" - App ➜ Flask ➜ App (RTT): $appRoundTrip ms");
        print(
            " - Flask ➜ Pixhawk ➜ Flask response: ${flaskPixhawkRoundTrip.toStringAsFixed(3)} ms");
        print(
            " - Total (App ➜ Flask ➜ Pixhawk ➜ App): ${totalTime.toStringAsFixed(3)} ms");
      } else {
        print('❌ Failed with status code: ${response.statusCode}');
        showErrorDialog('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('❗ Error: $e');
      showErrorDialog('Cannot connect to server: $e');
    }
  }

  void showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void sendArm() => sendCommand("arm");
  void sendDisarm() => sendCommand("disarm");

  void _startSendingCommand(String command) {
    if (_holdTimer != null) return;
    sendCommand(command);
    _holdTimer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      sendCommand(command);
    });
  }

  void _stopSendingCommand() {
    _holdTimer?.cancel();
    _holdTimer = null;
    sendCommand("stop");
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
    context.router.replace(_routes[index]);
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _reconnectTimer?.cancel();
    mqttService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FAFF),
      appBar: AppBar(
        title: const Text(
          "RC Control Panel",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          // ไอคอนสถานะเชื่อมต่อ MQTT
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              mqttService.isConnected ? Icons.wifi : Icons.wifi_off,
              color: mqttService.isConnected ? Colors.green : Colors.red,
              size: 28,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CupertinoSwitch(
              value: isCustomMode,
              onChanged: (value) {
                setState(() => isCustomMode = value);
                if (value) {
                  context.router.replace(const ControlwaypointRoute());
                } else {
                  context.router.replace(const ControlRoute());
                }
              },
              activeColor: Colors.green,
              thumbColor: Colors.white,
              trackColor: Colors.black12,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          const Spacer(),
          Center(
            child: Table(
              defaultColumnWidth: const FixedColumnWidth(70),
              children: [
                TableRow(children: [
                  _padded(_directionButton(Icons.north_west, 'forward_left')),
                  _padded(_directionButton(Icons.arrow_upward, 'forward')),
                  _padded(_directionButton(Icons.north_east, 'forward_right')),
                ]),
                TableRow(children: [
                  _padded(_directionButton(Icons.arrow_back, 'left')),
                  _padded(_stopButton()),
                  _padded(_directionButton(Icons.arrow_forward, 'right')),
                ]),
                TableRow(children: [
                  _padded(_directionButton(Icons.south_west, 'backward_left')),
                  _padded(_directionButton(Icons.arrow_downward, 'backward')),
                  _padded(_directionButton(Icons.south_east, 'backward_right')),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _actionButton("ARM", Colors.green, sendArm),
              const SizedBox(width: 20),
              _actionButton("DISARM", Colors.amber, sendDisarm),
            ],
          ),
          const SizedBox(height: 20),
          _actionButton(
            isControlOn ? "ปิดระบบควบคุม" : "เปิดระบบควบคุม",
            isControlOn ? Colors.red : Colors.blue,
            _toggleControl,
          ),
          const SizedBox(height: 100),
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
      padding: const EdgeInsets.all(5.0),
      child: child,
    );
  }

  Widget _directionButton(IconData icon, String command) {
    return SizedBox(
      width: 60,
      height: 60,
      child: GestureDetector(
        onTapDown: (_) => _startSendingCommand(command),
        onTapUp: (_) => _stopSendingCommand(),
        onTapCancel: () => _stopSendingCommand(),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.zero,
            elevation: 4,
          ),
          child: Icon(icon, size: 28, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _stopButton() {
    return SizedBox(
      width: 60,
      height: 60,
      child: ElevatedButton(
        onPressed: () => sendCommand("stop"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          padding: EdgeInsets.zero,
        ),
        child: const Text(
          'STOP',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _actionButton(String label, Color color, void Function() onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
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
