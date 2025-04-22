import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // untuk kIsWeb
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'database_initializer_stub.dart'
    if (dart.library.io) 'database_initializer_io.dart';

import 'pages/splash_screen1.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDatabase();

  if (!kIsWeb) {
    final databasePath = await getDatabasesPath();
    final String path = join(databasePath, 'pascapanen.db');

    final Database db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nama TEXT,
          username TEXT,
          email TEXT,
          telepon TEXT,
          alamat TEXT,
          gender TEXT,
          password TEXT
        )''');
      },
    );
  } else {
    print("Running on Web: SQLite not supported, skipping DB init");
  }

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pascapanen',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const SplashScreen1(),
    );
  }
}
