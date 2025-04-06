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
      body: SafeArea(
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
                    AppButton(title: "เข้าสู่ระบบ", onPressed: () {
                      context.router.push(const LoginRoute());
                      print("เข้าสู่ระบบ");
                    }),
                    const SizedBox(height: 12),
                    AppButton(title: "สมัครสมาชิก", type: ButtonType.outlined, onPressed: () {
                      context.router.push(const CreateAccountRoute());
                      print("สมัครสมาชิก");
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FAFF),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  image: const DecorationImage(
                    image: AssetImage('lib/assets/image/image.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Smart Orchard Control",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              
              "สวนไม้ผลสำหรับคุณ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            // จุด Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: index == 1 ? Colors.green : Colors.green[100],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // ปุ่มเข้าสู่ระบบ
            SizedBox(
              height: 60,
              width: 160,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1DC10B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  context.router.replaceNamed('/login');
                },
                child: const Text(
                  "เข้าสู่ระบบ",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // ปุ่มสมัครสมาชิก
            SizedBox(
              height: 60,
              width: 160,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.green,
                  side: const BorderSide(color: Colors.green),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  context.router.replaceNamed('/createaccount');
                },
                child: const Text(
                  "สมัครสมาชิก",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}*/
  