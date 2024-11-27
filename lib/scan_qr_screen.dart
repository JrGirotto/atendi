import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'video_call_screen.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({super.key});

  @override
  State<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool isTorchOn = false; // Controle manual do estado do flash

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digitalizar QR Code'),
        actions: [
          IconButton(
            icon: Icon(isTorchOn ? Icons.flash_on : Icons.flash_off),
            onPressed: () {
              setState(() {
                isTorchOn = !isTorchOn;
              });
              _controller.toggleTorch();
            },
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_android),
            onPressed: () {
              _controller.switchCamera();
            },
          ),
        ],
      ),
      body: MobileScanner(
        controller: _controller,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;

          for (final barcode in barcodes) {
            final String? qrCodeData = barcode.rawValue;

            if (qrCodeData != null) {
              // Navegar para a tela de vídeo ao detectar o QR Code
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoCallScreen(qrData: qrCodeData),
                ),
              );
              break; // Para evitar múltiplas navegações
            } else {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('QR Code inválido!')),
                );
              }
            }
          }
        },
      ),
    );
  }
}
