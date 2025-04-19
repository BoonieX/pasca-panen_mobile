import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:pascapanen_mobile/register/login_page.dart';
import 'package:pascapanen_mobile/register/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi sqflite untuk desktop
  if (!kIsWeb) {
    // Inisialisasi FFI
    sqfliteFfiInit();
    // Set factory global
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pascapanen App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),  // Perbaiki disini
        ),
      ),
      // Mulai aplikasi dengan RegisterPage
      home: const RegisterPage(),
    );
  }
}
