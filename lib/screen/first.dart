// screen/first.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:chemicalspraying/router/routes.gr.dart';
import 'package:chemicalspraying/components/app_button.dart';

@RoutePage()
class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;

  return Scaffold(
    backgroundColor: const Color(0xFFF0FAFF),
    body: Stack( // ✅ ใช้ Stack ครอบเพื่อวาง Positioned และเนื้อหาหลัก
      children: [
        // ✅ วงกลมบนซ้าย
        Positioned(
          top: -200, // ขยับให้เฉลียงออกมาด้านบน
          left: -200, // ขยับให้เฉลียงออกซ้าย
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              color: Colors.lightGreen.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
          ),
        ),

        // ✅ เนื้อหาหลักทั้งหมด
        SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: size.width,
              height: size.height,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // รูปภาพด้านบน
                  Image.asset(
                    'lib/assets/image/image.png',
                    width: size.width * 0.6,
                  ),

                  // ข้อความ
                  Column(
                    children: const [
                      Text(
                        "Smart Orchard Control",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "สวนไม้ผลสำหรับคุณ",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  // จุดบอกตำแหน่ง (indicator)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: index == 1 ? Colors.green : Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ),

                  // ปุ่ม
                  Column(
                    children: [
                      const SizedBox(height: 12), 
                      AppButton(
                        title: "เข้าสู่ระบบ",
                        width: 160,
                        height: 60,
                        onPressed: () {
                          context.router.push(const LoginRoute());
                          print("เข้าสู่ระบบ");
                        }
                      ),
                      const SizedBox(height: 12),
                      AppButton(
                        title: "สมัครสมาชิก",
                        width: 160,
                        height: 60,
                        type: ButtonType.outlined,
                        onPressed: () {
                          context.router.push(const CreateAccountRoute());
                          print("สมัครสมาชิก");
                        }
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
}

