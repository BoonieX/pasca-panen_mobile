import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pascapanen_mobile/database/db_helper.dart';
import 'package:pascapanen_mobile/model/user_model.dart';
import 'package:pascapanen_mobile/register/register_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Inisialisasi Hive dengan support Flutter
  Hive.registerAdapter(UserModelAdapter()); // Daftarkan Adapter
  await Hive.openBox<UserModel>('users'); // Buka box Hive
  await DbHelper.instance.initHive(); // Kalau kamu pakai initHive() tambahan
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
      home: const RegisterPage(),
    );
  }
}
