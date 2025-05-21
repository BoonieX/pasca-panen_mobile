import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/produk.dart';

class ProdukService {
  static const String baseUrl = 'http://192.168.1.20:8000/api';

  Future<List<Produk>> fetchProdukList() async {
    final response = await http.get(Uri.parse('$baseUrl/produk'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['data']['data'];
      return jsonData.map((item) => Produk.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil data produk');
    }
  }
}
