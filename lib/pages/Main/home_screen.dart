import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pascapanen_mobile/model/berita_model.dart';
import 'package:pascapanen_mobile/services/berita_service.dart';
import 'package:pascapanen_mobile/services/profile_service.dart';
import 'package:pascapanen_mobile/model/profile_model.dart';
import 'package:pascapanen_mobile/pages/Berita/Detail_Berita_Screen.dart';
import 'package:pascapanen_mobile/pages/detail_transaksi/detail.dart';
import 'package:pascapanen_mobile/pages/toko/toko_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<BeritaModel> beritaList = [];
  bool isLoading = true;
  Profile? profil;

  final Color primaryColor = const Color(0xFF166534);
  final Color secondaryColor = const Color(0xFF4B5563);
  final Color backgroundColor = const Color(0xFFF3F4F6);

  @override
  void initState() {
    super.initState();
    fetchBerita();
    fetchProfil();
  }

  Future<void> fetchBerita() async {
    final api = BeritaService();
    final data = await api.fetchBerita();
    setState(() {
      beritaList = data;
      isLoading = false;
    });
  }

  Future<void> fetchProfil() async {
    try {
      final profileData = await ProfileService.fetchProfile();
      setState(() {
        profil = profileData;
      });
    } catch (e) {
      print("Gagal mengambil profil: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // HEADER GRADIENT
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, const Color(0xFF22C55E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/logoapk.png'),
                    ),
                    profil == null
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                          "Hi, ${profil!.namaLengkap}",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    const Icon(Icons.notifications, color: Colors.white),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 24),
              _buildPinjamanCard(),
              const SizedBox(height: 24),

              // KATEGORI
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Kategori Produk",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildKategoriRow(),
              const SizedBox(height: 24),

              // BERITA
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Berita",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                    children:
                        beritaList
                            .map((berita) => _buildBeritaCard(context, berita))
                            .toList(),
                  ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            icon: Icon(Icons.search, color: secondaryColor),
            hintText: "Cari Produk, Berita, dsb",
            hintStyle: GoogleFonts.poppins(),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildKategoriRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildProductItem(Icons.apps, "Semua", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TokoScreen(kategori: "Semua"),
              ),
            );
          }),
          _buildProductItem(Icons.rice_bowl, "Beras", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TokoScreen(kategori: "Beras"),
              ),
            );
          }),
          _buildProductItem(Icons.eco, "Pupuk", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TokoScreen(kategori: "Pupuk"),
              ),
            );
          }),
          _buildProductItem(Icons.healing, "Obat", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TokoScreen(kategori: "Obat"),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProductItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: primaryColor,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildPinjamanCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFD1FAE5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primaryColor.withOpacity(0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Pinjaman",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Tertahan",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Rp 1.000.000", style: GoogleFonts.poppins()),
                Text("Rp 1.000.000", style: GoogleFonts.poppins()),
              ],
            ),
            const Divider(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DetailScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "Detail Transaksi",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBeritaCard(BuildContext context, BeritaModel berita) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => DetailBeritaPage(
                    judul: berita.judul,
                    isi: berita.isi,
                    gambar: berita.fullIUrl,
                  ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  berita.fullIUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) =>
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
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Baca Selengkapnya",
                      style: GoogleFonts.poppins(color: primaryColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
