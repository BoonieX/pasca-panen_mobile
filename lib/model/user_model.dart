// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  String namaLengkap;
  String username;
  String gender;
  String email;
  String noTelp;
  String alamat;
  String password;
  UserModel({
    required this.namaLengkap,
    required this.username,
    required this.gender,
    required this.email,
    required this.noTelp,
    required this.alamat,
    required this.password,
  });

  UserModel copyWith({
    String? namaLengkap,
    String? username,
    String? gender,
    String? email,
    String? noTelp,
    String? alamat,
    String? password,
  }) {
    return UserModel(
      namaLengkap: namaLengkap ?? this.namaLengkap,
      username: username ?? this.username,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      noTelp: noTelp ?? this.noTelp,
      alamat: alamat ?? this.alamat,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'namaLengkap': namaLengkap,
      'username': username,
      'gender': gender,
      'email': email,
      'noTelp': noTelp,
      'alamat': alamat,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      namaLengkap: map['namaLengkap'] as String,
      username: map['username'] as String,
      gender: map['gender'] as String,
      email: map['email'] as String,
      noTelp: map['noTelp'] as String,
      alamat: map['alamat'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(namaLengkap: $namaLengkap, username: $username, gender: $gender, email: $email, noTelp: $noTelp, alamat: $alamat, password: $password)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.namaLengkap == namaLengkap &&
      other.username == username &&
      other.gender == gender &&
      other.email == email &&
      other.noTelp == noTelp &&
      other.alamat == alamat &&
      other.password == password;
  }

  @override
  int get hashCode {
    return namaLengkap.hashCode ^
      username.hashCode ^
      gender.hashCode ^
      email.hashCode ^
      noTelp.hashCode ^
      alamat.hashCode ^
      password.hashCode;
  }
}
