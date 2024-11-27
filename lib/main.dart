import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/scan_qr_code_screen.dart';
import 'screens/generate_qr_code_screen.dart';
import 'screens/history_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Interfone Digital',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/generate': (context) => const GenerateQRCodeScreen(),
        '/scan': (context) => const ScanQRCodeScreen(),
        '/history': (context) => const HistoryScreen(),
      },
    );
  }
}
