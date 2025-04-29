// screen/createaccount.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:chemicalspraying/components/app_button.dart';
import 'package:chemicalspraying/router/routes.gr.dart';
import 'package:chemicalspraying/components/cardInfo.dart';
import 'package:chemicalspraying/constants/colors.dart';
import 'package:chemicalspraying/services/api_service.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


@RoutePage(name: 'CreateAccountRoute')
class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CreateAccountScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String _selectedGender = 'เพศชาย';

Future<void> registerAndLogin() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("รหัสผ่านไม่ตรงกัน")),
      );
      return;
    }

    try {
      // ✅ สมัครสมาชิก
      final registerResponse = await ApiService.post('/users/register', {
        "fullname": _usernameController.text.trim(),
        "email": _emailController.text.trim(),
        "phone": _phoneController.text.trim(),
        "gender": _selectedGender,
        "password": _passwordController.text.trim(),
      });

      if (registerResponse.statusCode == 201) {
        // ✅ สมัครเสร็จ ยิง login ต่อ
        final loginResponse = await ApiService.loginUser(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (loginResponse.statusCode == 200) {
          final data = jsonDecode(loginResponse.body);
          final prefs = await SharedPreferences.getInstance();

          await prefs.setInt('user_id', data['user']['id']);
          await prefs.setString('profile_name', data['user']['name']);
          await prefs.setString('profile_email', data['user']['email']);
          await prefs.setString('profile_phone', data['user']['phone'] ?? '');
          await prefs.setString('profile_gender', data['user']['gender'] ?? '');

          // ✅ ส่ง OTP เพื่อยืนยัน email
          await ApiService.post('/otp/create-otp', {
            "email": _emailController.text.trim(),
            "purpose": "register"
          });

          context.router.push(
            OTPVerificationRoute(email: _emailController.text.trim(), purpose: 'register')
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Login ล้มเหลว: ${loginResponse.body}")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("สมัครสมาชิกล้มเหลว: ${registerResponse.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("เกิดข้อผิดพลาด: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FAFF),
      body: Stack(
        children: [
          // ✅ รูปพื้นหลังมุมล่าง
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRect(
              child: Opacity(
                opacity: 0.3,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.40,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    'lib/assets/image/15.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          // ✅ ฟอร์มสมัครสมาชิก
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'สร้างบัญชีสมาชิก',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ชื่อบัญชี
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'ชื่อบัญชีผู้ใช้',
                        labelStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: mainColor),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: mainColor, width: 2),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // แถว เพศ + เบอร์โทร
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 60,
                            child: DropdownButtonFormField<String>(
                              value: _selectedGender,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedGender = newValue!;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'เพศ',
                                labelStyle: const TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: mainColor),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: mainColor, width: 2),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              items: ['เพศชาย', 'เพศหญิง', 'อื่นๆ']
                                  .map((String value) => DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 60,
                            child: TextField(
                              controller: _phoneController,
                              decoration: InputDecoration(
                                labelText: 'เบอร์โทรศัพท์',
                                labelStyle: const TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: mainColor),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: mainColor, width: 2),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // อีเมล
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'อีเมล',
                        labelStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: mainColor),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: mainColor, width: 2),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // รหัสผ่าน
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'รหัสผ่าน',
                        labelStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: mainColor),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: mainColor, width: 2),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ยืนยันรหัสผ่าน
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'ยืนยันรหัสผ่าน',
                        labelStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: mainColor),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: mainColor, width: 2),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ปุ่มสมัครสมาชิก
                    // ✅ ปุ่มสมัครสมาชิก
                    AppButton(
                      title: "สมัครสมาชิก",
                      onPressed: () async {
                        if (_passwordController.text != _confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("รหัสผ่านไม่ตรงกัน")),
                          );
                          return;
                        }

                        try {
                          // 🔹 ยิง API สมัครสมาชิก
                          final response = await ApiService.registerUser({
                            "fullname": _usernameController.text.trim(),
                            "email": _emailController.text.trim(),
                            "phone": _phoneController.text.trim(),
                            "gender": _selectedGender,
                            "password": _passwordController.text.trim(),
                          });

                          if (response.statusCode == 201) {
                            // 🔹 ถ้าสมัครสำเร็จ ส่ง OTP ต่อ
                            await ApiService.post('/otp/create-otp', {
                              "email": _emailController.text.trim(),
                              "purpose": "register"
                            });

                            // 🔹 แสดง popup สำเร็จ
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.check_circle, color: mainColor, size: 40),
                                    const SizedBox(height: 16),
                                    const Text('สมัครสมาชิกสำเร็จ!', style: TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () => Navigator.pop(context),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey[300],
                                            minimumSize: const Size(115, 42),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8.42),
                                            ),
                                          ),
                                          child: const Text('ยกเลิก', style: TextStyle(color: Colors.black)),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            context.router.replace(
                                              OTPLoginRoute(email: _emailController.text.trim()),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: mainColor,
                                            minimumSize: const Size(115, 42),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8.42),
                                            ),
                                          ),
                                          child: const Text('ยืนยัน', style: TextStyle(color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("สมัครไม่สำเร็จ: ${response.body}")),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("เกิดข้อผิดพลาด: $e")),
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 12),

                    // ปุ่มกลับไปล็อกอิน
                    AppButton(
                      title: "ฉันมีบัญชีอยู่แล้ว",
                      type: ButtonType.outlined,
                      onPressed: () {
                        context.router.replaceNamed('/login');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
