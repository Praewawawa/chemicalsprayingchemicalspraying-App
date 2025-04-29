// screen/otplogin.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:chemicalspraying/router/routes.gr.dart'; 
import 'package:chemicalspraying/constants/colors.dart'; // เปลี่ยนให้ตรงกับที่เก็บสีในโปรเจกต์ของคุณ
import 'package:chemicalspraying/components/app_button.dart'; // เปลี่ยนให้ตรงกับที่เก็บปุ่มในโปรเจกต์ของคุณ
import 'package:chemicalspraying/services/api_service.dart'; // ✅ ต้องมี

@RoutePage(name: 'OTPLoginRoute')
class OTPLoginPage extends StatefulWidget {
  // ✅ รับอีเมลจากหน้า Login
  final String email;

  const OTPLoginPage({super.key, required this.email});

  @override
  State<OTPLoginPage> createState() => _OTPLoginPageState();
}

// ✅ ต้องเป็น State แยกจาก Widget แบบนี้
class _OTPLoginPageState extends State<OTPLoginPage> {
 

    final List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  final List<FocusNode> otpFocusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );


Future<void> sendOtpToEmail() async {
  try {
    final response = await ApiService.post('/otp/create-otp', {
      "email": widget.email,
      "purpose": "register"
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response['message'])),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ส่ง OTP ไม่สำเร็จ')),
    );
  }
}


    Future<bool> verifyOtp() async {
  final otpCode = otpControllers.map((c) => c.text).join();

  if (otpCode.length != 6) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('กรุณากรอก OTP ให้ครบ 6 หลัก')),
    );
    return false;
  }

  try {
    final response = await ApiService.post('/otp/verify-otp', {
      "email": widget.email,
      "otp_code": otpCode,
      "purpose": "register"
    });

    if (response['message'] == 'ยืนยัน OTP สำเร็จ') {
      return true; // ✅ ยืนยันสำเร็จ
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP ไม่ถูกต้องหรือหมดอายุ')),
      );
      return false;
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('เกิดข้อผิดพลาดในการยืนยัน OTP')),
    );
    return false;
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
            ),
          ),
        ),


          // ✅ เพิ่มปุ่มส่ง OTP อีกครั้ง
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
                sendOtpToEmail(); // ✅ เรียกฟังก์ชันเฉยๆ ไม่ต้องส่ง email เข้าไป
                print("ส่งรหัส OTP อีกครั้งไปยังอีเมล: ${widget.email}");
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


          const SizedBox(height: 20),

          // ✅ เปลี่ยนปุ่มเป็น AppButton
          AppButton(
          title: "ยืนยัน",
          width: 348.24,
          height: 58.92,
          onPressed: () async {
            final otpCode = otpControllers.map((c) => c.text).join(); // ✅ รวมรหัส OTP

            if (otpCode.length == 6) {
              final success = await ApiService.verifyOtp(widget.email, otpCode);


              if (success) {
                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    content: SizedBox(
                      width: 260,
                      height: 360,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.verified, color: mainColor, size: 150),
                          const SizedBox(height: 20),
                          const Text(
                            "สมัครสมาชิกสำเร็จ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );


              // รอ 2 วินาที แล้วเปลี่ยนหน้า
              await Future.delayed(const Duration(seconds: 2));
              if (context.mounted) {
                Navigator.of(context).pop(); // ปิด popup
                context.router.replaceNamed('/login'); // ไปหน้า login
              }
            }
  }
  }
          ),
        ],
      ),
    ),
  );
}
}
