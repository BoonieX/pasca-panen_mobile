import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:pascapanen_mobile/model/user_model.dart';

class DbHelper {
  static Database? _database;

  // Menginisialisasi database
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      // Inisialisasi database jika belum ada
      _database = await _initDatabase();
      return _database!;
    }
  }

  // Membuat dan membuka database
  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'users.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Membuat tabel User jika belum ada
        await db.execute('''
          CREATE TABLE user(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            namaLengkap TEXT,
            username TEXT UNIQUE,
            gender TEXT,
            email TEXT,
            noTelp TEXT,
            alamat TEXT,
            password TEXT
          )
        ''');
      },
    );
  }

  // Menambahkan user baru ke database
  Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Mengambil semua user dari database
  Future<List<UserModel>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user');
    
    return List.generate(maps.length, (i) {
      return UserModel.fromMap(maps[i]);
    });
  }

  // Mengambil user berdasarkan username dan password
  Future<UserModel?> getUserByUsernameAndPassword(String username, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    
    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Mengambil user berdasarkan email dan password
  Future<UserModel?> getUserByEmailAndPassword(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    
    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Mengupdate user berdasarkan username
  Future<int> updateUser(UserModel user) async {
    final db = await database;
    return await db.update(
      'user',
      user.toMap(),
      where: 'username = ?',
      whereArgs: [user.username],
    );
  }

  // Menghapus user berdasarkan username
  Future<int> deleteUser(String username) async {
    final db = await database;
    return await db.delete(
      'user',
      where: 'username = ?',
      whereArgs: [username],
    );
  }

  Future<bool> isUsernameExists(String username) async {
    final db = await database;
    final result = await db.query(
      'user',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
  }

  Future<bool> isEmailExists(String email) async {
    final db = await database;
    final result = await db.query(
      'user',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }
}
