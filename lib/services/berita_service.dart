import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pascapanen_mobile/model/berita_model.dart';

class BeritaService {
  static const String baseUrl = 'http://192.168.1.20:8000/api'; 

  Future<List<BeritaModel>> fetchBerita() async {
    final response = await http.get(Uri.parse('$baseUrl/berita'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['data'];
      return jsonData.map((item) => BeritaModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil data berita');
    }
  }
}
