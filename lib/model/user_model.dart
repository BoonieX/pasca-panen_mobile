class UserModel {
  final String namaLengkap;
  final String username;
  final String gender;
  final String email;
  final String noTelp;
  final String alamat;
  final String password;

  UserModel({
    required this.namaLengkap,
    required this.username,
    required this.gender,
    required this.email,
    required this.noTelp,
    required this.alamat,
    required this.password,
  });

  // Create a UserModel from a Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      namaLengkap: map['nama_lengkap'],
      username: map['username'],
      gender: map['gender'],
      email: map['email'],
      noTelp: map['no_telp'],
      alamat: map['alamat'],
      password: map['password'],
    );
  }

  // Convert the UserModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'nama_lengkap': namaLengkap,
      'username': username,
      'gender': gender,
      'email': email,
      'no_telp': noTelp,
      'alamat': alamat,
      'password': password,
    };
  }

  // Konversi ke JSON (untuk dikirim ke API)
  Map<String, dynamic> toJson() {
    return {
      'nama_lengkap': namaLengkap,
      'username': username,
      'email': email,
      'gender': gender,
      'no_telp': noTelp,
      'alamat': alamat,
      'password': password,
    };
  }

  // Create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      namaLengkap: json['nama_lengkap'],
      username: json['username'],
      gender: json['gender'],
      email: json['email'],
      noTelp: json['no_telp'],
      alamat: json['alamat'],
      password: json['password'],
    );
  }
}
