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
  int _selectedIndex = 0; // ✅ ประกาศตัวแปรตรงนี้

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'โปรไฟล์',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "หน้าหลัก"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "ตั้งค่า"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "แจ้งเตือน"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "โปรไฟล์"),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          switch (index) {
            case 0:
              context.router.push(const AddprofileRoute());
              break;
            case 1:
              context.router.push(const NotificationSettingRoute());
              break;
            case 2:
              context.router.push(const NotificationRoute());
              break;
            case 3:
              context.router.push(const ProfileRoute());
              break;
          }
        },
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Profile Image
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/image/image.jpg'), // เปลี่ยนเป็นรูปของคุณ
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
                // ใส่ event แก้ไข
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
                  // ใส่ event ออกจากระบบ
                },
                child: const Text('ออกจากระบบ'),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
