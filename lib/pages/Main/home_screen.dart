import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pascapanen_mobile/model/berita_model.dart';
import 'package:pascapanen_mobile/pages/Berita/DetailBeritaPage.dart';
import 'package:pascapanen_mobile/services/berita_service.dart';
import 'package:pascapanen_mobile/pages/detail_transaksi/detail.dart'; 
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<BeritaModel> beritaList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBerita();
  }

  Future<void> fetchBerita() async {
    final api = BeritaService();
    final data = await api.fetchBerita();
    setState(() {
      beritaList = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2ecc71), Color(0xFFF0FDF4)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        // Background image dengan opacity
        Positioned.fill(
          child: Opacity(
            opacity: 0.30,
            child: Image.asset(
              'assets/background_pattern.png', // ganti dengan gambar yang cocok
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Blur halus
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: const SizedBox(),
          ),
        ),
        // Konten utama
        LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/logoapk.png',
                            height: 40,
                          ),
                          const Text(
                            'Halo, Pak User',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const CircleAvatar(
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.person, color: Colors.white),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Informasi Pinjaman & Tertahan
                      _buildCardBox(
                        title1: "Pinjaman",
                        value1: "Rp XXXXXXXX",
                        title2: "Tertahan",
                        value2: "Rp XXXXXXXX",
                      ),
                      const SizedBox(height: 24),

                      // Produk
                      const Text("Produk",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF065F46),
                          )),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildProductItem(Icons.apps, "Semua"),
                          _buildProductItem(Icons.rice_bowl, "Beras"),
                          _buildProductItem(Icons.eco, "Pupuk"),
                          _buildProductItem(Icons.healing, "Obat"),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Berita
                      const Text("Berita",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF065F46),
                          )),
                      const SizedBox(height: 12),

                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Column(
                              children: beritaList.map((berita) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => DetailBeritaPage(
                                          judul: berita.judul,
                                          isi: berita.isi,
                                          gambar: berita.gambar,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.05),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          )
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.network(
                                              berita.gambar,
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) =>
                                                  const Icon(Icons.broken_image, size: 80),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  berita.judul,
                                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                                ),
                                                const SizedBox(height: 8),
                                                const Text(
                                                  "Baca Selengkapnya",
                                                  style: TextStyle(color: Colors.green),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCardBox({
    required String title1,
    required String value1,
    required String title2,
    required String value2,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title1, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(title2, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value1),
              Text(value2),
            ],
          ),
          const Divider(height: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text("Detail Transaksi"),
          )
        ],
      ),
    );
  }

  Widget _buildProductItem(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xFF10B981),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12))
      ],
    );
  }
}
