import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String nama;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String telepon;

  @HiveField(4)
  final String alamat;

  @HiveField(5)
  final String gender;

  @HiveField(6)
  final String password;

  UserModel({
    required this.nama,
    required this.username,
    required this.email,
    required this.telepon,
    required this.alamat,
    required this.gender,
    required this.password,
  });
}
