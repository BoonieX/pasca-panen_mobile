class Profile {
  final String namaLengkap;
  final String username;
  final String email;
  final String gender;
  final String noTelp;
  final String alamat;
  final String? logo;

  Profile({
    required this.namaLengkap,
    required this.username,
    required this.email,
    required this.gender,
    required this.noTelp,
    required this.alamat,
    this.logo,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      namaLengkap: json['nama_lengkap'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      gender: json['gender'] as String,
      noTelp: json['no_telp'] as String,
      alamat: json['alamat'] as String,
      logo: json['logo'] != null ? json['logo'] as String : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_lengkap': namaLengkap,
      'username': username,
      'email': email,
      'gender': gender,
      'no_telp': noTelp,
      'alamat': alamat,
      'logo': logo,
    };
  }

  @override
  String toString() {
    return 'Profile(namaLengkap: $namaLengkap, username: $username, email: $email, gender: $gender, no_telp: $noTelp, alamat: $alamat, logo: $logo)';
  }
}