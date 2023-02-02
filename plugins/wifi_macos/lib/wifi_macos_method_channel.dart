import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'wifi_macos_platform_interface.dart';

/// An implementation of [WifiMacosPlatform] that uses method channels.
class MethodChannelWifiMacos extends WifiMacosPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('wifi_macos');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> connectTo({String? ssid, String? password}) async {
    final version = await methodChannel.invokeMethod<String>('connectTo', {
      'ssid': ssid,
      'password': password,
    });
    return version;
  }
}
