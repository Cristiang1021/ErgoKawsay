import 'package:flutter/material.dart';

import '../storage/storage_service.dart';

class ThemeController extends ChangeNotifier {
  ThemeController(this._storage);

  final StorageService _storage;

  ThemeMode get themeMode => _storage.getThemeMode();

  Future<void> setThemeMode(ThemeMode mode) async {
    await _storage.setThemeMode(mode);
    notifyListeners();
  }
}

class ThemeControllerScope extends InheritedWidget {
  const ThemeControllerScope({
    super.key,
    required this.controller,
    required super.child,
  });

  final ThemeController controller;

  static ThemeController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ThemeControllerScope>();
    assert(scope != null, 'ThemeControllerScope not found');
    return scope!.controller;
  }

  @override
  bool updateShouldNotify(ThemeControllerScope oldWidget) =>
      controller != oldWidget.controller;
}
