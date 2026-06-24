import 'package:flutter/material.dart';

import '../storage/storage_service.dart';

class LocaleController extends ChangeNotifier {
  LocaleController(this._storage);

  final StorageService _storage;

  Locale get locale => Locale(_storage.getLanguage() ?? 'es');

  Future<void> updateLanguage(String code) async {
    await _storage.setLanguage(code);
    notifyListeners();
  }
}

class LocaleControllerScope extends InheritedWidget {
  const LocaleControllerScope({
    super.key,
    required this.controller,
    required super.child,
  });

  final LocaleController controller;

  static LocaleController of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<LocaleControllerScope>();
    assert(scope != null, 'LocaleControllerScope not found');
    return scope!.controller;
  }

  @override
  bool updateShouldNotify(LocaleControllerScope oldWidget) =>
      controller != oldWidget.controller;
}
