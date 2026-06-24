import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/localization/tr.dart';
import '../../core/theme/app_theme.dart';
import '../../features/language/splash_screen.dart';
import '../../shared/widgets/framer/framer_buttons.dart';

class TeacherProfileScreen extends StatefulWidget {
  const TeacherProfileScreen({super.key, this.fromSettings = false});

  final bool fromSettings;

  @override
  State<TeacherProfileScreen> createState() => _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends State<TeacherProfileScreen> {
  late final TextEditingController _nameCtrl;
  String? _selectedEmoji;

  static const _emojis = [
    '🌟', '🌺', '🌈', '🦋',
    '🌻', '🌿', '☀️', '🎨',
    '📚', '🧘', '💫', '🌙',
    '🏔️', '🌊', '🎵', '🌱',
  ];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final s = StorageServiceScope.of(context);
      final savedName = s.getProfileName();
      final savedEmoji = s.getProfileAvatar();
      if (savedName != null) _nameCtrl.text = savedName;
      if (savedEmoji != null) setState(() => _selectedEmoji = savedEmoji);
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    final emoji = _selectedEmoji ?? _emojis.first;
    final s = StorageServiceScope.of(context);
    await s.setProfileName(name);
    await s.setProfileAvatar(emoji);
    await s.setProfileCompleted(true);
    if (!mounted) return;
    if (widget.fromSettings) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final isKichwa = l10n.isKichwa;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: p.canvas,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.md,
                AppSpacing.screen,
                AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.fromSettings) ...[
                    FramerIconButton(
                      icon: Icons.close_rounded,
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  Text(
                    Tr.profileTeacher(isKichwa).toUpperCase(),
                    style: AppTypography.eyebrow(p),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    Tr.profileTeacherProfile(isKichwa),
                    style: AppTypography.displayMd(p),
                  ),
                ],
              ),
            ),

            // ── Scrollable body ──────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  0,
                  AppSpacing.screen,
                  AppSpacing.xxl + bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name field
                    Text(
                      Tr.profileName(isKichwa).toUpperCase(),
                      style: AppTypography.eyebrow(p),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _NameField(
                      controller: _nameCtrl,
                      placeholder: Tr.profileNamePlaceholder(isKichwa),
                      p: p,
                      onSubmit: _save,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Emoji section
                    Text(
                      Tr.profileChooseAvatar(isKichwa).toUpperCase(),
                      style: AppTypography.eyebrow(p),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _EmojiGrid(
                      emojis: _emojis,
                      selected: _selectedEmoji,
                      p: p,
                      onSelect: (e) => setState(() => _selectedEmoji = e),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Save button
                    FramerPrimaryButton(
                      label: Tr.profileSaveProfile(isKichwa),
                      onPressed: _save,
                    ),

                    if (widget.fromSettings) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.sm,
                              horizontal: AppSpacing.lg,
                            ),
                            child: Text(
                              Tr.profileCancel(isKichwa),
                              style: AppTypography.body(p, color: p.inkMuted),
                            ),
                          ),
                        ),
                      ),
                    ],
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

// ── Name field ────────────────────────────────────────────────────────────────

class _NameField extends StatelessWidget {
  const _NameField({
    required this.controller,
    required this.placeholder,
    required this.p,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final String placeholder;
  final AppPalette p;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textCapitalization: TextCapitalization.words,
      style: AppTypography.body(p),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: AppTypography.body(p, color: p.inkMuted),
        filled: true,
        fillColor: p.surface2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: p.hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: p.hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: p.ink, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      ),
      onSubmitted: (_) => onSubmit(),
    );
  }
}

// ── Emoji grid ────────────────────────────────────────────────────────────────

class _EmojiGrid extends StatelessWidget {
  const _EmojiGrid({
    required this.emojis,
    required this.selected,
    required this.p,
    required this.onSelect,
  });

  final List<String> emojis;
  final String? selected;
  final AppPalette p;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: emojis.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
        childAspectRatio: 1,
      ),
      itemBuilder: (_, i) {
        final emoji = emojis[i];
        final isSelected = selected == emoji;
        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            onSelect(emoji);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: isSelected ? p.blockMint : p.surface2,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                color: isSelected ? p.blockMintText : p.hairline,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 30)),
            ),
          ),
        );
      },
    );
  }
}

// ── Emoji avatar circle (used in home screen and settings) ────────────────────

class ProfileAvatarCircle extends StatelessWidget {
  const ProfileAvatarCircle({super.key, required this.emoji, this.size = 40});

  final String emoji;
  final double size;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: p.surface2,
        border: Border.all(color: p.hairline, width: 1.5),
      ),
      child: Center(
        child: Text(
          emoji,
          style: TextStyle(fontSize: size * 0.52),
        ),
      ),
    );
  }
}
