// screen/otplogin.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:chemicalspraying/router/routes.gr.dart';
import 'package:chemicalspraying/constants/colors.dart';
import 'package:chemicalspraying/components/app_button.dart';
import 'package:chemicalspraying/services/api_service.dart';
import 'dart:convert';



@RoutePage(name: 'OTPLoginRoute')
class OTPLoginPage extends StatefulWidget {
  final String email;
  final String purpose;

  const OTPLoginPage({
    super.key,
    required this.email,
    required this.purpose,
  });

  @override
  State<OTPLoginPage> createState() => _OTPLoginPageState();
}


// 🔑 หน้าจอกรอกรหัส OTP

class _OTPLoginPageState extends State<OTPLoginPage> {
  final List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> otpFocusNodes =
      List.generate(6, (_) => FocusNode());

Future<void> sendOtpToEmail() async {
  try {
    final response = await ApiService.post('/otp/create-otp', {
      "email": widget.email,
      "purpose": widget.purpose  // ✅ ดึงค่าจากตัวแปรที่กำหนดมาตอนเรียกหน้า
    });

        if (response.statusCode == 200) {
        context.router.replace(
        ResetPasswordRoute(email: widget.email),
      );  
      final body = jsonDecode(response.body);
      final message = body['message']?.toString() ?? 'ส่ง OTP ใหม่แล้ว';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
        
      );
      

    } else {
      print("⚠️ ไม่ใช่ 200: ${response.statusCode}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ส่ง OTP ไม่สำเร็จ: ${response.statusCode}')),
      );
    }


  } catch (e) {
    print("❌ OTP resend error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ส่ง OTP ไม่สำเร็จ')),
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
            const SizedBox(height: 40),
            const Text('ยืนยันอีเมล', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text(
              'กรุณากรอกรหัสหมายเลข OTP ที่ส่งไปยังอีเมลของคุณ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),

            // 🔢 ช่อง OTP 6 หลัก
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 50,
                  child: TextField(
                    controller: otpControllers[index],
                    focusNode: otpFocusNodes[index],
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
                    onChanged: (value) {
                      if (value.length == 1) {
                        if (index < 5) {
                          FocusScope.of(context).requestFocus(otpFocusNodes[index + 1]);
                        } else {
                          FocusScope.of(context).unfocus();
                        }
                      }
                    },
                  ),
                );
              }),
            ),

            const SizedBox(height: 16),

            // 🔁 ปุ่มส่ง OTP ใหม่
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('หากคุณไม่ได้รับรหัส, ', style: TextStyle(color: Colors.grey, fontSize: 14)),
                TextButton(
                  onPressed: sendOtpToEmail,
                  child: const Text(
                    'กดส่งอีกครั้ง',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ✅ ปุ่มยืนยัน
            AppButton(
              title: "ยืนยัน",
              width: 348.24,
              height: 58.92,
              onPressed: () async {
                final otpCode = otpControllers.map((c) => c.text).join();

                if (otpCode.length != 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("กรุณากรอก OTP ให้ครบ 6 หลัก")),
                  );
                  return;
                }

                final success = await ApiService.verifyOtp(widget.email, otpCode, widget.purpose);

                if (success) {
                final successMessage = widget.purpose == 'reset'
                    ? 'ยืนยัน OTP สำเร็จ'
                    : 'สมัครสมาชิกสำเร็จ';

                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                    content: SizedBox(
                      width: 260,
                      height: 360,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.verified, color: mainColor, size: 150),
                          const SizedBox(height: 20),
                          Text(
                            successMessage,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );

                await Future.delayed(const Duration(seconds: 1));

                if (context.mounted) {
                  Navigator.of(context).pop(); // ปิด dialog

                  if (widget.purpose == 'reset') {
                    print ("🔑 OTPLoginPage: ${widget.purpose}");
                    context.router.replace(
                      ResetPasswordRoute(email: widget.email),
                       // ✅ ไป reset password
                    );
                  } else {
                    context.router.replaceNamed('/login'); 
                  }
                }
              }
              },
            ),
          ],
        ),
      ),
    );
  }
}
