import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/localization/tr.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_constants.dart';
import '../../core/localization/locale_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/framer/framer_buttons.dart';
import 'splash_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key, this.fromSettings = false});

  final bool fromSettings;

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedCode;
  late final AnimationController _entry;

  @override
  void initState() {
    super.initState();
    _entry = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))
      ..forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final saved = StorageServiceScope.of(context).getLanguage();
      if (saved != null && mounted) setState(() => _selectedCode = saved);
    });
  }

  @override
  void dispose() {
    _entry.dispose();
    super.dispose();
  }

  bool get _previewKichwa => _selectedCode == AppConstants.langKichwa;

  Future<void> _onContinue() async {
    if (_selectedCode == null) return;
    HapticFeedback.mediumImpact();
    final storage = StorageServiceScope.of(context);
    await LocaleControllerScope.of(context).updateLanguage(_selectedCode!);
    if (!widget.fromSettings) await storage.recordAppOpen();
    if (!mounted) return;
    if (widget.fromSettings) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final top = MediaQuery.paddingOf(context).top;
    final canContinue = _selectedCode != null;

    return Scaffold(
      backgroundColor: p.canvas,
      body: FadeTransition(
        opacity: CurvedAnimation(parent: _entry, curve: Curves.easeOut),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.fromSettings) ...[
                  const SizedBox(height: AppSpacing.md),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FramerIconButton(
                      icon: Icons.close_rounded,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ] else
                  SizedBox(height: top > 0 ? 0 : AppSpacing.lg),

                const SizedBox(height: AppSpacing.lg),

                // Logo branding
                Center(
                  child: Image.asset(
                    AppAssets.brandingLogo,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Headline grande
                Text(
                  _previewKichwa
                      ? Tr.languageSelectionTitleQu
                      : 'Elige tu\nidioma',
                  style: AppTypography.displayLg(p),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  Tr.languageSelectionSubtitle(_previewKichwa),
                  style: AppTypography.bodySm(p, color: p.inkMuted),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Language options — color blocks grandes
                _LangBlock(
                  label: Tr.languageSelectionSpanishEs,
                  sublabel: Tr.greetingsWellbeingStartsTodayEs,
                  tag: 'ES',
                  blockColor: p.blockMint,
                  blockTextColor: p.blockMintText,
                  selected: _selectedCode == AppConstants.langSpanish,
                  onTap: () => setState(() => _selectedCode = AppConstants.langSpanish),
                ),
                const SizedBox(height: AppSpacing.md),
                _LangBlock(
                  label: Tr.languageSelectionKichwaEs,
                  sublabel: Tr.greetingsWellbeingStartsTodayQu,
                  tag: 'QU',
                  blockColor: p.blockLilac,
                  blockTextColor: p.blockLilacText,
                  selected: _selectedCode == AppConstants.langKichwa,
                  onTap: () => setState(() => _selectedCode = AppConstants.langKichwa),
                ),

                const SizedBox(height: AppSpacing.xl),

                FramerPrimaryButton(
                  label: _previewKichwa
                      ? '${Tr.languageSelectionContinueSpanishQu} →'
                      : 'Continuar →',
                  enabled: canContinue,
                  onPressed: _onContinue,
                ),

                const SizedBox(height: AppSpacing.md),

                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LangBlock extends StatelessWidget {
  const _LangBlock({
    required this.label,
    required this.sublabel,
    required this.tag,
    required this.blockColor,
    required this.blockTextColor,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String sublabel;
  final String tag;
  final Color blockColor;
  final Color blockTextColor;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: selected ? blockColor : p.surface2,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: selected ? Colors.transparent : p.hairline,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Tag circular
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: selected ? blockTextColor.withValues(alpha: 0.15) : p.hairline,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  tag,
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: selected ? blockTextColor : p.inkMuted,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.cardTitle(
                      p,
                      color: selected ? blockTextColor : p.ink,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    sublabel,
                    style: AppTypography.bodySm(
                      p,
                      color: selected
                          ? blockTextColor.withValues(alpha: 0.7)
                          : p.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_circle_rounded, color: blockTextColor, size: 20),
          ],
        ),
      ),
    );
  }
}
