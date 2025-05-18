// screen/login.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:chemicalspraying/router/routes.gr.dart';
import 'package:chemicalspraying/components/app_button.dart';
import 'package:chemicalspraying/constants/colors.dart';
import 'package:chemicalspraying/services/api_service.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart'; // ✅ เพิ่ม


@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack( // ใช้ Stack สำหรับซ้อน background + เนื้อหา
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: ClipRect(
              child: Opacity(
                opacity: 0.3,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Image.asset(
                    'lib/assets/image/16.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Center( // จัดกลางทั้งแนวตั้งแนวนอน
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(height: 75),
                      Text(
                        "ลงชื่อเข้าใช้",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: mainColor,
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(height: 26),
                      const Text(
                        'ยินดีต้อนรับสู่\nสวนไม้ผลอัจฉริยะ!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: blackColor,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Email Field
                      SizedBox(
                        width: 362,
                        height: 70,
                        child: TextField(
                          controller: _emailController,
                          inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]')),
                        ],

                          decoration: InputDecoration(
                            labelText: 'อีเมล',
                            labelStyle: const TextStyle(color: grayColor, fontSize: 16),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: mainColor),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: mainColor, width: 2),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Password Field
                      SizedBox(
                        width: 362,
                        height: 70,
                        child: TextField(
                          controller: _passwordController,
                          inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')), // อนุญาตเฉพาะ a-z A-Z 0-9
                    ],
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'รหัสผ่าน',
                            labelStyle: const TextStyle(color: grayColor, fontSize: 16),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: mainColor),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: mainColor, width: 2),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Forgot Password
                      TextButton(
                        onPressed: () {
                          context.router.push(const ForgotPasswordRoute());
                        },
                        child: const Text(
                          "ลืมรหัสผ่าน?",
                          style: TextStyle(
                            color: Color.fromRGBO(121, 118, 118, 1),
                            fontSize: 14,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ปุ่มเข้าสู่ระบบ
                      AppButton(
                        title: "เข้าสู่ระบบ",
                        width: 357,
                        height: 65,
                        onPressed: () async {
                      if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("กรุณากรอกอีเมลและรหัสผ่าน")),
                        );
                        return;
                      }

                      try {
                        final response = await ApiService.loginUser(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        );

                        if (response.statusCode == 200) {
                          final body = jsonDecode(response.body);

                          // ✅ Save user info ลง SharedPreferences
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setInt('user_id', body['user']['id']);
                          await prefs.setString('profile_name', body['user']['name']);
                          await prefs.setString('profile_email', body['user']['email']);
                          await prefs.setString('profile_phone', body['user']['phone'] ?? '');
                          await prefs.setString('profile_gender', body['user']['gender'] ?? '');

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("เข้าสู่ระบบสำเร็จ")),
                          );

                          context.router.replaceNamed('/addprofile'); // ✅ ไปหน้า addprofile หรือหน้าหลัก
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("เข้าสู่ระบบล้มเหลว: ${response.body}")),
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

                      // ปุ่มสมัครสมาชิก
                      AppButton(
                        title: "สมัครสมาชิก",
                        width: 357,
                        height: 65,
                        type: ButtonType.outlined,
                        onPressed: () {
                          context.router.replaceNamed('/createaccount');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
