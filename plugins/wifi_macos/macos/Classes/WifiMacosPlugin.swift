import Foundation
import CoreWLAN
import AVFoundation

import Cocoa
import FlutterMacOS

public class WifiMacosPlugin: NSObject, FlutterPlugin {
  let interface: CWInterface

  override init() {
    let client = CWWiFiClient.shared()
    self.interface = client.interface()!
    super.init()
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "wifi_macos", binaryMessenger: registrar.messenger)
    let instance = WifiMacosPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
    case "connectTo":
      let args = call.arguments as? Dictionary<String, Any> ?? [:]
      let ssid = args["ssid"] as? String
      let password = args["password"] as? String

      // scan for all networks
      let networks = try! self.interface.scanForNetworks(withSSID: nil)
      if networks.contains(where: {$0.ssid == ssid}) {
        do {
          let targetNetwork = networks.first(where: {$0.ssid == ssid})
          try self.interface.associate(to: targetNetwork!, password: password)
          // print("Connected to the \(ssid) network")
          
          result("Connected to the \(ssid as String?) network")
        } catch {
          // print("Error while connecting")
          result("Error while connecting")
        }
      } else {
        // print("Network \(ssid) not found")
        result("Network \(ssid as String?) not found")
      }
      
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  //
//  main.swift
//  wifi_utils
//
//  Created by Lorenzo Morelli on 22/01/23.
//
}
