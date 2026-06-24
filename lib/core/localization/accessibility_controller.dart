import 'package:flutter/material.dart';

import '../storage/storage_service.dart';
import '../../data/models/accessibility_settings.dart';

class AccessibilityController extends ChangeNotifier {
  AccessibilityController(this._storage);

  final StorageService _storage;

  AccessibilitySettings get settings => _storage.getAccessibilitySettings();

  Future<void> updateSettings(AccessibilitySettings s) async {
    await _storage.saveAccessibilitySettings(s);
    notifyListeners();
  }
}

class AccessibilityControllerScope extends InheritedWidget {
  const AccessibilityControllerScope({
    super.key,
    required this.controller,
    required super.child,
  });

  final AccessibilityController controller;

  static AccessibilityController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<AccessibilityControllerScope>();
    assert(scope != null, 'AccessibilityControllerScope not found');
    return scope!.controller;
  }

  @override
  bool updateShouldNotify(AccessibilityControllerScope oldWidget) =>
      controller != oldWidget.controller;
}
