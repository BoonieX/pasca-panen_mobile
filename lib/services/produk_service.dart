import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pascapanen_mobile/model/produk.dart';

class ProdukService {
  final String baseUrl = 'http://192.168.103.201:8000/api';

  Future<dynamic> fetchProdukList() async {
    final response = await http.get(Uri.parse('$baseUrl/produk'));
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['data']['data'];
      return jsonData.map((item) => Produk.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil data produk');
    }
  }

  Future<Produk> fetchProdukById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/produk/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body)['data'];
      return Produk.fromJson(jsonData);
    } else {
      throw Exception('Produk tidak ditemukan');
    }
  }
}
