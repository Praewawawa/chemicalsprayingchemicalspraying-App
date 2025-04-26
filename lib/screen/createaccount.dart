// screen/createaccount.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:chemicalspraying/components/app_button.dart';
import 'package:chemicalspraying/router/routes.gr.dart';
import 'package:chemicalspraying/components/cardInfo.dart';
import 'package:chemicalspraying/constants/colors.dart';
import 'package:chemicalspraying/services/api_service.dart';

@RoutePage( name: 'CreateAccountRoute')
class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CreateAccountScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _selectedGender = 'เพศชาย';

  @override
Widget build(BuildContext context) {
  return Scaffold(

backgroundColor: const Color(0xFFF0FAFF),
    body: Stack(
      children: [

      

        //  รูปมุมล่างซ้าย
        Align(
          alignment: Alignment.bottomCenter,
          child: ClipRect(
            child: Opacity(
              opacity: 0.3,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.40,
                width: MediaQuery.of(context).size.width * 1.0,
                child: Image.asset(
                  'lib/assets/image/15.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),

        // ✅ ฟอร์ม
        Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'สร้างบัญชีสมาชิก',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'ชื่อบัญชีผู้ใช้',
                      labelStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: mainColor),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: mainColor, width: 2),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ✅ แถว เพศ + เบอร์โทร
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 60,
                          child: DropdownButtonFormField<String>(
                            value: _selectedGender,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedGender = newValue!;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'เพศ',
                              labelStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(color: mainColor),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: mainColor, width: 2),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            items: ['เพศชาย', 'เพศหญิง', 'อื่นๆ']
                                .map<DropdownMenuItem<String>>(
                                    (String value) => DropdownMenuItem(
                                          value: value,
                                          child: Text(value),
                                        ))
                                .toList(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 60,
                          child: TextField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: 'เบอร์โทรศัพท์',
                              labelStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(color: mainColor),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: mainColor, width: 2),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'อีเมล',
                      labelStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: mainColor),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: mainColor, width: 2),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'รหัสผ่าน',
                      labelStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: mainColor),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: mainColor, width: 2),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'ยืนยันรหัสผ่าน',
                      labelStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: mainColor),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                        focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: mainColor, width: 2),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    obscureText: true,
                  ),

                  const SizedBox(height: 20),

                  // ✅ ปุ่มสมัครสมาชิก
                  AppButton(
                  title: "สมัครสมาชิก",
                  onPressed: () async {
                    // 🔹 เช็กว่ารหัสผ่านและยืนยันรหัสผ่านตรงกันไหม
                    if (_passwordController.text != _confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("รหัสผ่านไม่ตรงกัน")),
                      );
                      return;
                    }

                    try {
                      // 🔹 ยิง API ไปหลังบ้าน
                      final response = await ApiService.registerUser({
                        "fullname": _usernameController.text.trim(),
                        "email": _emailController.text.trim(),
                        "phone": _phoneController.text.trim(),
                        "gender": _selectedGender,
                        "password": _passwordController.text.trim(),
                      });

                      if (response.statusCode == 201) {
                        // 🔹 ถ้าสมัครสำเร็จ แสดง Dialog สำเร็จ
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle, color: mainColor, size: 40),
                                const SizedBox(height: 16),
                                const Text(
                                  'สมัครสมาชิกสำเร็จ!',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey[300],
                                        minimumSize: const Size(115, 42),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.42),
                                        ),
                                      ),
                                      child: const Text('ยกเลิก', style: TextStyle(color: Colors.black)),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        context.router.replaceNamed('/otplogin');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: mainColor,
                                        minimumSize: const Size(115, 42),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.42),
                                        ),
                                      ),
                                      child: const Text('ยืนยัน', style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("สมัครไม่สำเร็จ: ${response.body}")),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("เกิดข้อผิดพลาด: $e")),
                      );
                    }
                  },
                ),


                  const SizedBox(height: 12),

                  AppButton(
                    title: "ฉันมีบัญชีอยู่แล้ว",
                    type: ButtonType.outlined,
                    onPressed: () {
                      context.router.replaceNamed('/login');
                      print("ฉันมีบัญชีอยู่แล้ว");
                    },
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
