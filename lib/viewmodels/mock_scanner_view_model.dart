import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/meter.dart';

enum ScannerState {
  ready,
  scanning,
  recognized,
}

class MockScannerViewModel extends ChangeNotifier {
  ScannerState _state = ScannerState.ready;

  ScannerState get state => _state;

  ResourceType _resourceType =
      ResourceType.water;

  ResourceType get resourceType => _resourceType;

  double? _recognizedValue;

  double? get recognizedValue =>
      _recognizedValue;

  String get recognizedText {
    if (_recognizedValue == null) {
      return '';
    }

    return _recognizedValue!
        .toStringAsFixed(2);
  }

  void setResourceType(ResourceType type) {
    _resourceType = type;
    notifyListeners();
  }

  Future<void> scanMeter() async {
    _state = ScannerState.scanning;
    _recognizedValue = null;

    notifyListeners();

    // Имитация работы камеры и OCR.
    await Future.delayed(
      const Duration(seconds: 2),
    );

    switch (_resourceType) {
      case ResourceType.water:
        _recognizedValue = 128.45;
        break;

      case ResourceType.gas:
        _recognizedValue = 542.80;
        break;

      case ResourceType.electricity:
        _recognizedValue = 3842.60;
        break;
    }

    _state = ScannerState.recognized;

    notifyListeners();
  }

  void reset() {
    _state = ScannerState.ready;
    _recognizedValue = null;

    notifyListeners();
  }
}