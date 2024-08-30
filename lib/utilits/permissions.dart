import 'package:permission_handler/permission_handler.dart';


Future<void> checkCameraPermission() async {
  var status = await Permission.camera.status;
  if (!status.isGranted) {
    await Permission.camera.request();
  }
}