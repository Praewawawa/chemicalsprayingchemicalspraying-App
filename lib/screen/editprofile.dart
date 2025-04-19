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
            context.router.push(ProfileRoute()); // ✅ กลับหน้าโปรไฟล์
          },
          child: const Text(
            'ยกเลิก',
            style: TextStyle(
              color: redColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: ClipRect(
              child: Opacity(
                opacity: 0.3,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.50,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Image.asset(
                    'lib/assets/image/3.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
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
                    filled: true, // ✅ ใส่ true เพื่อให้มีพื้นหลัง
                    fillColor: Colors.white, // ✅ สีพื้นหลังขาว ไม่โปร่ง
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
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: '082-204-9859',
                          filled: true, // ✅ ใส่ true เพื่อให้มีพื้นหลัง
                          fillColor: Colors.white, // ✅ สีพื้นหลังขาว ไม่โปร่ง
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
                    filled: true, // ✅ ใส่ true เพื่อให้มีพื้นหลัง
                    fillColor: Colors.white, // ✅ สีพื้นหลังขาว ไม่โปร่ง
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
                    filled: true, // ✅ ใส่ true เพื่อให้มีพื้นหลัง
                    fillColor: Colors.white, // ✅ สีพื้นหลังขาว ไม่โปร่ง
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
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        context.router.replace(const ProfileRoute());
                                      },
                                      icon: const Icon(Icons.close, color: mainColor),
                                      label: const Text(
                                        'ยกเลิก',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Colors.green),
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
                                        backgroundColor: mainColor,
                                        minimumSize: const Size(120, 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
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

                      if (confirm == true) {
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

                        context.router.replace(const ProfileRoute());
                      }
                    },
                    child: const Text(
                      'บันทึก',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
