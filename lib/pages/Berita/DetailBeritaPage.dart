import 'package:flutter/material.dart';

class DetailBeritaPage extends StatelessWidget {
  final String judul;
  final String isi;
  final String gambar;

  const DetailBeritaPage({
    required this.judul,
    required this.isi,
    required this.gambar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                gambar,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(judul,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(isi, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
