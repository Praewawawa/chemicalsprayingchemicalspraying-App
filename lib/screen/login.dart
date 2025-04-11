import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:chemicalspraying/router/routes.gr.dart'; // เปลี่ยน your_app_name ให้ตรงกับชื่อโปรเจกต์
import 'package:chemicalspraying/components/app_button.dart';
import 'package:chemicalspraying/constants/colors.dart'; // เปลี่ยนให้ตรงกับที่เก็บสีในโปรเจกต์ของคุณ



@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
@override
Widget build(BuildContext context) {
  // ✅ ประกาศ Controller ไว้ด้านบน
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  return Scaffold(
    backgroundColor: Colors.white,
    body: Center( // ✅ จัดกลางทั้งแนวตั้งแนวนอน
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // ตรงกลางแนวนอน
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 75),
                Text(
                  "ลงชื่อเข้าใช้",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 26),
                const Text(
                  'ยินดีต้อนรับสู่\nสวนไม้ผลอัจฉริยะ!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: blackColor,
                    fontSize: 20,
                  ),
                ),

                const SizedBox(height: 30),

                // ✅ Email Field
                SizedBox(
                  width: 362,
                  height: 70,
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'อีเมล',
                      labelStyle: const TextStyle(color: mainColor, fontSize: 16),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: mainColor),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: mainColor, width: 2),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),

                const SizedBox(height: 16),

                // ✅ Password Field
                SizedBox(
                  width: 362,
                  height: 70,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'รหัสผ่าน',
                      suffixText: 'ลืมรหัสผ่าน',
                      suffixStyle: const TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),

                const SizedBox(height: 30),

                // ✅ Forgot Password
                TextButton(
                  onPressed: () {
                    context.router.push(const ForgotPasswordRoute());
                  },
                  child: const Text(
                    "ลืมรหัสผ่าน?",
                    style: TextStyle(
                      color: Color.fromRGBO(121, 118, 118, 1),
                      fontSize: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ✅ ปุ่มเข้าสู่ระบบ
                AppButton(
                  title: "เข้าสู่ระบบ",
                  width: 357,
                  height: 65,
                  onPressed: () {
                    context.router.replaceNamed('/addprofile');
                    print("เข้าสู่ระบบ");
                  },
                ),

                const SizedBox(height: 12),

                // ✅ ปุ่มสมัครสมาชิก
                AppButton(
                  title: "สมัครสมาชิก",
                  width: 357,
                  height: 65,
                  type: ButtonType.outlined,
                  onPressed: () {
                    context.router.replaceNamed('/createaccount');
                    print("สมัครสมาชิก");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}
