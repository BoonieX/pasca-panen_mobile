import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pascapanen_mobile/model/profile_model.dart';

class ProfileService {
  static const _baseUrl =
      'http://192.168.43.182:8000/api'; // Ganti dengan base URL Laravel-mu
  static final Dio _dio = Dio(BaseOptions(baseUrl: _baseUrl));

  /// Attach Bearer Token dari SharedPreferences ke header Dio
  static Future<void> _attachToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      _dio.options.headers['Accept'] = 'application/json';
    }
  }

  /// Ambil data profil dari API
  static Future<Profile> fetchProfile() async {
    await _attachToken();
    final response = await _dio.get('/profile');
    return Profile.fromJson(response.data['data']);
  }

  /// Update profil melalui API
  static Future<void> updateProfile(Profile profile) async {
    await _attachToken();
    await _dio.post('/profile/update', data: profile.toJson());
  }
}
