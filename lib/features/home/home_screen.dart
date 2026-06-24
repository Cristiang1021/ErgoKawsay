import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_assets.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/localization/tr.dart';
import '../../core/theme/app_theme.dart';
import '../../data/local/local_data_repository.dart';
import '../../features/exercises/exercise_session_screen.dart';
import '../../features/language/language_selection_screen.dart';
import '../../features/language/splash_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/wellbeing/wellbeing_screen.dart';
import '../../features/music/audio_controller.dart';
import '../../shared/widgets/app_bottom_nav.dart';
import '../../shared/widgets/framer/framer_buttons.dart';
import '../../shared/widgets/mini_audio_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StorageServiceScope.of(context).recordAppOpen();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;

    return Scaffold(
      backgroundColor: p.canvas,
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _navIndex,
              children: const [
                _HomeContent(),
                WellbeingScreen(),
                SettingsScreen(embedded: true),
              ],
            ),
          ),
          // Mini audio player — shows above bottom nav when audio is active
          ListenableBuilder(
            listenable: AudioController.instance,
            builder: (ctx, _) {
              final ctrl = AudioController.instance;
              if (!ctrl.hasActiveTrack) return const SizedBox.shrink();
              return MiniAudioPlayer(ctrl: ctrl);
            },
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _navIndex,
        labels: [l10n.home, l10n.wellbeing, l10n.settings],
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }
}

// ─── Home Content ──────────────────────────────────────────────────────────

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final repo = LocalDataRepository.instance;
    final isKichwa = l10n.isKichwa;
    final exercise = repo.exerciseOfDay();
    final tip = repo.tipOfDay();

    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(child: _HomeHero()),
        SliverToBoxAdapter(
          child: _buildDailyActionBlock(context, p, l10n, isKichwa, exercise),
        ),
        SliverToBoxAdapter(
          child: _buildMoodCard(context, p, isKichwa),
        ),
        SliverToBoxAdapter(
          child: _buildBodySection(context, p, isKichwa),
        ),
        SliverToBoxAdapter(
          child: _buildMindSection(context, p, isKichwa),
        ),
        SliverToBoxAdapter(
          child: _buildTipCard(context, p, isKichwa, tip),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
      ],
    );
  }


  // ── Daily Action Block ────────────────────────────────────────────────────

  Widget _buildDailyActionBlock(
    BuildContext context,
    AppPalette p,
    AppLocalizations l10n,
    bool isKichwa,
    dynamic exercise,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ExerciseSessionScreen(exercise: exercise),
          ),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: p.blockMint,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Tr.homeDailyAction(isKichwa).toUpperCase(),
                style: AppTypography.eyebrow(p, color: p.blockMintText.withValues(alpha: 0.7)),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                exercise.name(isKichwa),
                style: AppTypography.cardTitle(p, color: p.blockMintText),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                exercise.description(isKichwa),
                style: AppTypography.bodySm(
                  p,
                  color: p.blockMintText.withValues(alpha: 0.75),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: p.blockMintText.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                    ),
                    child: Text(
                      '${exercise.durationSeconds}s',
                      style: AppTypography.caption(p, color: p.blockMintText),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: p.blockMintText,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                    ),
                    child: Text(
                      '${l10n.start} →',
                      style: AppTypography.button(p, color: p.blockMint).copyWith(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Mood Card (sin emojis) ────────────────────────────────────────────────

  Widget _buildMoodCard(BuildContext context, AppPalette p, bool isKichwa) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.xl,
        AppSpacing.screen,
        0,
      ),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          Navigator.pushNamed(context, '/emotions');
        },
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: p.blockLilac,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (isKichwa
                              ? Tr.mentalHealthTapEmotionQu
                              : '¿CÓMO TE SIENTES?')
                          .toUpperCase(),
                      style: AppTypography.eyebrow(
                        p,
                        color: p.blockLilacText.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      isKichwa
                          ? Tr.mentalHealthRecognizeCareTitleQu
                          : 'Registra tu estado emocional',
                      style: AppTypography.cardTitle(p, color: p.blockLilacText),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${Tr.homeExploreEmotions(isKichwa)} →',
                      style: AppTypography.bodySm(
                        p,
                        color: p.blockLilacText.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Icon(
                Icons.favorite_border_rounded,
                color: p.blockLilacText.withValues(alpha: 0.5),
                size: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Bienestar Físico ──────────────────────────────────────────────────────

  Widget _buildBodySection(BuildContext context, AppPalette p, bool isKichwa) {
    final items = [
      _SectionItem(
        label: Tr.modulesErgonomics(isKichwa),
        sublabel: Tr.ergonomicsPrinciplesTitle(isKichwa),
        icon: Icons.chair_alt_outlined,
        bg: p.blockCream,
        fg: p.blockCreamText,
        route: '/ergonomics',
      ),
      _SectionItem(
        label: isKichwa ? Tr.diseasesTitleQu : 'Enfermedades',
        sublabel: Tr.diseasesMusculoskeletalTitle(isKichwa),
        icon: Icons.medical_information_outlined,
        bg: p.blockCoral,
        fg: p.blockCoralText,
        route: '/diseases',
      ),
      _SectionItem(
        label: Tr.activeBreaksTitle(isKichwa),
        sublabel: Tr.activeBreaksSubtitle(isKichwa),
        icon: Icons.self_improvement_rounded,
        bg: p.blockMint,
        fg: p.blockMintText,
        route: '/active-breaks',
      ),
      _SectionItem(
        label: Tr.exercisesTitle(isKichwa),
        sublabel: Tr.exercisesNeckTitle(isKichwa),
        icon: Icons.fitness_center_rounded,
        bg: p.blockLime,
        fg: p.blockLimeText,
        route: '/exercises',
      ),
    ];

    return _HorizontalSection(
      eyebrow: Tr.vocabularyPhysicalWellbeing(isKichwa).toUpperCase(),
      p: p,
      items: items,
    );
  }

  // ── Bienestar Mental ──────────────────────────────────────────────────────

  Widget _buildMindSection(BuildContext context, AppPalette p, bool isKichwa) {
    final items = [
      _SectionItem(
        label: isKichwa ? Tr.mentalHealthTitleQu : 'Salud Mental',
        sublabel: Tr.mentalHealthRecognizeCareTitle(isKichwa),
        icon: Icons.favorite_border_rounded,
        bg: p.blockPink,
        fg: p.blockPinkText,
        route: '/emotions',
      ),
      _SectionItem(
        label: Tr.mediaMusicTitle(isKichwa),
        sublabel: Tr.mediaPlaylistTitle(isKichwa),
        icon: Icons.music_note_rounded,
        bg: p.blockLilac,
        fg: p.blockLilacText,
        route: '/music',
      ),
      _SectionItem(
        label: Tr.tipsTitle(isKichwa),
        sublabel: Tr.tipsPreventiveTitle(isKichwa),
        icon: Icons.lightbulb_outline_rounded,
        bg: p.blockCream,
        fg: p.blockCreamText,
        route: '/tips',
      ),
      _SectionItem(
        label: Tr.mediaVideosTitle(isKichwa),
        sublabel: Tr.mediaVideosTitle(isKichwa),
        icon: Icons.play_circle_outline_rounded,
        bg: p.blockLime,
        fg: p.blockLimeText,
        route: '/videos',
      ),
    ];

    return _HorizontalSection(
      eyebrow: Tr.mentalHealthTitle(isKichwa),
      p: p,
      items: items,
    );
  }

  // ── Tip Card ──────────────────────────────────────────────────────────────

  Widget _buildTipCard(
    BuildContext context,
    AppPalette p,
    bool isKichwa,
    dynamic tip,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.xl,
        AppSpacing.screen,
        0,
      ),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/tips'),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: p.blockCream,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: p.blockCreamText.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.lightbulb_outline_rounded,
                        color: p.blockCreamText, size: 18),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    (isKichwa ? 'KUNAYKUNA' : 'CONSEJO DEL DÍA')
                        .toUpperCase(),
                    style: AppTypography.eyebrow(
                        p, color: p.blockCreamText.withValues(alpha: 0.55)),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                tip.title(isKichwa),
                style: AppTypography.body(p, color: p.blockCreamText)
                    .copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                tip.content(isKichwa),
                style: AppTypography.bodySm(
                  p,
                  color: p.blockCreamText.withValues(alpha: 0.75),
                ).copyWith(height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Horizontal Section ─────────────────────────────────────────────────────

class _HorizontalSection extends StatelessWidget {
  const _HorizontalSection({
    required this.eyebrow,
    required this.p,
    required this.items,
  });

  final String eyebrow;
  final AppPalette p;
  final List<_SectionItem> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, AppSpacing.xl, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            child: Text(
              eyebrow.toUpperCase(),
              style: AppTypography.eyebrow(p),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 148,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
              itemBuilder: (context, i) => _SectionCard(item: items[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionItem {
  const _SectionItem({
    required this.label,
    required this.sublabel,
    required this.icon,
    required this.bg,
    required this.fg,
    required this.route,
  });

  final String label;
  final String sublabel;
  final IconData icon;
  final Color bg;
  final Color fg;
  final String route;
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.item});
  final _SectionItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.pushNamed(context, item.route);
      },
      child: Container(
        width: 152,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: item.bg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(item.icon, color: item.fg, size: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: item.fg,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  item.sublabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: item.fg.withValues(alpha: 0.7),
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Home Hero ─────────────────────────────────────────────────────────────
// Shows greeting + name when profile exists, or inline profile form otherwise.

class _HomeHero extends StatefulWidget {
  const _HomeHero();

  @override
  State<_HomeHero> createState() => _HomeHeroState();
}

class _HomeHeroState extends State<_HomeHero> {
  final _nameCtrl = TextEditingController();
  String? _selectedEmoji;
  bool _saving = false;

  static const _emojis = [
    '🌟', '🌺', '🌈', '🦋',
    '🌻', '🌿', '☀️', '🎨',
    '📚', '🧘', '💫', '🌙',
    '🏔️', '🌊', '🎵', '🌱',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    setState(() => _saving = true);
    final s = StorageServiceScope.of(context);
    await s.setProfileName(name);
    await s.setProfileAvatar(_selectedEmoji ?? _emojis.first);
    await s.setProfileCompleted(true);
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final isKichwa = l10n.isKichwa;
    final storage = StorageServiceScope.of(context);
    final hasProfile = storage.getProfileCompleted();
    final top = MediaQuery.paddingOf(context).top;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        top + AppSpacing.md,
        AppSpacing.screen,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: logo + language switcher
          Row(
            children: [
              Image.asset(AppAssets.logo, height: 28, fit: BoxFit.contain),
              const SizedBox(width: AppSpacing.sm),
              Image.asset(AppAssets.espochShield, height: 24, fit: BoxFit.contain),
              const Spacer(),
              FramerIconButton(
                icon: Icons.translate_rounded,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (_) => const LanguageSelectionScreen(fromSettings: true),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          if (hasProfile) ...[
            // ── Greeting ────────────────────────────────────────────────
            Builder(builder: (ctx) {
              final hour = DateTime.now().toUtc().subtract(const Duration(hours: 5)).hour;
              final profileAvatar = storage.getProfileAvatar();
              final profileName = storage.getProfileName();
              final greeting = Tr.profileGreetingByHour(isKichwa, hour);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profileAvatar != null ? '$profileAvatar  $greeting' : greeting,
                    style: AppTypography.eyebrow(p),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    profileName ?? (isKichwa ? l10n.appSubtitle : 'Tu bienestar\nempieza hoy'),
                    style: AppTypography.displayLg(p),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    isKichwa ? 'Yachachikkuna allí kawsanapak' : 'Para docentes que cuidan su salud',
                    style: AppTypography.bodySm(p),
                  ),
                ],
              );
            }),
          ] else ...[
            // ── Inline profile form ──────────────────────────────────────
            Text(
              (isKichwa ? Tr.profileTeacherProfileQu : Tr.profileTeacherProfileEs).toUpperCase(),
              style: AppTypography.eyebrow(p),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              isKichwa ? Tr.profileTeacherQu : Tr.profileTeacherEs,
              style: AppTypography.displayLg(p),
            ),
            const SizedBox(height: AppSpacing.md),
            // Name field
            TextField(
              controller: _nameCtrl,
              textCapitalization: TextCapitalization.words,
              style: AppTypography.body(p),
              decoration: InputDecoration(
                hintText: isKichwa ? 'Shutiyki...' : 'Tu nombre...',
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
              onSubmitted: (_) => _save(),
            ),
            const SizedBox(height: AppSpacing.md),
            // Emoji row
            Text(
              (isKichwa ? Tr.profileChooseAvatarQu : Tr.profileChooseAvatarEs).toUpperCase(),
              style: AppTypography.eyebrow(p),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 52,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _emojis.length,
                separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
                itemBuilder: (_, i) {
                  final e = _emojis[i];
                  final sel = _selectedEmoji == e;
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _selectedEmoji = e);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: sel ? p.blockMint : p.surface2,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        border: Border.all(
                          color: sel ? p.blockMintText : p.hairline,
                          width: sel ? 2 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(e, style: const TextStyle(fontSize: 26)),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // Save button
            GestureDetector(
              onTap: _saving ? null : _save,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _saving ? 0.5 : 1.0,
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: p.ink,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  ),
                  child: Center(
                    child: Text(
                      isKichwa ? Tr.profileSaveProfileQu : Tr.profileSaveProfileEs,
                      style: AppTypography.button(p, color: p.primaryBtnFg),
                    ),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

