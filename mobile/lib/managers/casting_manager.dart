import 'package:flutter/material.dart';

class CastingManager extends ChangeNotifier {
  bool _isScanning = false;
  final List<String> _devices = []; // Mock device list for now
  String? _connectedDevice;

  bool get isScanning => _isScanning;
  List<String> get devices => _devices;
  String? get connectedDevice => _connectedDevice;

  void startScanning() async {
    _isScanning = true;
    notifyListeners();

    // Simulate scanning delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock devices found
    _devices.clear();
    _devices.add("Living Room TV (Chromecast)");
    _devices.add("Bedroom TV (AirPlay)");
    
    _isScanning = false;
    notifyListeners();
  }

  void connectToDevice(String deviceName) async {
    // Simulate connection
    _connectedDevice = deviceName;
    notifyListeners();
  }

  void disconnect() {
    _connectedDevice = null;
    notifyListeners();
  }
}
