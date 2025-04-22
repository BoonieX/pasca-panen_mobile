import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // untuk kIsWeb
import 'pages/splash_screen1.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    print("Running on Mobile/Desktop, DB init di-skip (nggak pakai SQLite sekarang)");
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
