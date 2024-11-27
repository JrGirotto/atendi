import 'package:atendi/scan_qr_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atendi',
      theme: ThemeData(primarySwatch: Colors.grey),
      home: const ScanQRScreen(),
    );
  }
}
