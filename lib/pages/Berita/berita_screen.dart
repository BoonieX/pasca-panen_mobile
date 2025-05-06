import 'package:flutter/material.dart';
import 'package:pascapanen_mobile/pages/Berita/DetailBeritaPage.dart';

class BeritaScreen extends StatelessWidget {

  final List<Map<String, String>> beritaList = [
    {
      "judul": "Pasar Tradisional Semakin Ramai",
      "isi": "Pasar tradisional di daerah X mengalami peningkatan pengunjung...",
      "gambar": "assets/berita1.jpg"
    },
    {
      "judul": "Harga Beras Mengalami Kenaikan",
      "isi": "Kenaikan harga beras terjadi akibat cuaca ekstrem...",
      "gambar": "assets/berita2.jpg"
    },
    {
      "judul": "Petani Muda Sukses di Desa",
      "isi": "Seorang pemuda berhasil membuktikan bahwa bertani itu keren...",
      "gambar": "assets/berita3.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00D26A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00D26A),
        elevation: 0,
        title: const Text("Berita", style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00D26A), Color(0xFFE8FFE9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: beritaList.length,
          itemBuilder: (context, index) {
            final berita = beritaList[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailBeritaPage(
                      judul: berita['judul']!,
                      isi: berita['isi']!,
                      gambar: berita['gambar']!,
                    ),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.green.shade100,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          berita['gambar']!,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              berita['judul']!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              berita['isi']!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Baca Selengkapnya",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}