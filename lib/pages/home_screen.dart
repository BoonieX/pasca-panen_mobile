import 'package:flutter/material.dart';
import 'package:pascapanen_mobile/widgets/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});
  

  @override
  Widget build(BuildContext context) {
    Color primaryGreen = const Color(0xFF6DBF4B);
    Color darkGreen = const Color(0xFF2E7D32);
    Color softGreen = const Color(0xFFF0F8F2);

        return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Halo, $userName"),
        backgroundColor: primaryGreen,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.black),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Card Pinjaman & Tertahan
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: softGreen,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Pinjaman",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text("Rp 1.000.000"),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Tertahan",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text("Rp 1.000.000"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Aksi detail transaksi
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Detail Transaksi"),
                      ),
                    )
                  ],
                ),
              ),
            ),

            // Produk
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Produk",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: darkGreen)),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildProductItem(Icons.all_inclusive, "Semua"),
                  _buildProductItem(Icons.rice_bowl, "Beras"),
                  _buildProductItem(Icons.grass, "Pupuk"),
                  _buildProductItem(Icons.healing, "Obat"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Berita
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Berita",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: darkGreen)),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16))),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Kenaikan Harga Pupuk!",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            SizedBox(height: 8),
                            Text(
                                "Harga pupuk naik 20% bulan ini, petani diminta waspada."),
                            SizedBox(height: 8),
                            Text("Baca Selengkapnya...",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontStyle: FontStyle.italic)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          // Navigasi antar halaman
          if (index == 0) {
            // Home
          } else if (index == 1) {
            Navigator.pushNamed(context, '/produk');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/notifikasi');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/akun');
          }
        },
      ),
    );
  }

  Widget _buildProductItem(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xFFDEF4DB),
          child: Icon(icon, color: Colors.green),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
