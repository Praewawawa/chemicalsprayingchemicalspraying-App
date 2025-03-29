import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:chemicalspraying/router/routes.gr.dart';

@RoutePage(name: 'ForgotPasswordRoute')
class ForgotPassword extends StatelessWidget {
  static const String routeName = "/forgot-password";
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
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
                  borderSide: BorderSide(color: Colors.grey),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                context.router.push(const LoginRoute());
              },
              child: Text(
                'กลับไปยังหน้า ลงชื่อเข้าใช้',
                style: TextStyle(color: Colors.green, fontSize: 14),
              ),
            ),

            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  context.router.push(const OTPVerificationRoute());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'ยืนยัน',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 20),
              TextButton(
              onPressed: () {
                context.router.push(const LoginRoute());
              },
              child: const Text(
                'คุณมีบัญชีอยู่แล้วหรือไม่ ? ลงชื่อเข้าใช้',
                style: TextStyle(color: Colors.green, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
