class Profile {
  final String namaLengkap;
  final String username;
  final String email;
  final String noTelp;
  final String gender;
  final String alamat;
  final String role;
  final String createdAt;
  final String? logo;  // nullable, bisa null

  Profile({
    required this.namaLengkap,
    required this.username,
    required this.email,
    required this.noTelp,
    required this.gender,
    required this.alamat,
    required this.role,
    required this.createdAt,
    this.logo,  // tidak required supaya bisa null
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      namaLengkap: json['nama_lengkap'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      noTelp: json['no_telp'] ?? '',
      gender: json['gender'] ?? '',
      alamat: json['alamat'] ?? '',
      role: json['role'] ?? '',
      createdAt: (json['created_at'] ?? '').toString().substring(0, 10),
      logo: json['logo'] as String?,  // bisa null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_lengkap': namaLengkap,
      'username': username,
      'email': email,
      'no_telp': noTelp,
      'gender': gender,
      'alamat': alamat,
      'role': role,
      'created_at': createdAt,
      'logo': logo,
    };
  }

  String get loogo {
    if (logo == null || logo!.isEmpty) return '';
    // bersihkan 'storage/' kalau ada
    String cleanPath = logo!.replaceAll('storage/', '');
    // base URL backend kamu (ganti sesuai IP/domain)
    const baseUrl = 'http://192.168.43.182:8000/storage/';
    return baseUrl + cleanPath;
  }
}
