class Produk {
  final int id;
  final String namaProduk;
  final String kategori;
  final int harga;
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
      id: json['id'],
      namaProduk: json['nama_produk'],
      kategori: json['kategori'],
      harga: json['harga'],
      stok: json['stok'],
      satuan: json['satuan'],
      gambar: json['gambar'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_produk': namaProduk,
      'kategori': kategori,
      'harga': harga,
      'stok': stok,
      'satuan': satuan,
      'gambar': gambar,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get fullImageUrl {
    // Ganti URL berikut dengan URL dari Laravel public storage yang sesuai
    return 'https://yourdomain.com/storage/$gambar';
  }
}
