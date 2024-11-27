import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../utils/qr_utils.dart';

class GenerateQRCodeScreen extends StatelessWidget {
  const GenerateQRCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceQRCode = QRUtils.generateDeviceQRCode();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerar QR Code'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Escaneie este QR Code para acessar o dispositivo',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            QrImageView(
              data: deviceQRCode,
              version: QrVersions.auto,
              size: 200.0,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 20),
            Text(
              'Link: $deviceQRCode',
              style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
