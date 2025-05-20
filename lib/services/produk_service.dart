import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/produk.dart';

class ProdukService {
  final String baseUrl = 'http://192.168.2.206:8000/api';

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
