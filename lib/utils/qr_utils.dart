import 'package:uuid/uuid.dart';

class QRUtils {
  static String generateDeviceQRCode() {
    const uuid = Uuid();
    return "https://meet.jit.si/${uuid.v4()}";
  }
}
