import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:chemicalspraying/router/routes.gr.dart'; 
import 'package:chemicalspraying/components/app_button.dart';

@RoutePage(name: 'ResetPasswordRoute')
class ResetPassword extends StatelessWidget {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'รหัสผ่านใหม่',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              const Text('ป้อนรหัสผ่านใหม่', style: TextStyle(fontSize: 16)),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                hintText: 'อย่างน้อย 8 หลัก',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0), // ✅ OK ไม่ใช้ const
                ),
              ),

              ),
              const SizedBox(height: 20),
              const Text('ยืนยันรหัสผ่าน', style: TextStyle(fontSize: 16)),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration:  InputDecoration(
                  hintText: '********',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 12),
                    AppButton(title: "ยืนยัน", onPressed: () {
                      context.router.replaceNamed('/login');
                      print("ยืนยัน");
                    }),
            ],
          ),
        ),
      ),
    );
  }
}
