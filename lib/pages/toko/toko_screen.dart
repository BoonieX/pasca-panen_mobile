import 'package:flutter/material.dart';
import 'pembelian.dart';

class TokoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Produk Toko',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xFFD1FAE5),
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF10B981),
          onPrimary: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF10B981),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: ProdukPage(),
    );
  }
}

class ProdukPage extends StatefulWidget {
  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  String kategoriAktif = 'Semua';

  final List<Map<String, dynamic>> kategori = [
    {'icon': Icons.store, 'label': 'Semua'},
    {'icon': Icons.rice_bowl, 'label': 'Beras'},
    {'icon': Icons.grass, 'label': 'Pupuk'},
    {'icon': Icons.medical_services, 'label': 'Obat'},
  ];

  final List<Map<String, String>> semuaProduk = [
    {
      'nama': 'Beras Super',
      'stok': '100',
      'harga': 'Rp. 50.000',
      'kategori': 'Beras',
      'gambar': 'https://via.placeholder.com/150',
    },
    {
      'nama': 'Pupuk Organik',
      'stok': '50',
      'harga': 'Rp. 30.000',
      'kategori': 'Pupuk',
      'gambar': 'https://via.placeholder.com/150',
    },
    {
      'nama': 'Obat Hama',
      'stok': '75',
      'harga': 'Rp. 40.000',
      'kategori': 'Obat',
      'gambar': 'https://via.placeholder.com/150',
    },
    {
      'nama': 'Beras Premium',
      'stok': '120',
      'harga': 'Rp. 60.000',
      'kategori': 'Beras',
      'gambar': 'https://via.placeholder.com/150',
    },
  ];

  List<Map<String, String>> get produkTersaring {
    if (kategoriAktif == 'Semua') return semuaProduk;
    return semuaProduk
        .where((produk) => produk['kategori'] == kategoriAktif)
        .toList();
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
          // Kategori Scroll
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    kategori.map((item) {
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
                            backgroundColor:
                                selected
                                    ? const Color(0xFF10B981)
                                    : Colors.grey[300],
                            foregroundColor:
                                selected ? Colors.white : Colors.black,
                          ),
                          icon: Icon(item['icon']),
                          label: Text(item['label']),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),

          // Produk Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: produkTersaring.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final item = produkTersaring[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFF10B981)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          item['gambar']!,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['nama']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Stock : ${item['stok']}'),
                            Text(
                              item['harga']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PurchaseFormPage(produk: item),
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
