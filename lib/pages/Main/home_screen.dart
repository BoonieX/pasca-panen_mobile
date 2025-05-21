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
// baground kotak atas
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: Stack(
        children: [
          Container(
            height: 150,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 19, 199, 61), Color(0xFF6FA9FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      CircleAvatar(
                       backgroundImage: AssetImage('assets/logoapk.png'),
                      ),
                      Text(
                        "Hi, Pak User",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Icon(Icons.notifications, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.search, color: Colors.grey.shade600),
                        hintText: "Cari Produk, Berita, dsb",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: [
                  //     _buildFeatureButton(Icons.shopping_bag, "Produk"),
                  //     _buildFeatureButton(Icons.article, "Berita"),
                  //     _buildFeatureButton(Icons.history, "Riwayat"),
                  //     _buildFeatureButton(Icons.person, "Profil"),
                  //   ],
                  // ),
                  const SizedBox(height: 24),
                  _buildPinjamanCard(),
                  const SizedBox(height: 24),
                  const Text("Kategori Produk",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  const Text("Berita",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          children: beritaList.map((berita) {
                            return _buildBeritaCard(context, berita);
                          }).toList(),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 26,
          child: Icon(icon, color: Color(0xFF4B75FF)),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
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

  Widget _buildPinjamanCard() {
    return Container(
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Rp XXXXXXXX"),
              Text("Rp XXXXXXXX"),
            ],
          ),
          const Divider(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DetailScreen()),
              );
            },
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

  Widget _buildBeritaCard(BuildContext context, BeritaModel berita) {
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
            color: const Color(0xFFD1FAE5),
            borderRadius: BorderRadius.circular(12),
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
                    const Text("Baca Selengkapnya",
                        style: TextStyle(color: Colors.green)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
