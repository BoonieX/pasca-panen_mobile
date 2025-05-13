import 'package:flutter/material.dart';
import 'package:pascapanen_mobile/pages/Main/home_screen.dart';
import 'package:pascapanen_mobile/pages/main_screen.dart';
import 'pages/splash/splash_screen1.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: const MainScreen(),
    );
  }
}
