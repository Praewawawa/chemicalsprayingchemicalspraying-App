import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chemicalspraying/router/routes.gr.dart';
import 'package:chemicalspraying/constants/colors.dart';
import 'package:flutter/cupertino.dart';




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
    const NotificationSettingRoute(),
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

              // ✅ เปลี่ยนตรงนี้
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Column ซ้าย: Battery + Distance
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

                  // Column ขวา: SprayControl + Chemical
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

  Widget _buildWindSpeedIndicator() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // เส้นวงนอกบางๆ สีเขียวเข้ม
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.green, width: 2),
            ),
          ),

          // วงความเร็วแบบ SweepGradient (เฉดสีหลัก)
          Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                startAngle: 0.0,
                endAngle: 3.14 * 2,
                colors: [
                  Color(0xFF40C947),
                  Color(0xFF6FF76A),
                  Color(0xFF40C947),
                ],
                stops: [0.0, 0.75, 1.0],
              ),
            ),
          ),

          // วงกลมภายใน มี RadialGradient สีเขียวอ่อน
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
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('N↑',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black)),
                SizedBox(height: 8),
                Text('4.23',
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                Text('km/s',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
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
    const double batteryLevel = 0.8;

    return _buildCard(
      title: "แบตเตอรี่",
      child: Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 130, // 👈 ปรับให้แคบลงตามต้องการ
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // หัวครอบ
              Positioned(
                top: 0,
                child: Container(
                  width: 50,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.4),
                        blurRadius: 6,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                ),
              ),

              // กล่องแบตเตอรี่
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      FractionallySizedBox(
                        heightFactor: batteryLevel,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(24)),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF40C947), Color(0xFF6FF76A)],
                            ),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("80",
                                    style: TextStyle(
                                        fontSize: 28,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                Text("%",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
  // สถานะการทำงานของระบบฉีดพ่น
  bool isSprayOn = false;
  int sprayLevel = 2;

  void _increaseLevel() {
    if (sprayLevel < 3) setState(() => sprayLevel++);
  }

  void _decreaseLevel() {
    if (sprayLevel > 1) setState(() => sprayLevel--);
  }

  @override
Widget build(BuildContext context) {
  return _buildCardmin(
    title: "ตั้งค่าระบบฉีดพ่น",
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // ปุ่มปรับระดับ
        Column(
          children: [
            IconButton(
              onPressed: _increaseLevel,
              icon: const Icon(Icons.arrow_drop_up,
                  color: Colors.green, size: 30),
            ),
            Text("ระดับที่ ${sprayLevel - 1}",
                style: const TextStyle(color: Colors.grey, fontSize: 14)),
            Text("ระดับที่ $sprayLevel",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18)),
            Text("ระดับที่ ${sprayLevel + 1}",
                style: const TextStyle(color: Colors.grey, fontSize: 14)),
            IconButton(
              onPressed: _decreaseLevel,
              icon: const Icon(Icons.arrow_drop_down,
                  color: Colors.green, size: 30),
            ),
          ],
        ),

        // ปุ่มเปิด/ปิด
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              isSprayOn ? "เปิด" : "ปิด",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
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
                setState(() {
                  isSprayOn = value;
                });

                // ✅ เพิ่มโค้ดควบคุมการทำงานจริง เช่น MQTT หรือ API
              },
              activeColor: Colors.green,
              thumbColor: Colors.white,
              trackColor: Colors.black12,
            ),
          ],
        ),
      ],
    ),
  );
}
}

class DistanceCard extends StatelessWidget {
  const DistanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildCardmin(
      title: "เส้นทางการทำงาน",
      child: SizedBox(
        height: 160, // 👈 ปรับตามความสูงของ SprayControlCard
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.alt_route, color: Colors.black),
            SizedBox(width: 8),
            Text("10 Km", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,)),
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
    const double chemicalLevel = 0.5;

    return _buildCard(
      title: "ปริมาณสารเคมี",
      child: Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 130),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // หัวครอบด้านบน
              Positioned(
                top: 0,
                child: Container(
                  width: 50,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 4,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                ),
              ),

              // กล่องสารเคมี
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      FractionallySizedBox(
                        heightFactor: chemicalLevel,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(24)),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF40C947), Color(0xFF6FF76A)],
                            ),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("50",
                                    style: TextStyle(
                                        fontSize: 28,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                Text("%",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
        // ✅ กำหนดขนาดที่ชัดเจนให้ child
        SizedBox(
          height: 230, // หรือความสูงที่คุณต้องการ
          child: child,
        ),
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
        const SizedBox(height: 12),
        child,
      ],
    ),
  );
}
