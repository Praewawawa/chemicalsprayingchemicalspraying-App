import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:chemicalspraying/router/routes.gr.dart'; // ✅ แก้ให้ถูก
import 'package:auto_route/annotations.dart';
import 'package:chemicalspraying/router/routes.dart'; // ✅ แก้ให้ถูก
import 'package:chemicalspraying/constants/colors.dart'; // ✅ แก้ให้ถูก



@RoutePage(name: 'EditProfileRoute')
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String selectedGender = 'หญิง'; // default

  final List<String> genderOptions = ['ชาย', 'หญิง', 'อื่นๆ'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
 appBar: AppBar(
  backgroundColor: Colors.transparent,
  elevation: 0,
  leading: TextButton(
    onPressed: () {
      context.router.pushNamed('/editprofile'); // ✅ หรือ .push(EditProfileRoute()) ถ้าใช้ AutoRoute
    },
    child: const Text(
      'ยกเลิก',
      style: TextStyle(
        color: redColor,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
  ),
),
      // AppBar
      // Body
      // ✅ ใช้ SingleChildScrollView เพื่อให้ Scroll ได้
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Image
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('lib/assets/images/profile.jpg'),
                ),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.edit, size: 16, color: Colors.grey),
                )
              ],
            ),
            const SizedBox(height: 16),
            // Name
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'ชื่อ-นามสกุล',
                labelStyle: const TextStyle(color: mainColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: mainColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: mainColor),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Gender and Phone
            Row(
              children: [
                // Gender
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedGender,
                    items: genderOptions
                        .map((gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            ))
                        .toList(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Phone
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: '082-204-9859',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Email
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Password
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Save Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3AC14D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  // Popup ยืนยัน
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.person, color: mainColor, size: 60),
                          const SizedBox(height: 16),
                          const Text(
                            'ยืนยันการแก้ไข\nข้อมูลโปรไฟล์',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context); // ปิด Dialog
                                  context.router.replace(const ProfileRoute()); // ไปหน้า Profile
                                },
                                icon: const Icon(Icons.close, color: mainColor), // ✅ ไอคอนสีเขียว
                                label: const Text(
                                  'ยกเลิก',
                                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold), // ✅ ตัวหนังสือสีเขียว
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.green), // ✅ ขอบเขียว
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),

                          Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: mainColor, // ✅ สีเขียว
                                  minimumSize: const Size(120, 40), // ✅ ขนาดปุ่มเหมือนกับ OutlinedButton
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8), // ✅ ขอบโค้งเหมือนกัน
                                  ),
                                ),
                                child: const Text(
                                  'ยืนยัน',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );

                  // ถ้ากดยืนยัน
                  if (confirm == true) {
                    // Popup สำเร็จ
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.check_circle, color: mainColor, size: 60),
                            SizedBox(height: 16),
                            Text(
                              'บันทึกข้อมูลสำเร็จ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );

                    // ไปหน้าโปรไฟล์
                    context.router.replace(const ProfileRoute());
                  }
                },
                child: const Text(
                  'บันทึก',
                  style: TextStyle(color: Colors.white,fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );  
  }
}

