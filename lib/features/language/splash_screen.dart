import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_constants.dart';
import '../../core/storage/storage_service.dart';
import '../../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _textFade;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _logoFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.72, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutBack),
      ),
    );
    _textFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 1.0, curve: Curves.easeOut),
    );
    _controller.forward();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    try {
      await Future.delayed(const Duration(milliseconds: 2600));
      if (!mounted) return;
      final storage = StorageServiceScope.of(context);
      final route = storage.hasLanguage ? '/home' : '/language';
      await Navigator.of(context).pushReplacementNamed(route);
    } catch (e, st) {
      debugPrint('Splash navigation failed: $e\n$st');
      if (!mounted) return;
      await Navigator.of(context).pushReplacementNamed('/language');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 3),
            Center(
              child: FadeTransition(
                opacity: _logoFade,
                child: ScaleTransition(
                  scale: _logoScale,
                  child: Image.asset(
                    AppAssets.logo,
                    height: 110,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FadeTransition(
              opacity: _textFade,
              child: Text(
                AppConstants.appSubtitle,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                  color: const Color(0xFF888888),
                  letterSpacing: 0.1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(flex: 2),
            FadeTransition(
              opacity: _textFade,
              child: const _LoadingDots(),
            ),
            const SizedBox(height: AppSpacing.lg),
            FadeTransition(
              opacity: _textFade,
              child: Container(
                width: double.infinity,
                color: const Color(0xFFFFFFFF),
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AppAssets.espochLogoSplash, height: 72, fit: BoxFit.contain),
                    const SizedBox(width: 32),
                    Image.asset(AppAssets.espochLogoFull, height: 72, fit: BoxFit.contain),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots> with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 3; i++) {
      final ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 650),
      );
      _controllers.add(ctrl);
      Future.delayed(Duration(milliseconds: i * 180), () {
        if (mounted) ctrl.repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.2, end: 1.0).animate(_controllers[i]),
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.6, end: 1.0).animate(
                CurvedAnimation(parent: _controllers[i], curve: Curves.easeInOut),
              ),
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF97BF06),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class StorageServiceScope extends InheritedWidget {
  const StorageServiceScope({
    super.key,
    required this.storage,
    required super.child,
  });

  final StorageService storage;

  static StorageService of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<StorageServiceScope>();
    assert(scope != null, 'StorageServiceScope not found');
    return scope!.storage;
  }

  @override
  bool updateShouldNotify(StorageServiceScope oldWidget) =>
      storage != oldWidget.storage;
}
