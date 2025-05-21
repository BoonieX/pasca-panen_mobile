import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileService {
  static const String _baseUrl = 'http://192.168.1.20:8000/api'; // ganti dengan IP server

  static Future<Map<String, dynamic>> get(String path, {String? token}) async {
    final url = Uri.parse("$_baseUrl$path");
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    });

    return json.decode(response.body);
  }
}
