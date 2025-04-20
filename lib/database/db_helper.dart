import 'package:hive/hive.dart';
import 'package:collection/collection.dart';
import '../model/user_model.dart';

class DbHelper {
  static const String _boxName = 'users';

  // Singleton pattern
  DbHelper._privateConstructor();
  static final DbHelper instance = DbHelper._privateConstructor();

  Future<void> initHive() async {
    await Hive.openBox<UserModel>(_boxName);
  }

  Future<void> insertUser(UserModel user) async {
    final box = Hive.box<UserModel>(_boxName);
    await box.add(user);
  }

  Future<UserModel?> getUserByUsername(String username) async {
    final box = Hive.box<UserModel>(_boxName);
    return box.values.firstWhereOrNull(
      (user) => user.username == username,
    );
  }

  Future<List<UserModel>> getAllUsers() async {
    final box = Hive.box<UserModel>(_boxName);
    return box.values.toList();
  }

  Future<void> close() async {
    await Hive.close();
  }
}
