// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.247.205:3000/api'; // ✅ เปลี่ยนตาม IP Server
 //192.168.0.116
 //192.168.46.205
  // ✅ Login
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

  // ✅ Register
  static Future<http.Response> registerUser(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/users/register');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  // ✅ PUT: สำหรับอัปเดตโปรไฟล์หรือส่ง base64
  static Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
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

  // ✅ POST (ส่งข้อมูลทั่วไป, คืน JSON)
  static Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
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

  // ✅ GET
  static Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
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

  // ✅ OTP Verification แบบกำหนด route
  static Future<bool> verifyOtp(String email, String otpCode, String purpose) async {
  final url = Uri.parse('$baseUrl/otp/verify-otp');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'otp_code': otpCode,
      'purpose': purpose,
    }),
  );

  final body = jsonDecode(response.body);
  print('✅ VERIFY OTP RESPONSE: ${response.statusCode} => $body');

  return response.statusCode == 200 && body['message'] == 'ยืนยัน OTP สำเร็จ';
}

}
