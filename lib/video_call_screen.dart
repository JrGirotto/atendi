import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../helpers/db_helper.dart';

class VideoCallScreen extends StatefulWidget {
  final String qrData;

  const VideoCallScreen({super.key, required this.qrData});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
      );

      await _cameraController?.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }

      _capturePhoto();
    } catch (e) {
      print('Erro ao inicializar a câmera: $e');
    }
  }

  Future<void> _capturePhoto() async {
    try {
      final image = await _cameraController?.takePicture();
      if (image != null) {
        final timestamp = DateTime.now().toString();
        await DBHelper.instance.insertLog(timestamp, image.path);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Foto capturada e log salvo!')),
          );
        }
      }
    } catch (e) {
      print('Erro ao capturar foto: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chamada de Vídeo')),
      body: _isCameraInitialized && _cameraController != null
          ? Stack(
              children: [
                CameraPreview(_cameraController!),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Finalizar Chamada'),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
