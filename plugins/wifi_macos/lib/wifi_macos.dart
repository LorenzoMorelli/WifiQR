import 'wifi_macos_platform_interface.dart';

class WifiMacos {
  Future<String?> getPlatformVersion() {
    return WifiMacosPlatform.instance.getPlatformVersion();
  }

  Future<String?> connectTo({String? ssid, String? password}) {
    return WifiMacosPlatform.instance.connectTo(ssid: ssid, password: password);
  }
}
