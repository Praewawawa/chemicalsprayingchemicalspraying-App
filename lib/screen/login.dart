import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:chemicalspraying/router/routes.gr.dart'; // เปลี่ยน your_app_name ให้ตรงกับชื่อโปรเจกต์


@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var _emailController;
    var _passwordController;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 75,
                ),
                Container(
                  child: Text(
                    "ลงชื่อเข้าใช้",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(71, 192, 61, 1),
                        fontSize: 30),
                  ),
                ),
                SizedBox(
                  height: 26,
                ),
                Container(
                  child: Text(
                    '\t\t\t\t'"ยินดีตอนรับสู่\nสวนไม้ผลอัจฉริยะ!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 58,
                ),
                // Email Field
                TextField(
                  decoration: InputDecoration(
                    labelText: 'อีเมล',
                    labelStyle: const TextStyle(color: Colors.green),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Password Field
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'รหัสผ่าน',
                    suffixText: 'ลืมรหัสผ่าน',
                    suffixStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                /*TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'อีเมล',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'รหัสผ่าน',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(
                  height: 9,
                ),*/

                TextButton(
                      onPressed: () {
                        context.router.push(const ForgotPasswordRoute());
                      },
                      child: Text(
                        "ลืมรหัสผ่าน?",
                        style: TextStyle(
                          color: Color.fromRGBO(121, 118, 118, 1), fontSize: 14),
                      ),
                    ),

                    // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      context.router.replaceNamed('/addprofile');
                    },// เพิ่ม navigation logic ที่นี่
                    
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // ปุ่มเขียว
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      'เข้าสู่ระบบ',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      context.router.replaceNamed('/createaccount');// เพิ่ม navigation ไปยังหน้าสมัครสมาชิก
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.green, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      'สร้างบัญชีสมาชิก',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                /*SizedBox(
                  height: 109,
                ),
                Container(
                  height: 65,
                  width: 357,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromRGBO(71, 192, 61, 1))),
                    onPressed: () {
                      context.router.replaceNamed('/addprofile');
                    },
                    child: Text(
                      "เข้าสู่ระบบ",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 55,
                  width: 357,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(71, 192, 61, 1),
                      width: 2.5,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    child: InkWell(
                      onTap: () {
                        context.router.replaceNamed('/createaccount');
                      },
                      borderRadius: BorderRadius.circular(12.0),
                      child: Center(
                        child: Text(
                          'สมัครสมาชิก',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),*/

                /*SizedBox(
                  height: 109,
                ),
                Container(
                  height: 65,
                  width: 357,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromRGBO(71, 192, 61, 1))),
                            
                    onPressed: () {
                      context.router.replaceNamed('/addprofile');
                    },
                    child: Text(
                      "เข้าสู่ระบบ",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 41,
                  width: 357,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(71, 192, 61, 1), // สีกรอบ
                      width: 2.5, // ความหนาของกรอบ
                    ),
                    borderRadius: BorderRadius.circular(10.0), // มุมโค้งมน
                  ),
                  child: Material(
                    color: Colors.white, // สีปุ่ม
                    child: InkWell(
                      onTap: () {
                        context.router.replaceNamed('/createaccount');
                      },
                      child: Center(
                        child: Text('สร้างบัญชี',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 194,
                ),*/
                /*TextButton(
                  onPressed: () {},
                  child: Text('Don\'t have an Account? ' 'Sign up',
                      style: TextStyle(color: Colors.black, fontSize: 14)),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
