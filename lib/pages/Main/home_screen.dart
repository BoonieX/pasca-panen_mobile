import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              )
            ],
          ),
          const SizedBox(height: 20),

          // Informasi pinjaman
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFD1FAE5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Pinjaman", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Tertahan", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Rp XXXXXXXX"),
                    Text("Rp XXXXXXXX"),
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
          ),
          const SizedBox(height: 24),

          // Produk
          const Text("Produk", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF065F46))),
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
          const Text("Berita", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF065F46))),
          const SizedBox(height: 12),

          // Daftar Berita
          Column(
            children: List.generate(9, (index) => _buildNewsItem()),
          ),
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

  Widget _buildNewsItem() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFD1FAE5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              color: Colors.grey[300],
              child: const Icon(Icons.image),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Lorem ipsum dolor sit amet, consectetur aaa",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  Text("Baca Selengkapnya", style: TextStyle(color: Colors.green)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
