import 'package:flutter/material.dart';
import 'package:pascapanen_mobile/model/produk.dart';
import 'package:pascapanen_mobile/services/produk_service.dart';
import 'purchase_form_page.dart';

class TokoScreen extends StatefulWidget {
  const TokoScreen({super.key});

  @override
  State<TokoScreen> createState() => _TokoScreenState();
}

class _TokoScreenState extends State<TokoScreen> {
  String kategoriAktif = 'Semua';
  List<Produk> semuaProduk = [];
  bool isLoading = true;

  final List<Map<String, dynamic>> kategori = [
    {'icon': Icons.store, 'label': 'Semua'},
    {'icon': Icons.rice_bowl, 'label': 'Beras'},
    {'icon': Icons.grass, 'label': 'Pupuk'},
    {'icon': Icons.medical_services, 'label': 'Obat'},
  ];

  @override
  void initState() {
    super.initState();
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
    } finally {
      setState(() => isLoading = false);
    }
  }

  List<Produk> get produkTersaring {
    if (kategoriAktif == 'Semua') return semuaProduk;

    // Gunakan lowercase untuk pencocokan yang konsisten
    return semuaProduk.where((produk) {
      return produk.kategori.toLowerCase() == kategoriAktif.toLowerCase();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produk Toko'),
        backgroundColor: const Color(0xFF10B981),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Tombol Kategori
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: kategori.map((item) {
                  final bool selected = item['label'] == kategoriAktif;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          kategoriAktif = item['label'];
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selected
                            ? const Color(0xFF10B981)
                            : Colors.grey[300],
                        foregroundColor: selected ? Colors.white : Colors.black,
                      ),
                      icon: Icon(item['icon']),
                      label: Text(item['label']),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Grid Produk
          if (isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child: produkTersaring.isEmpty
                  ? const Center(child: Text('Produk tidak ditemukan'))
                  : GridView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: produkTersaring.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, index) {
                        final produk = produkTersaring[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xFF10B981)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              // Gambar Produk
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(10)),
                                  child: Image.network(
                                    produk.fullImageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.broken_image, size: 64),
                                  ),
                                ),
                              ),

                              // Informasi Produk
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 4,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      produk.namaProduk,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text('Stok : ${produk.stok}'),
                                    Text(
                                      'Harga : Rp ${produk.harga}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Tombol Beli
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => PurchaseFormPage(produk: produk),
                                      ),
                                    );
                                  },
                                  child: const Text("Beli"),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
        ],
      ),
    );
  }
}
