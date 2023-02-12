import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_macos/wifi_macos.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _wifiMacosPlugin = WifiMacos();

  String? _ssid;
  String? _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              child: const Text('Scan Barcode'),
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AiBarcodeScanner(
                      onScan: (String value) {
                        debugPrint(value);
                        final ssid = value.substring(
                            value.indexOf("WIFI:S:") + 7, value.indexOf(";T"));
                        final password = value.substring(
                            value.indexOf(";P:") + 3, value.indexOf(";H"));

                        setState(() {
                          _ssid = ssid;
                          _password = password;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
            const Divider(),
            _ssid != null && _password != null
                ? Column(mainAxisSize: MainAxisSize.min, children: [
                    const SizedBox(
                      height: 8,
                    ),
                    SelectableText(
                      "SSID: $_ssid",
                      onTap: () async {
                        await Clipboard.setData(ClipboardData(text: _ssid));
                        // copied successfully
                        const snackBar = SnackBar(
                          content: Text('SSID Copied'),
                          duration: Duration(milliseconds: 800),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SelectableText(
                      "Password: $_password",
                      onTap: () async {
                        await Clipboard.setData(ClipboardData(text: _ssid));
                        // copied successfully
                        const snackBar = SnackBar(
                          content: Text('Password Copied'),
                          duration: Duration(milliseconds: 800),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ElevatedButton(
                        child: Text('Connect to $_ssid...'),
                        onPressed: () {
                          _showConnectToWifiDialog(_ssid!, _password!);
                        })
                  ])
                : const Text("Tap to scan")
          ],
        ),
      ),
    );
  }

  void _showConnectToWifiDialog(String ssid, String password) async {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text('Wifi: $ssid'),
        content: const Text('Do you want to connect to this wifi network?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(context);
              await _wifiMacosPlugin.connectTo(ssid: ssid, password: password);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
