// screen/otpverification.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:chemicalspraying/router/routes.gr.dart';
import 'package:chemicalspraying/components/app_button.dart';
import 'package:chemicalspraying/services/api_service.dart'; // ✅ เพิ่ม

@RoutePage()
class OTPVerificationScreen extends StatefulWidget {
  final String email;
  final String purpose;

  const OTPVerificationScreen({Key? key, required this.email, required this.purpose}) : super(key: key);

  static const String routeName = "/otp-verification";

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());

  Future<void> verifyOtp(BuildContext context, String otpCode) async {
    final response = await ApiService.post('/otp/verify-otp', {
    "email": widget.email,
    "purpose": widget.purpose,
    "otp_code": otpCode
  });

  if (response.statusCode == 200) {
    context.router.push(ResetPasswordRoute(email: widget.email));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("ยืนยัน OTP สำเร็จ")),
    );
    } else if (response.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP หมดอายุ กรุณาขอ OTP ใหม่")),
      );
    } else if (response.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP ไม่ถูกต้อง กรุณาลองใหม่")),
      );
    } else if (response.statusCode == 500) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("เกิดข้อผิดพลาด กรุณาลองใหม่ภายหลัง")),
      );
    } else if (response.statusCode == 403) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP ถูกใช้แล้ว กรุณาขอ OTP ใหม่")),
      );
    } else if (response.statusCode == 404) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ไม่พบข้อมูล OTP กรุณาขอ OTP ใหม่")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("รหัส OTP ไม่ถูกต้องหรือหมดอายุ")),
      );
    }
  }

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
                    controller: otpControllers[index],
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
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                TextButton(
                  onPressed: () async {
                    await ApiService.post('/otp/create-otp', {
                      "email": widget.email,
                      "purpose": widget.purpose
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("ส่ง OTP ใหม่เรียบร้อยแล้ว")),
                    );
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
            AppButton(
              title: "ยืนยัน",
              onPressed: () {
                final otpCode = otpControllers.map((c) => c.text).join();
                if (otpCode.length != 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("กรุณากรอก OTP ให้ครบ 6 หลัก")),
                  );
                  return;
                }
                verifyOtp(context, otpCode);
              },
            ),
          ],
        ),
      ),
    );
  }
}
