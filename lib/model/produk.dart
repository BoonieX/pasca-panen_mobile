class Produk {
  final int id;
  final String namaProduk;
  final String kategori;
  final double harga;
  final int stok;
  final String satuan;
  final String gambar;
  final DateTime createdAt;
  final DateTime updatedAt;

  Produk({
    required this.id,
    required this.namaProduk,
    required this.kategori,
    required this.harga,
    required this.stok,
    required this.satuan,
    required this.gambar,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id_produk'] ?? json['id'] ?? 0,
      namaProduk: json['nama_produk'] ?? '',
      kategori: (json['kategori'] ?? '').toString().toLowerCase(), // lowercase
      harga: double.tryParse(json['harga'].toString()) ?? 0.0,
      stok: json['stok'] ?? 0,
      satuan: json['satuan'] ?? '',
      gambar: json['gambar'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  String get fullImageUrl =>
      'http://192.168.1.13:8000/storage/${gambar.replaceAll("storage/", "")}';
}
