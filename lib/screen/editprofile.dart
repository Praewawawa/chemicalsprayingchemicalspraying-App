// screen/editprofile.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:chemicalspraying/router/routes.gr.dart'; 
import 'package:auto_route/annotations.dart';
import 'package:chemicalspraying/router/routes.dart'; 
import 'package:chemicalspraying/constants/colors.dart'; 
import 'package:chemicalspraying/services/api_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

@RoutePage(name: 'EditProfileRoute')
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String selectedGender = 'หญิง'; // default
  final List<String> genderOptions = ['ชาย', 'หญิง', 'อื่นๆ'];


  File? _image; // ✅ เพิ่มตัวแปรเก็บรูปภาพที่เลือก

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // ✅ โหลดข้อมูลเก่าเมื่อเปิดหน้า
  }
  // ✅ ฟังก์ชันโหลดข้อมูลโปรไฟล์เก่า
      void _loadProfileData() {
        setState(() {
          // ✅ สมมติเขียนข้อมูลเทสไว้ (จริงๆ ต้องโหลดจาก login หรือ local storage)
          nameController.text = 'ชื่อเดิมของผู้ใช้';
          emailController.text = 'อีเมลเดิมของผู้ใช้';
          phoneController.text = 'เบอร์เดิมของผู้ใช้';
          selectedGender = 'ชาย';
        });
      }

      Future<void> _pickImage() async {
        // ✅ ฟังก์ชันเลือกรูปจาก Gallery
        final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _image = File(pickedFile.path); // ✅ เก็บไฟล์ที่เลือก
          });
        }
      }

      Future<void> updateProfile() async {
        // ✅ ฟังก์ชันส่งข้อมูลอัปเดตโปรไฟล์ไปที่ Server
        try {
          await ApiService.put('/users/update/1', { // ✅ ต้องเปลี่ยน 1 เป็น user_id จริง
            "name": nameController.text,
            "email": emailController.text,
            "phone": phoneController.text,
            "gender": selectedGender,
            "password": passwordController.text.isNotEmpty ? passwordController.text : null,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('บันทึกข้อมูลสำเร็จ ✅')),
          );
          context.router.replace(const ProfileRoute());
        } catch (e) {
          print('❌ อัปเดตโปรไฟล์ล้มเหลว: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('บันทึกข้อมูลไม่สำเร็จ ❌')),
          );
        }
      }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
            appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: TextButton(
          onPressed: () => context.router.pop(), // ✅ ปุ่มยกเลิก กลับไปหน้า Profile
          child: const Text(
            'ยกเลิก',
            style: TextStyle(color: redColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: ClipRect(
              child: Opacity(
                opacity: 0.3,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.50,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Image.asset(
                    'assets/image/3.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          
          // ✅ เนื้อหา Scroll
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // ✅ รูปโปรไฟล์ (กดเปลี่ยนรูปได้)
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                    radius: 60,
                    backgroundImage: _image != null
                        ? FileImage(_image!) as ImageProvider
                        : const AssetImage('assets/images/profile.jpg'),
                  ),
                    // ✅ ปุ่มเปลี่ยนรูป

                    GestureDetector(
                      onTap: _pickImage, // ✅ กดแล้วเลือกรูป
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: const Icon(Icons.edit, size: 16, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Name
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'ชื่อ-นามสกุล',
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: const TextStyle(color: mainColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),

                // ✅ เพศ และ เบอร์โทร
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedGender,
                        items: genderOptions.map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        )).toList(),
                        onChanged: (value) => setState(() => selectedGender = value!),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'เบอร์โทร',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ✅ ช่อง Email
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),

                // ✅ ช่อง Password
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password (หากต้องการเปลี่ยน)',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 24),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3AC14D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.person, color: mainColor, size: 60),
                              const SizedBox(height: 16),
                              const Text(
                                'ยืนยันการแก้ไข\nข้อมูลโปรไฟล์',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        context.router.replace(const ProfileRoute());
                                      },
                                      icon: const Icon(Icons.close, color: mainColor),
                                      label: const Text(
                                        'ยกเลิก',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Colors.green),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: ElevatedButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: mainColor,
                                        minimumSize: const Size(120, 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        'ยืนยัน',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );

                      if (confirm == true) {
                        await updateProfile(); // ✅ เรียกฟังก์ชันอัปเดต
                        await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.check_circle, color: mainColor, size: 60),
                                SizedBox(height: 16),
                                Text(
                                  'บันทึกข้อมูลสำเร็จ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        );

                        context.router.replace(const ProfileRoute());
                      }
                    },
                    child: const Text(
                      'บันทึก',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
