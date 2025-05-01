// screen/forgot-password.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:chemicalspraying/router/routes.gr.dart';
import 'package:chemicalspraying/components/app_button.dart';
import 'package:chemicalspraying/constants/colors.dart';
import 'package:chemicalspraying/services/api_service.dart';
import 'dart:convert';


@RoutePage(name: 'ForgotPasswordRoute')
class ForgotPassword extends StatefulWidget {
  static const String routeName = "/forgot-password";
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();



Future<void> sendOtpForReset() async {
  final email = _emailController.text.trim();

  if (email.isEmpty || !email.contains('@')) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("กรุณาใส่อีเมลที่ถูกต้อง")),
    );
    return;
  }

  try {
    final rawResponse = await ApiService.post('/otp/create-otp', {
      "email": email,
      "purpose": "reset"
    });

    final response = jsonDecode(rawResponse.body); // ✅ แปลง body เป็น JSON

    if (response['message'] != null &&
        response['message'].toString().toLowerCase().contains('otp')) {
      context.router.push(
        OTPLoginRoute(email: email, purpose: 'reset'),
      );
    } else {
      final errorMsg = response['message']?.toString() ?? "ไม่สามารถส่ง OTP ได้";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("ไม่สามารถส่ง OTP ได้: $errorMsg")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("เกิดข้อผิดพลาดในการส่ง OTP")),
    );
  }
}


  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FAFF),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            const Center(
              child: Text(
                'ลืมรหัสผ่าน',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'ป้อนที่อยู่อีเมล',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'example@gmail.com',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: mainColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: mainColor, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),
            const SizedBox(height: 20),
            AppButton(
              title: "ยืนยัน",
              onPressed: sendOtpForReset,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'คุณมีบัญชีอยู่แล้วหรือไม่ ?, ',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.router.push(const LoginRoute());
                  },
                  child: const Text(
                    'ลงชื่อเข้าใช้',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
