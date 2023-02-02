import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'wifi_macos_method_channel.dart';

abstract class WifiMacosPlatform extends PlatformInterface {
  /// Constructs a WifiMacosPlatform.
  WifiMacosPlatform() : super(token: _token);

  static final Object _token = Object();

  static WifiMacosPlatform _instance = MethodChannelWifiMacos();

  /// The default instance of [WifiMacosPlatform] to use.
  ///
  /// Defaults to [MethodChannelWifiMacos].
  static WifiMacosPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [WifiMacosPlatform] when
  /// they register themselves.
  static set instance(WifiMacosPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> connectTo({String? ssid, String? password}) {
    throw UnimplementedError('coonectTo() has not been implemented.');
  }
}
