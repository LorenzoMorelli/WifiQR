import 'package:flutter_test/flutter_test.dart';
import 'package:wifi_macos/wifi_macos.dart';
import 'package:wifi_macos/wifi_macos_platform_interface.dart';
import 'package:wifi_macos/wifi_macos_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockWifiMacosPlatform
    with MockPlatformInterfaceMixin
    implements WifiMacosPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> connectTo({String? ssid, String? password}) {
    // TODO: implement connectTo
    throw UnimplementedError();
  }
}

void main() {
  final WifiMacosPlatform initialPlatform = WifiMacosPlatform.instance;

  test('$MethodChannelWifiMacos is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelWifiMacos>());
  });

  test('getPlatformVersion', () async {
    WifiMacos wifiMacosPlugin = WifiMacos();
    MockWifiMacosPlatform fakePlatform = MockWifiMacosPlatform();
    WifiMacosPlatform.instance = fakePlatform;

    expect(await wifiMacosPlugin.getPlatformVersion(), '42');
  });
}
