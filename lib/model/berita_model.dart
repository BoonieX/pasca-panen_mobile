class BeritaModel {
  final int id;
  final String judul;
  final String isi;
  final String gambar;

  BeritaModel({
    required this.id,
    required this.judul,
    required this.isi,
    required this.gambar,
  });

  factory BeritaModel.fromJson(Map<String, dynamic> json) {
    return BeritaModel(
      id: json['id'] ?? 0,
      judul: json['judul'] ?? '',
      isi: json['isi'] ?? '',
      gambar: json['gambar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'isi': isi,
      'gambar': gambar,
    };
  }

  String get fullIUrl =>
      'http://192.168.43.182:8000/storage/${gambar.replaceAll("storage/", "")}';
}
