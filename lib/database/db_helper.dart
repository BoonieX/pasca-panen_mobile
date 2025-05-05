import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:pascapanen_mobile/model/user_model.dart';

class DbHelper {
  static Database? _database;

  // Membuka atau membuat database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  // Inisialisasi database
  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        // Membuat tabel pengguna dengan kolom-kolom yang sesuai
        return db.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY, nama_lengkap TEXT, username TEXT, gender TEXT, email TEXT, no_telp TEXT, alamat TEXT, token TEXT)",
        );
      },
    );
  }

  // Menyimpan user ke database
  Future<void> insertUser(UserModel user) async {
    final db = await database;
    await db.insert(
      'users',
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Gantikan jika sudah ada
    );
  }

  // Mengambil user berdasarkan id dengan opsi token
  Future<UserModel?> getUser(int id, {String token = ''}) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      // Memberikan token dari luar jika ada
      return UserModel.fromJson(result.first, token: token);
    }
    return null;
  }

  // Mengambil semua pengguna
  Future<List<UserModel>> getAllUsers() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query('users');
    return result.map((user) => UserModel.fromJson(user)).toList();
  }

  // Menghapus user berdasarkan id
  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // Menambahkan atau memperbarui token untuk pengguna
  Future<void> updateToken(int userId, String newToken) async {
    final db = await database;
    await db.update(
      'users',
      {'token': newToken}, // Update hanya token
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}
