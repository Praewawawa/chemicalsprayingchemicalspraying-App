import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:chemicalspraying/router/routes.gr.dart';


@RoutePage(name: 'ProfileRoute')
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 4;

  final List<PageRouteInfo> _routes = [
      AddprofileRoute(),               // 0 -> Home
      ControlRoute(),                  // 1 -> Control
      NotificationRoute(),             // 2 -> Notification (แจ้งเตือน)
      NotificationSettingRoute(),      // 3 -> Setting (ตั้งค่า)
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.pop(),
        ),
        title: const Text(
          'โปรไฟล์',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('lip/assets/image/image.jpg'),
          ),
          const SizedBox(height: 10),
          const Text(
            'Praewa Sompoi',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          const Text(
            '@Praewa_1234',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 200,
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => context.router.replaceNamed('/editprofile'),
              child: const Text('แก้ไข'),
            ),
          ),
          const SizedBox(height: 30),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => context.router.replaceNamed('/login'),
                child: const Text('ออกจากระบบ'),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "หน้าหลัก"),
          BottomNavigationBarItem(icon: Icon(Icons.control_camera_outlined), label: "ควบคุม"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), label: "แจ้งเตือน"),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: "ตั้งค่า"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "โปรไฟล์"),
        ],
      ),
    );

      body: Column
      (
        children: [
          const SizedBox(height: 20),
          // Profile Image
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('lip/assets/image/image.jpg'), // เปลี่ยนเป็นรูปของคุณ
          ),
          const SizedBox(height: 10),
          // Name
          const Text(
            'Praewa Sompoi',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          // Username
          const Text(
            '@Praewa_1234',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          // Edit Button
          SizedBox(
            width: 200,
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                context.router.replaceNamed('/editprofile');// ใส่ event แก้ไข
              },
              child: const Text('แก้ไข'),
            ),
          ),
          const SizedBox(height: 30),
          const Divider(),

          // Logout Button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  context.router.replaceNamed('/login');// ใส่ event ออกจากระบบ
                },
                child: const Text('ออกจากระบบ'),
              ),
            ),
          ),
        ],
      );
  }
}
