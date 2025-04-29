// screen/otpverification.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:chemicalspraying/router/routes.gr.dart'; 
import 'package:chemicalspraying/components/app_button.dart';


@RoutePage()
class OTPVerificationScreen extends StatelessWidget {
  final String email;
  final String purpose;
  const OTPVerificationScreen({Key? key,required this.email,required this.purpose,}) : super(key: key);
  static const String routeName = "/otp-verification";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'ยืนยันอีเมล',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'กรุณากรอกรหัสหมายเลข OTP ที่ส่งไปยังอีเมลของคุณ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                6,
                (index) => SizedBox(
                  width: 50,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    decoration: InputDecoration(
                      counterText: '',
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'หากคุณไม่ได้รับรหัส, ',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: ใส่ logic ส่ง OTP ไปยังอีเมลที่นี่
                  print("ส่งรหัส OTP อีกครั้งไปยังอีเมล");
                  // คุณสามารถใช้ฟังก์ชันเช่น sendOtpToEmail() ได้ที่นี่
                },
                child: const Text(
                  'กดส่งอีกครั้ง',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),


            const SizedBox(height: 12),
                    AppButton(title: "ยืนยัน", onPressed: () {
                      context.router.push(ResetPasswordRoute());
                      print("ยืนยัน");
                    }),
          ],
        ),
      ),
    );
  }
}
