import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:chemicalspraying/components/app_button.dart';
import 'package:chemicalspraying/router/routes.gr.dart';
import 'package:chemicalspraying/components/cardInfo.dart';
import 'package:chemicalspraying/constants/colors.dart';

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
    body: Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'สร้างบัญชีสมาชิก',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'ชื่อบัญชีผู้ใช้',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        items: <String>[
                          'เพศชาย',
                          'เพศหญิง',
                          'อื่นๆ',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 60,
                      child: TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'เบอร์โทรศัพท์',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'อีเมล',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'รหัสผ่าน',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'ยืนยันรหัสผ่าน',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),

              /// ✅ ปุ่ม "สมัครสมาชิก"
              AppButton(
                title: "สมัครสมาชิก",
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle,
                              color: mainColor, size: 40),
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
                                child: const Text('ยกเลิก',
                                    style: TextStyle(color: Colors.black)),
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
                                child: const Text('ยืนยัน',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              /// ✅ ปุ่ม "ฉันมีบัญชีอยู่แล้ว"
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
  );
}
}
