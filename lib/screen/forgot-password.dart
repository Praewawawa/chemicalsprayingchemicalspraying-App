// screen/forgot-password.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:chemicalspraying/router/routes.gr.dart';
import 'package:chemicalspraying/components/app_button.dart';
import 'package:chemicalspraying/constants/colors.dart';
import 'package:chemicalspraying/services/api_service.dart';

@RoutePage(name: 'ForgotPasswordRoute')
class ForgotPassword extends StatefulWidget {
  static const String routeName = "/forgot-password";
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();

  Future<void> sendOtpForReset() async {
    final email = emailController.text.trim();

    final response = await ApiService.post('/otp/create-otp', {
      "email": email,
      "purpose": "reset"
    });

    if (response.statusCode == 200) {
      context.router.push(
        OTPVerificationRoute(
          email: email,
          purpose: 'reset',
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ไม่สามารถส่ง OTP ได้")),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
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
            const SizedBox(height: 20),
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
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'example@gmail.com',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: mainColor),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),
            const SizedBox(height: 12),
            AppButton(
              title: "ยืนยัน",
              onPressed: sendOtpForReset,
            ),
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
