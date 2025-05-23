import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pascapanen_mobile/model/produk.dart';
import 'package:pascapanen_mobile/services/produk_service.dart';
import 'pembelian_produk_screen.dart';

class TokoScreen extends StatefulWidget {
  final String kategori;

  const TokoScreen({super.key, this.kategori = 'Semua'});

  @override
  State<TokoScreen> createState() => _TokoScreenState();
}

class _TokoScreenState extends State<TokoScreen> {
  late String kategoriAktif;
  List<Produk> semuaProduk = [];
  bool isLoading = true;

  final List<Map<String, dynamic>> kategori = [
    {'icon': Icons.store, 'label': 'Semua'},
    {'icon': Icons.rice_bowl, 'label': 'Beras'},
    {'icon': Icons.grass, 'label': 'Pupuk'},
    {'icon': Icons.medical_services, 'label': 'Obat'},
  ];

  final _formatRupiah = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    kategoriAktif = widget.kategori;
    fetchProduk();
  }

  Future<void> fetchProduk() async {
    setState(() => isLoading = true);
    try {
      final api = ProdukService();
      final data = await api.fetchProdukList();
      setState(() {
        semuaProduk = data;
      });
    } catch (e) {
      debugPrint('Error fetch produk: $e');
      if (mounted) {
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text('Terjadi Kesalahan'),
                content: Text('Gagal memuat produk. Coba lagi nanti.\n\n$e'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Tutup'),
                  ),
                ],
              ),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  List<Produk> get produkTersaring {
    if (kategoriAktif == 'Semua') {
      return semuaProduk;
    } else {
      return semuaProduk
          .where(
            (produk) =>
                produk.kategori.toLowerCase() == kategoriAktif.toLowerCase(),
          )
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produk Toko'),
        backgroundColor: const Color(0xFF166534),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFDFFFE0), Color(0xFFF5FFF6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Kategori
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      kategori.map((item) {
                        final bool selected = item['label'] == kategoriAktif;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: ElevatedButton.icon(
                            onPressed:
                                isLoading
                                    ? null
                                    : () {
                                      setState(() {
                                        kategoriAktif = item['label'];
                                      });
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  selected
                                      ? const Color(0xFF166534)
                                      : Colors.grey[200],
                              foregroundColor:
                                  selected ? Colors.white : Colors.black87,
                              elevation: selected ? 4 : 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            icon: Icon(item['icon'], size: 20),
                            label: Text(item['label']),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),

            // Grid Produk
            Expanded(
              child: RefreshIndicator(
                onRefresh: fetchProduk,
                child:
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : produkTersaring.isEmpty
                        ? const Center(child: Text('Produk tidak ditemukan'))
                        : GridView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: produkTersaring.length,
                          shrinkWrap: true, // penting!
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 15,
                                crossAxisSpacing: 15,
                                childAspectRatio: 0.72,
                              ),
                          itemBuilder: (context, index) {
                            final produk = produkTersaring[index];
                            return _buildProdukCard(produk);
                          },
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProdukCard(Produk produk) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 9),
          ),
        ],
        border: Border.all(color: const Color(0xFF166534), width: 0.9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Produk
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
            child: Container(
              color: Colors.grey[200],
              child: Image.network(
                produk.fullImageUrl,
                height: 90,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 64,
                      color: Colors.grey,
                    ),
              ),
            ),
          ),

          // Info Produk + Spacer fleksibel
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produk.namaProduk,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF166534),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Stok: ${produk.stok}',
                    style: TextStyle(fontSize: 12.5, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatRupiah.format(produk.harga),
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(), // Biar tombol tetap di bawah
                ],
              ),
            ),
          ),

          // Tombol Beli
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF166534),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(8),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PurchaseFormPage(produk: produk),
                  ),
                );
              },
              child: const Text(
                "Beli",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
