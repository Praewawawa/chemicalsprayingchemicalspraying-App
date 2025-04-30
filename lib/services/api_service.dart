// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static const String baseUrl = 'http://192.168.0.116:3000/api'; // หรือใช้ IP จริงถ้ารันบนมือถือ
  // ✅ เปลี่ยน IP ให้ตรงกับ Server จริง

  // ✅ ฟังก์ชัน Login
  static Future<http.Response> loginUser(String email, String password) async {
    final url = Uri.parse('$baseUrl/users/login');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );
  }

  // ✅ ฟังก์ชัน Register
  static Future<http.Response> registerUser(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/users/register');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  // ✅ ฟังก์ชัน POST ทั่วไป (เช่น /otp/create-otp, /control, /gps)
  static Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse(baseUrl + endpoint);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to POST data: ${response.body}');
    }
  }

  
  // ✅ ฟังก์ชันสำหรับการยืนยัน OTP
  static Future<bool> verifyOtp(String email, String otpCode) async {
    final url = Uri.parse('$baseUrl/otp/verify-otp');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'otp_code': otpCode,
        'purpose': 'register',
      }),
    );

    final body = jsonDecode(response.body);
    print('✅ VERIFY OTP RESPONSE: ${response.statusCode} => $body');

    if (response.statusCode == 200 && body['message'] == 'ยืนยัน OTP สำเร็จ') {
      return true;
    } else {
      return false;
    }
    return response;
  }




  // ✅ ฟังก์ชัน GET ทั่วไป (เช่น /control/:device_id, /gps/device/:device_id)
  static Future<dynamic> get(String endpoint) async {
    final url = Uri.parse(baseUrl + endpoint);
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to GET data: ${response.body}');
    }
  }

  // ✅ ฟังก์ชัน PUT ทั่วไป (เช่น /users/update/:id)
  static Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse(baseUrl + endpoint);
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to PUT data: ${response.body}');
    }
  }
}

