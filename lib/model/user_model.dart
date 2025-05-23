class UserModel {
  final int id;
  final String namaLengkap;
  final String username;
  final String gender;
  final String email;
  final String noTelp;
  final String alamat;
  final String token;

  UserModel({
    required this.id,
    required this.namaLengkap,
    required this.username,
    required this.gender,
    required this.email,
    required this.noTelp,
    required this.alamat,
    required this.token,
  });

  /// Digunakan saat parsing dari response API
  factory UserModel.fromJson(Map<String, dynamic> json, {String token = ''}) {
    return UserModel(
      id: json['id'] ?? 0,
      namaLengkap: json['nama_lengkap'] ?? '',
      username: json['username'] ?? '',
      gender: json['gender'] ?? '',
      email: json['email'] ?? '',
      noTelp: json['no_telp'] ?? '',
      alamat: json['alamat'] ?? '',
      token: token,
    );
  }

  /// Digunakan saat menyimpan data ke lokal (misalnya SQLite)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      namaLengkap: map['nama_lengkap'],
      username: map['username'],
      gender: map['gender'],
      email: map['email'],
      noTelp: map['no_telp'],
      alamat: map['alamat'],
      token: map['token'],
    );
  }

  /// Digunakan saat kirim data ke API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_lengkap': namaLengkap,
      'username': username,
      'gender': gender,
      'email': email,
      'no_telp': noTelp,
      'alamat': alamat,
      'token': token,
    };
  }

  /// Digunakan saat simpan data ke database lokal
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_lengkap': namaLengkap,
      'username': username,
      'gender': gender,
      'email': email,
      'no_telp': noTelp,
      'alamat': alamat,
      'token': token,
    };
  }
}
