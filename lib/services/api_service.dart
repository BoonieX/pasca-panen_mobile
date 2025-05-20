import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/register_request.dart';
import '../model/login_request.dart';
import '../model/user_model.dart';

class AuthService {

  static const String baseUrl = "http://192.168.1.13:8000/api";

  // ✅ REGISTER
  Future<bool> register(RegisterRequest request) async {
    final url = Uri.parse('$baseUrl/register');
    final body = json.encode(request.toJson());

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      final data = json.decode(response.body);
      if (response.statusCode == 201) {
        print("Registrasi berhasil: ${data['message']}");
        return true;
      } else {
        print("Gagal registrasi: ${data['message'] ?? 'Unknown error'}");
        return false;
      }
    } catch (e) {
      print("Error saat registrasi: $e");
      return false;
    }
  }

  // ✅ LOGIN
  Future<UserModel?> login(LoginRequest request) async {
    final url = Uri.parse('$baseUrl/login');
    final body = json.encode(request.toJson());

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      final data = json.decode(response.body);
      print("RESPON LOGIN: $data");

      if (response.statusCode == 200 && data != null) {
        final token = data['token'];
        final userData = data['user'];

        if (token != null && token is String) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString(
            'last_login',
            DateTime.now().toIso8601String(),
          ); // ✅ Simpan waktu login
          print("Login berhasil! Token & waktu login disimpan.");

          if (userData != null && userData is Map<String, dynamic>) {
            return UserModel.fromJson(userData, token: token);
          } else {
            print("Data user tidak ditemukan atau invalid.");
          }
        } else {
          print("Token tidak ditemukan atau bukan String.");
        }
      } else {
        print("Login gagal: ${data['message'] ?? 'Unknown error'}");
      }
    } catch (e) {
      print("Error saat login: $e");
    }

    return null;
  }

  // ✅ GET USER FROM TOKEN
  Future<UserModel?> getUserFromToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      final url = Uri.parse('$baseUrl/user');

      try {
        final response = await http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final user = data['user'];

          if (user != null && user is Map<String, dynamic>) {
            return UserModel.fromJson(user, token: token);
          } else {
            print("User tidak ditemukan dalam response.");
          }
        } else {
          print("Gagal mendapatkan data user: ${response.body}");
        }
      } catch (e) {
        print("Error ambil user dari token: $e");
      }
    }

    return null;
  }

  // ✅ LOGOUT
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('last_login'); // ✅ Hapus waktu login juga
  }

  // ✅ CEK APAKAH LOGIN MASIH BERLAKU (maksimal 1 hari)
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final lastLoginStr = prefs.getString('last_login');

    if (token != null && token.isNotEmpty && lastLoginStr != null) {
      final lastLogin = DateTime.tryParse(lastLoginStr);
      if (lastLogin != null) {
        final now = DateTime.now();
        final difference = now.difference(lastLogin);

        // Jika sudah lebih dari 5 hari
        if (difference.inDays <= 1) {
          return true; // Token masih aktif dan belum lebih dari 5 hari
        } else {
          print("Token kadaluwarsa, auto logout setelah 1 hari.");
          await logout(); // Token expired setelah 1 hari
          return false;
        }
      }
    }

    return false;
  }

  // ✅ GET TOKEN
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

}
