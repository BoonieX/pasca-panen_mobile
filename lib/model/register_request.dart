class RegisterRequest {
  final String namaLengkap;
  final String username;
  final String email;
  final String noTelp;
  final String gender;
  final String alamat;
  final String password;

  RegisterRequest({
    required this.namaLengkap,
    required this.username,
    required this.email,
    required this.noTelp,
    required this.gender,
    required this.alamat,
    required this.password,
  });

  // Mengonversi objek RegisterRequest menjadi map JSON
  Map<String, dynamic> toJson() {
    return {
      'nama_lengkap': namaLengkap,
      'username': username,
      'email': email,
      'no_telp': noTelp,
      'gender': gender,
      'alamat': alamat,
      'password': password,
    };
  }
}
