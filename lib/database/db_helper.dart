import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/user_model.dart';


class DbHelper {
  static final DbHelper instance = DbHelper._init();
  static Database? _database;

  DbHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pascapanen.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE petani (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama_lengkap TEXT NOT NULL,
        username TEXT NOT NULL UNIQUE,
        email TEXT NOT NULL UNIQUE,
        no_telp TEXT NOT NULL,
        alamat TEXT NOT NULL,
        gender TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');
  }

  // Insert data petani
  Future<int> insertPetani(UserModel user) async {
    final db = await instance.database;
    return await db.insert('petani', user.toMap());
  }

  // Cek apakah username sudah digunakan
  Future<bool> isUsernameExists(String username) async {
    final db = await instance.database;
    final result = await db.query(
      'petani',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
  }

  // Cek apakah email sudah digunakan
  Future<bool> isEmailExists(String email) async {
    final db = await instance.database;
    final result = await db.query(
      'petani',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  // Ambil data petani berdasarkan username dan password
  Future<UserModel?> getPetani(String username, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'petani',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    } else {
      return null;
    }
  }

  // Ambil semua data petani
  Future<List<UserModel>> getAllPetani() async {
    final db = await instance.database;
    final result = await db.query('petani');
    return result.map((e) => UserModel.fromMap(e)).toList();
  }

  // Hapus semua data petani (opsional, untuk reset/debug)
  Future<void> deleteAllPetani() async {
    final db = await instance.database;
    await db.delete('petani');
  }

  // Tutup database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
