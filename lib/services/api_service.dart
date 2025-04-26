// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://192.168.0.116:3000/api'; 
  // ✅ เปลี่ยน IP ให้ตรงกับ Server จริง

  // ✅ ฟังก์ชัน Login
  static Future<http.Response> loginUser(String email, String password) async {
    final url = Uri.parse('$_baseUrl/users/login');
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
    final url = Uri.parse('$_baseUrl/users/register');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  // ✅ ฟังก์ชัน PUT (เช่น /users/update/:id)
  static Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse(_baseUrl + endpoint);
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

  // ✅ ฟังก์ชัน POST (เช่น /control, /gps)
  static Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse(_baseUrl + endpoint);
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

  // ✅ ฟังก์ชัน GET (เช่น /control/:device_id)
  static Future<dynamic> get(String endpoint) async {
    final url = Uri.parse(_baseUrl + endpoint);
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
}
