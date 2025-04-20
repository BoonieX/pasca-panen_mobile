import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pascapanen_mobile/database/db_helper.dart';
import 'package:pascapanen_mobile/model/user_model.dart';
import 'package:pascapanen_mobile/register/login_page.dart'; // ganti sesuai path-mu 'package_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("1. WidgetsFlutterBinding initialized");

  await Hive.initFlutter();
  print("2. Hive initialized");

  if (!Hive.isAdapterRegistered(UserModelAdapter().typeId)) {
    Hive.registerAdapter(UserModelAdapter());
    print("3. UserModelAdapter registered");
  } else {
    print("3. Adapter already registered");
  }

  await Hive.openBox<UserModel>('users');
  print("4. Box 'users' opened");

  runApp(const MyApp());
  print("5. App started");
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
      home: const LoginPage(),
    );
  }
}
