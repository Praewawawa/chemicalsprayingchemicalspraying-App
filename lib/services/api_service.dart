// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.0.116:3000/api'; // ✅ เปลี่ยนตาม IP Server

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

  // ✅ POST: คืน response ดิบ (ใช้กับ OTP, Reset password ฯลฯ)
  static Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse(baseUrl + endpoint);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return jsonDecode(response.body); // คืนค่าผลลัพธ์ดิบ
  }

  // ✅ GET
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

  // ✅ PUT
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

  // ✅ (ไม่บังคับ) verify OTP แบบเฉพาะ route
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

    return response.statusCode == 200 && body['message'] == 'ยืนยัน OTP สำเร็จ';
  }

  
}
