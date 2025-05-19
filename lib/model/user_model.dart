  class UserModel {
    final int id;
    final String namaLengkap;
    final String username;
    final String gender;
    final String email;
    final String noTelp;
    final String alamat;
    final String token; // Token dipisahkan, tidak dari JSON 'user'

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

    // ✅ Ubah dariJson supaya token bisa dikasih dari luar
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
  }
