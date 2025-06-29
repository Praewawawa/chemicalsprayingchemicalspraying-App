// screen/addprofile.dart
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chemicalspraying/router/routes.gr.dart';
import 'package:chemicalspraying/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'mqtt_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage(name: 'AddprofileRoute')
class AddprofilePage extends StatefulWidget {
  const AddprofilePage({super.key});

  @override
  State<AddprofilePage> createState() => _AddprofilePageState();
}

class _AddprofilePageState extends State<AddprofilePage> {
  int _selectedIndex = 0;

  final List<PageRouteInfo> _routes = [
    AddprofileRoute(),
    const ControlRoute(),
    const NotificationRoute(),
    const ProfileRoute(),
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
    MqttService().onUpdate = () => setState(() {});
    MqttService().connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FAFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildWindSpeedIndicator(),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: const [
                        BatteryCard(),
                        SizedBox(height: 16),
                        DistanceCard(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: const [
                        SprayControlCard(),
                        SizedBox(height: 16),
                        ChemicalCard(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
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
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'หน้าหลัก'),
          BottomNavigationBarItem(icon: Icon(Icons.sensors), label: 'ควบคุม'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), label: 'แจ้งเตือน'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'โปรไฟล์'),
        ],
      ),
    );
  }

  Widget _buildWindSpeedIndicator() {
    double windSpeed = MqttService().windSpeed;
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.green, width: 2),
            ),
          ),
          Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                colors: [Color(0xFF40C947), Color(0xFF6FF76A), Color(0xFF40C947)],
                stops: [0.0, 0.75, 1.0],
              ),
            ),
          ),
          Container(
            width: 170,
            height: 170,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0xFFDFFFE0), Colors.white],
                center: Alignment.center,
                radius: 0.9,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //const Text(' 0 °', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)), ทิศทางเป็นองศา
                const SizedBox(height: 8),
                Text(windSpeed.toStringAsFixed(2), style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                const Text('m/s', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BatteryCard extends StatelessWidget {
  const BatteryCard({super.key});

  @override
  Widget build(BuildContext context) {
    double batteryLevel = MqttService().battery / 100.0;
    int batteryPercent = MqttService().battery.round();

    return _buildCard(
      title: "แบตเตอรี่",
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 130),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // หัวแบตด้านบน
            Positioned(
              top: 0,
              child: Container(
                width: 50,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.green.shade100.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            // ตัวแบต
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // 🔋 ก้อนแบตเตอรี่แบ่งเป็น 5 ชิ้น จากล่างขึ้นบน
                    for (int i in List.generate(5, (index) => index).reversed)
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        height: 30,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: (batteryLevel * 5).floor() > i
                              ? const Color(0xFF40C947) // เขียวเมื่อมีแบต
                              : Colors.grey.shade300,    // เทาเมื่อไม่มีแบต
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    const SizedBox(height: 8),
                    // เปอร์เซ็นต์ตรงกลาง
                    Text(
                      "$batteryPercent%",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChemicalCard extends StatelessWidget {
  const ChemicalCard({super.key});

  @override
  Widget build(BuildContext context) {
    double chemicalLevel = MqttService().chemical / 100.0;
    int chemicalPercent = (chemicalLevel * 100).round();

    return _buildCard(
      title: "ปริมาณสารเคมี",
      child: SizedBox(
        width: 130,
        height: 220,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // หัวถัง
            Positioned(
              top: 0,
              child: Container(
                width: 50,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.green.shade100.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            // ตัวถัง
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    for (int i in List.generate(5, (index) => index).reversed)
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        height: 26,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _getBlockColor(i, chemicalLevel),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    const SizedBox(height: 0),
                    Text(
                      "$chemicalPercent%",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBlockColor(int index, double level) {
    if ((level * 5).floor() > index) {
      return const Color(0xFF40C947);
    } else {
      return Colors.grey.shade300;
    }
  }
}

class DistanceCard extends StatelessWidget {
  const DistanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildCardmin(
      title: "ระยะในการทำงานที่เหลือ",
      child: SizedBox(
        height: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.alt_route, size: 18),
            SizedBox(width: 6),
            Text("0 Km", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            //Text("10 Km", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
          ],
        ),
      ),
    );
  }
}

class SprayControlCard extends StatefulWidget {
  const SprayControlCard({super.key});

  @override
  State<SprayControlCard> createState() => _SprayControlCardState();
}

class _SprayControlCardState extends State<SprayControlCard> {
  bool isSprayOn = false;
  int sprayLevel = 1;

  @override
  void initState() {
    super.initState();
    _loadSprayLevel();
  }

  Future<void> _loadSprayLevel() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      sprayLevel = prefs.getInt('spray_level') ?? 1;
    });
  }

  Future<void> _saveSprayLevel() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('spray_level', sprayLevel);
  }

  void _increaseLevel() {
    if (sprayLevel < 3) {
      setState(() => sprayLevel++);
      _saveSprayLevel();
    }
  }

  void _decreaseLevel() {
    if (sprayLevel > 1) {
      setState(() => sprayLevel--);
      _saveSprayLevel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildCardmin(
      title: "ตั้งค่าระบบฉีดพ่น",
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              IconButton(
                onPressed: () {
                  _increaseLevel();
                  MqttService().publishSprayLevel(sprayLevel);
                },
                icon: const Icon(Icons.arrow_drop_up, color: Colors.green, size: 30),
              ),
              Text(
                sprayLevel > 1 ? "ระดับที่ ${sprayLevel - 1}" : "",
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Text(
                "ระดับที่ $sprayLevel",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                sprayLevel < 3 ? "ระดับที่ ${sprayLevel + 1}" : "",
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              IconButton(
                onPressed: () {
                  _decreaseLevel();
                  MqttService().publishSprayLevel(sprayLevel);
                },
                icon: const Icon(Icons.arrow_drop_down, color: Colors.green, size: 30),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: MqttService().sprayStatus,
                builder: (context, isSprayOn, _) {
                  return Column(
                    children: [
                      Text(
                        isSprayOn ? "เปิด" : "ปิด",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "สถานะ",
                        style: TextStyle(
                          color: isSprayOn ? Colors.green : Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CupertinoSwitch(
                        value: isSprayOn,
                        onChanged: (value) {
                          MqttService().sprayStatus.value = value;
                          MqttService().publish('pump_lavel', value ? 'ON' : 'OFF');
                        },
                        activeColor: Colors.green,
                        thumbColor: Colors.white,
                        trackColor: Colors.black12,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildCard({required String title, required Widget child}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.grey.shade300),
    ),
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SizedBox(height: 230, child: child),
      ],
    ),
  );
}

Widget _buildCardmin({required String title, required Widget child}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.grey.shade300),
    ),
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 0.1),
        child,
      ],
    ),
  );
}
