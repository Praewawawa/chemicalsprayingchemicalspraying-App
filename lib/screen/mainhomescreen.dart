import 'package:flutter/material.dart';
import 'package:chemicalspraying/screen/addprofile.dart';
import 'package:chemicalspraying/screen/control.dart';
import 'package:chemicalspraying/screen/nottification.dart';
import 'package:chemicalspraying/screen/setting.dart';
import 'package:chemicalspraying/screen/profilescreen.dart';
import 'package:chemicalspraying/constants/colors.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chemicalspraying/router/routes.gr.dart'; // เปลี่ยนให้ตรงกับที่เก็บสีในโปรเจกต์ของคุณ

@RoutePage()
class MainHomeScreen extends StatefulWidget { 
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState(); // ✅ เพิ่ม override method
}

class _MainHomeScreenState extends State<MainHomeScreen> { // ✅ ย้ายออกมาเป็นคลาสแยก

  int _selectedIndex = 0; // ✅ state สำหรับเก็บ index

  final List<Widget> widgetOptions = const [ // ✅ เพิ่ม const
    AddprofilePage(),               // หน้าหลัก
    ControlPage(),                  // ควบคุม
    NotificationPage(),             // แจ้งเตือน
    NotificationSettingPage(),      // ตั้งค่า
    ProfilePage(),                  // โปรไฟล์
  ];

  void _onItemTapped(int index) {
    setState(() { // ✅ เรียก setState ให้เกิดการ rebuild
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chemical Spraying'), // ✅ แก้ชื่อ AppBar
        centerTitle: true, // ✅ เพิ่มให้ชื่ออยู่กลาง
      ),
      body: widgetOptions.elementAt(_selectedIndex), // ✅ แสดง widget ตาม index
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: mainColor,
        unselectedItemColor: grayColor,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
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

/*import 'package:flutter/material.dart';
import 'package:chemicalspraying/screen/addprofile.dart';
import 'package:chemicalspraying/screen/control.dart';
import 'package:chemicalspraying/screen/nottification.dart';
import 'package:chemicalspraying/screen/setting.dart';
import 'package:chemicalspraying/screen/profilescreen.dart';
import 'package:chemicalspraying/constants/colors.dart';
import 'package:chemicalspraying/router/routes.gr.dart'; // เปลี่ยนให้ตรงกับที่เก็บสีในโปรเจกต์ของคุณ
import 'package:auto_route/auto_route.dart';


@RoutePage()
class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedIndex = 0;

final List<Widget> widgetOptions = [
  const AddprofilePage(),     // หน้าหลัก (index 0)
  const ControlPage(),        // index 1
  const NotificationPage(),   // index 2
  const NotificationSettingPage(), // index 3
  const ProfilePage(),        // index 4
];
  // final List<Widget> widgetOptions = const [
  //   HomeScreen(),           // หน้าหลัก    
  

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chemical Spraying'),
      ),
      body: widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: mainColor,
        unselectedItemColor: grayColor,
        items: const <BottomNavigationBarItem>[
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
}*/
