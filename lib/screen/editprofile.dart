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
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


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
  

  String selectedGender = 'หญิง'; // default
  final List<String> genderOptions = ['ชาย', 'หญิง', 'อื่นๆ'];

  XFile? _imageFile; // ✅ ตัวแปรเก็บรูปภาพ
  String? avatarBase64;


  @override
void initState() {
  super.initState();
  fetchUserData();
} // ✅ เรียกฟังก์ชันโหลดข้อมูลโปรไฟล์เก่า

  
// ✅ ฟังก์ชันเลือกภาพจาก Gallery
  Future<void> _pickImage() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    setState(() {
      _imageFile = pickedFile;
    });
  }

}



// ✅ ฟังก์ชันโหลดข้อมูลโปรไฟล์เก่า
Future<void> fetchUserData() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('user_id');
  if (userId == null) return;

  try {
    final data = await ApiService.get('/users/$userId');

    setState(() {
      nameController.text = data['name'] ?? '';
      emailController.text = data['email'] ?? '';
      phoneController.text = data['phone'] ?? '';
      selectedGender = data['gender'] ?? 'หญิง';

      // ✅ ถ้ามี base64 รูป ให้เก็บไว้แสดง
      final avatar = data['avatar_url'];
      if (avatar != null && avatar.toString().isNotEmpty) {
        prefs.setString('avatar_base64', avatar);
        avatarBase64 = avatar; // ✅ ใช้ตัวแปรใน class
      } else {
        avatarBase64 = prefs.getString('avatar_base64');
      }
    });
  } catch (e) {
    print('❌ โหลดข้อมูลล้มเหลว: $e');
  }
}




  
// ✅ ฟังก์ชันอัปเดตโปรไฟล์
  Future<void> updateProfile() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (userId == null) throw Exception('ไม่พบ user_id');

    String? base64Image;

    if (_imageFile != null) {
      final bytes = await _imageFile!.readAsBytes();
      base64Image = base64Encode(bytes);
      avatarBase64 = base64Image; // <== เก็บไว้แสดงในหน้า
      await prefs.setString('avatar_base64', base64Image);
    }

    final body = {
      "name": nameController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      "gender": selectedGender,
      if (base64Image != null) "avatar_base64": base64Image,
    };

    await ApiService.put('/users/update/$userId', body);

    await prefs.setString('profile_name', nameController.text);
    await prefs.setString('profile_email', emailController.text);
    await prefs.setString('profile_phone', phoneController.text);
    await prefs.setString('profile_gender', selectedGender);

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
        onPressed: () => context.router.replaceNamed('/profile'),
        style: TextButton.styleFrom(
          minimumSize: const Size(10, 20),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        child: const Text(
          'ยกเลิก',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: redColor,
            fontWeight: FontWeight.bold,
          ),
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
                  'lib/assets/image/3.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: _imageFile != null
                      ? FileImage(File(_imageFile!.path))
                      : (avatarBase64 != null
                          ? MemoryImage(base64Decode(avatarBase64!))
                          : const AssetImage('lib/assets/image/15.png')) as ImageProvider,
                  child: const Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(Icons.edit, size: 20, color: Colors.grey),
                  ),
                ),
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

              // Gender & Phone
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

              // Email
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
                                OutlinedButton.icon(
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
                                ElevatedButton(
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
                              ],
                            ),
                          ],
                        ),
                      ),
                    );

                    if (confirm == true) {
                      await updateProfile();
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