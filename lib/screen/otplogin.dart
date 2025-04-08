import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:chemicalspraying/router/routes.gr.dart'; 
import 'package:chemicalspraying/constants/colors.dart'; // เปลี่ยนให้ตรงกับที่เก็บสีในโปรเจกต์ของคุณ
import 'package:chemicalspraying/components/app_button.dart'; // เปลี่ยนให้ตรงกับที่เก็บปุ่มในโปรเจกต์ของคุณ

@RoutePage(name: 'OTPLoginRoute') // ใช้ @RoutePage() เพื่อให้ AutoRoute สร้างเส้นทางสำหรับหน้า
class OTPLoginPage  extends StatelessWidget {
    const OTPLoginPage ({super.key});
    

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
    ),
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
              4,
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
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              // TODO: เพิ่มฟังก์ชันส่งรหัสอีกครั้ง
            },
            child: const Text(
              'หากคุณไม่ได้รับรหัส, กดส่งอีกครั้ง',
              style: TextStyle(color: mainColor, fontSize: 14),
            ),
          ),

          const SizedBox(height: 20),

          // ✅ เปลี่ยนปุ่มเป็น AppButton
          AppButton(
            title: "ยืนยัน",
            width: 348.24,
            height: 58.92,
            onPressed: () async {
              // แสดง popup
              // ใช้ showDialog เพื่อแสดง popup
            showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
              content: SizedBox(
                width: 314.15, // กำหนดขนาดกล่อง dialog
                height: 402.94,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center, // ตรงกลางแนวตั้ง
                  crossAxisAlignment: CrossAxisAlignment.center, // ตรงกลางแนวนอน
                  children: [
                    Icon(Icons.verified, color: mainColor, size: 180), // ✅ แก้ตรงนี้
                    const SizedBox(height: 20),
                    const Text(
                      "สมัครสมาชิกสำเร็จ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 29,
                        color: Colors.black, // ✅ หรือใช้ blackColor ถ้าเคยประกาศไว้
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
            },
          ),
        ],
      ),
    ),
  );
}
}