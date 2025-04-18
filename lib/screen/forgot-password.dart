import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:chemicalspraying/router/routes.gr.dart';
import 'package:chemicalspraying/components/app_button.dart';
import 'package:chemicalspraying/constants/colors.dart';

@RoutePage(name: 'ForgotPasswordRoute')
class ForgotPassword extends StatelessWidget {
  static const String routeName = "/forgot-password";
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FAFF),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                'ลืมรหัสผ่าน',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 40),
            Text(
              'ป้อนที่อยู่อีเมล',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'example@gmail.com',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: mainColor),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),


            const SizedBox(height: 12),
                    AppButton(title: "ยืนยัน", onPressed: () {
                      context.router.push(const OTPVerificationRoute());
                      print("ยืนยัน");
                    }),
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
