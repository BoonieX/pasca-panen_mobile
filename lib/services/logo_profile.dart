import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // untuk mime type
import 'package:mime/mime.dart'; // untuk deteksi mime

class LogoProfile {
  static const String baseUrl = 'http://192.168.43.182:8000/api';

  // Fungsi upload gambar profil
  static Future<bool> uploadProfileImage(File imageFile, String token) async {
    try {
      final uri = Uri.parse('$baseUrl/profile/upload-image');

      // deteksi tipe file
      final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
      final mimeTypeData = mimeType.split('/');

      final request = http.MultipartRequest('POST', uri);

      // tambah token untuk authorization header (jika perlu)
      request.headers['Authorization'] = 'Bearer $token';

      // attach file gambar
      request.files.add(
        await http.MultipartFile.fromPath(
          'logo', // nama field di backend Laravel
          imageFile.path,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
        ),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Upload gambar gagal, status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error upload gambar: $e');
      return false;
    }
  }
}
