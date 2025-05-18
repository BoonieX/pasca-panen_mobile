import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import '../models/produk.dart';


class ProdukService {
  final String baseUrl = 'https://yourdomain.com/api/produk';

  Future<List<Produk>> fetchProdukList({String? search}) async {
    try {
      final response = await http.get(Uri.parse(
        search != null ? '$baseUrl?search=$search' : baseUrl,
      ));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> items = data['data']['data'];
        return items.map((json) => Produk.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat produk');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Produk> fetchProdukById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Produk.fromJson(data['data']);
    } else {
      throw Exception('Produk tidak ditemukan');
    }
  }

  Future<bool> deleteProduk(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    return response.statusCode == 200;
  }

  Future<bool> createProduk({
    required String namaProduk,
    required String kategori,
    required int harga,
    required int stok,
    required String satuan,
    required File gambar,
  }) async {
    final uri = Uri.parse(baseUrl);
    final request = http.MultipartRequest('POST', uri);

    request.fields['nama_produk'] = namaProduk;
    request.fields['kategori'] = kategori;
    request.fields['harga'] = harga.toString();
    request.fields['stok'] = stok.toString();
    request.fields['satuan'] = satuan;

    final fileStream = await http.MultipartFile.fromPath('gambar', gambar.path,
        filename: basename(gambar.path));
    request.files.add(fileStream);

    final response = await request.send();
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> updateProduk({
    required int id,
    required String namaProduk,
    required String kategori,
    required int harga,
    required int stok,
    required String satuan,
    File? gambar,
  }) async {
    final uri = Uri.parse('$baseUrl/$id');
    final request = http.MultipartRequest('POST', uri);

    request.fields['nama_produk'] = namaProduk;
    request.fields['kategori'] = kategori;
    request.fields['harga'] = harga.toString();
    request.fields['stok'] = stok.toString();
    request.fields['satuan'] = satuan;

    if (gambar != null) {
      final fileStream = await http.MultipartFile.fromPath('gambar', gambar.path,
          filename: basename(gambar.path));
      request.files.add(fileStream);
    }

    final response = await request.send();
    return response.statusCode == 200 || response.statusCode == 201;
  }
}
