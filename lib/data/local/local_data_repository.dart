import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/localization/tr.dart';
import '../models/active_break_step.dart';
import '../models/disease.dart';
import '../models/emotion.dart';
import '../models/exercise.dart';
import '../models/home_category.dart';
import '../models/module_item.dart';
import '../models/music_track.dart';
import '../models/tip.dart';
import '../models/video_item.dart';

class LocalDataRepository {
  LocalDataRepository._();
  static final LocalDataRepository instance = LocalDataRepository._();

  static const _thumbClassroom =
      'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=480&q=80';

  static const _consultEs =
      '${Tr.seeDoctorReasonPainWeeksEs}\n${Tr.seeDoctorReasonTinglingEs}\n${Tr.seeDoctorReasonWeaknessEs}';
  static const _consultQu =
      '${Tr.seeDoctorReasonPainWeeksQu}\n${Tr.seeDoctorReasonTinglingQu}\n${Tr.seeDoctorReasonWeaknessQu}';

  static const _goldenRuleEs =
      '${Tr.tipsGoldenRule30Es}\n${Tr.tipsGoldenRule45Es}\n${Tr.tipsGoldenRuleNoteEs}';
  static const _goldenRuleQu =
      '${Tr.tipsGoldenRule30Qu}\n${Tr.tipsGoldenRule45Qu}\n${Tr.tipsGoldenRuleNoteQu}';

  List<ModuleItem> get modules => const [
        ModuleItem(
          id: 'ergonomics',
          titleEs: Tr.modulesErgonomicsEs,
          titleQu: Tr.modulesErgonomicsQu,
          icon: Icons.chair_alt,
          route: '/ergonomics',
          color: Color(0xFF5B8A72),
          homeCategory: HomeCategory.body,
          thumbnailUrl: _thumbClassroom,
          subtitleEs: Tr.modulesTeacherErgonomicsEs,
          subtitleQu: Tr.modulesTeacherErgonomicsQu,
        ),
        ModuleItem(
          id: 'diseases',
          titleEs: Tr.diseasesTitleEs,
          titleQu: Tr.diseasesTitleQu,
          icon: Icons.medical_information,
          route: '/diseases',
          color: Color(0xFFD08070),
          homeCategory: HomeCategory.body,
          subtitleEs: Tr.diseasesMusculoskeletalTitleEs,
          subtitleQu: Tr.diseasesMusculoskeletalTitleQu,
        ),
        ModuleItem(
          id: 'active_breaks',
          titleEs: Tr.activeBreaksTitleEs,
          titleQu: Tr.activeBreaksTitleQu,
          icon: Icons.self_improvement,
          route: '/active-breaks',
          color: Color(0xFF2D8B6F),
          homeCategory: HomeCategory.today,
          subtitleEs: Tr.activeBreaksSequenceTitleEs,
          subtitleQu: Tr.activeBreaksSequenceTitleQu,
        ),
        ModuleItem(
          id: 'exercises',
          titleEs: Tr.exercisesTitleEs,
          titleQu: Tr.exercisesTitleQu,
          icon: Icons.fitness_center,
          route: '/exercises',
          color: Color(0xFF3A9B8A),
          homeCategory: HomeCategory.today,
          subtitleEs: Tr.exercisesNeckTitleEs,
          subtitleQu: Tr.exercisesNeckTitleQu,
        ),
        ModuleItem(
          id: 'reminders',
          titleEs: Tr.remindersTitleEs,
          titleQu: Tr.remindersTitleQu,
          icon: Icons.notifications_active,
          route: '/reminders',
          color: Color(0xFF6B8CAE),
          homeCategory: HomeCategory.mind,
          subtitleEs: Tr.remindersMotivationalMessageEs,
          subtitleQu: Tr.remindersMotivationalMessageQu,
        ),
        ModuleItem(
          id: 'tips',
          titleEs: Tr.tipsTitleEs,
          titleQu: Tr.tipsTitleQu,
          icon: Icons.lightbulb_outline,
          route: '/tips',
          color: Color(0xFFE07A4A),
          homeCategory: HomeCategory.today,
          subtitleEs: Tr.tipsPreventiveTitleEs,
          subtitleQu: Tr.tipsPreventiveTitleQu,
        ),
        ModuleItem(
          id: 'emotions',
          titleEs: 'Salud Mental',
          titleQu: Tr.mentalHealthTitleQu,
          icon: Icons.favorite_outline,
          route: '/emotions',
          color: Color(0xFFD46A8C),
          homeCategory: HomeCategory.today,
          subtitleEs: Tr.mentalHealthRecognizeCareTitleEs,
          subtitleQu: Tr.mentalHealthRecognizeCareTitleQu,
        ),
        ModuleItem(
          id: 'music',
          titleEs: Tr.mediaMusicTitleEs,
          titleQu: Tr.mediaMusicTitleQu,
          icon: Icons.music_note,
          route: '/music',
          color: Color(0xFF4DB6AC),
          homeCategory: HomeCategory.mind,
          subtitleEs: Tr.mediaPlaylistTitleEs,
          subtitleQu: Tr.mediaPlaylistTitleQu,
        ),
        ModuleItem(
          id: 'videos',
          titleEs: Tr.mediaVideosTitleEs,
          titleQu: Tr.mediaVideosTitleQu,
          icon: Icons.play_circle_outline,
          route: '/videos',
          color: Color(0xFF6B7FBD),
          homeCategory: HomeCategory.learn,
          thumbnailUrl: _thumbClassroom,
          subtitleEs: Tr.vocabularyLearningEs,
          subtitleQu: Tr.vocabularyLearningQu,
        ),
        ModuleItem(
          id: 'progress',
          titleEs: 'Progreso',
          titleQu: 'Progreso',
          icon: Icons.insights,
          route: '/progress',
          color: Color(0xFF5B6B9E),
          homeCategory: HomeCategory.mind,
          subtitleEs: Tr.vocabularyPhysicalWellbeingEs,
          subtitleQu: Tr.vocabularyPhysicalWellbeingQu,
        ),
      ];

  ModuleItem? moduleById(String id) {
    try {
      return modules.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  List<ModuleItem> modulesForToday() =>
      modules.where((m) => m.homeCategory == HomeCategory.today).toList();

  List<ModuleItem> modulesByCategory(HomeCategory category) =>
      modules.where((m) => m.homeCategory == category).toList();

  Tip tipOfDay([DateTime? date]) {
    final now = date ?? DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    return tips[dayOfYear % tips.length];
  }

  Exercise exerciseOfDay([DateTime? date]) {
    final list = exercises;
    final day = (date ?? DateTime.now()).day;
    return list[day % list.length];
  }

  List<Map<String, String>> ergonomicsSections(bool isKichwa) {
    final physicalCauses = [
      Tr.physicalCausesBlackboard(isKichwa),
      Tr.physicalCausesKeyboardMouse(isKichwa),
      Tr.physicalCausesStaticPosture(isKichwa),
      Tr.physicalCausesTouchscreen(isKichwa),
    ].join('\n\n');

    final zones = [
      Tr.affectedZonesNeck(isKichwa),
      Tr.affectedZonesShoulders(isKichwa),
      Tr.affectedZonesLowerBack(isKichwa),
      Tr.affectedZonesWrists(isKichwa),
      Tr.affectedZonesUpperBack(isKichwa),
      Tr.affectedZonesLegs(isKichwa),
    ].join(' · ');

    final workstation = [
      Tr.workstationChair(isKichwa),
      Tr.workstationDesk(isKichwa),
      Tr.workstationLaptop(isKichwa),
      Tr.workstationLighting(isKichwa),
    ].join('\n\n');

    return [
      {
        'title': Tr.ergonomicsWhatIsTitle(isKichwa),
        'content': Tr.ergonomicsWhatIsDesc(isKichwa),
      },
      {
        'title': Tr.ergonomicsRepetitiveMovementsTitle(isKichwa),
        'content': Tr.ergonomicsRepetitiveMovementsDesc(isKichwa),
      },
      {
        'title': Tr.physicalCausesTitle(isKichwa),
        'content': physicalCauses,
      },
      {
        'title': Tr.affectedZonesTitle(isKichwa),
        'content': zones,
      },
      {
        'title': Tr.workstationTitle(isKichwa),
        'content': '${Tr.workstationDesc(isKichwa)}\n\n$workstation',
      },
      {
        'title': Tr.workstationKeyFact(isKichwa).startsWith('(')
            ? 'OMS'
            : 'Dato clave OMS',
        'content': Tr.workstationKeyFact(isKichwa),
      },
    ];
  }

  List<Disease> get diseases => const [
        Disease(
          id: 'carpal_tunnel',
          nameEs: Tr.diseasesCarpalTunnelTitleEs,
          nameQu: Tr.diseasesCarpalTunnelTitleQu,
          descriptionEs: Tr.diseasesCarpalTunnelDescEs,
          descriptionQu: Tr.diseasesCarpalTunnelDescQu,
          causeEs: Tr.diseasesCarpalTunnelCauseEs,
          causeQu: Tr.diseasesCarpalTunnelCauseQu,
          warningEs: Tr.diseasesCarpalTunnelWarningEs,
          warningQu: Tr.diseasesCarpalTunnelWarningQu,
          consultEs: _consultEs,
          consultQu: _consultQu,
        ),
        Disease(
          id: 'shoulder_tendinitis',
          nameEs: Tr.diseasesTendinitisTitleEs,
          nameQu: Tr.diseasesTendinitisTitleQu,
          descriptionEs: Tr.diseasesTendinitisDescEs,
          descriptionQu: Tr.diseasesTendinitisDescQu,
          causeEs: Tr.diseasesTendinitisCauseEs,
          causeQu: Tr.diseasesTendinitisCauseQu,
          warningEs: Tr.diseasesTendinitisWarningEs,
          warningQu: Tr.diseasesTendinitisWarningQu,
          consultEs: _consultEs,
          consultQu: _consultQu,
        ),
        Disease(
          id: 'chronic_lumbago',
          nameEs: Tr.diseasesLowBackPainTitleEs,
          nameQu: Tr.diseasesLowBackPainTitleQu,
          descriptionEs: Tr.diseasesLowBackPainDescEs,
          descriptionQu: Tr.diseasesLowBackPainDescQu,
          causeEs: 'Permanecer mucho tiempo de pie o sentado.',
          causeQu: 'Yalli pacha shayashpalla maypika tiyashpalla llamkashkamanta.',
          warningEs: Tr.diseasesLowBackPainWarningEs,
          warningQu: Tr.diseasesLowBackPainWarningQu,
          consultEs: _consultEs,
          consultQu: _consultQu,
        ),
        Disease(
          id: 'cervicalgia',
          nameEs: Tr.diseasesNeckPainTitleEs,
          nameQu: Tr.diseasesNeckPainTitleQu,
          descriptionEs: Tr.diseasesNeckPainDescEs,
          descriptionQu: Tr.diseasesNeckPainDescQu,
          causeEs:
              'Posturas forzadas frente a pantallas o al escribir en la pizarra.',
          causeQu:
              'Killkanapi mana allí tiyarikpi, rikuchiypi mana allí kunkata charikpimi.',
          warningEs: Tr.diseasesNeckPainWarningEs,
          warningQu: Tr.diseasesNeckPainWarningQu,
          consultEs: _consultEs,
          consultQu: _consultQu,
        ),
      ];

  List<ActiveBreakStep> get activeBreakSteps => const [
        ActiveBreakStep(
          id: 'neck_rotation',
          nameEs: Tr.activeBreaksNeckRotationEs,
          nameQu: Tr.activeBreaksNeckRotationQu,
          descriptionEs: Tr.activeBreaksNeckRotationDescEs,
          descriptionQu: Tr.activeBreaksNeckRotationDescQu,
          durationSeconds: 60,
        ),
        ActiveBreakStep(
          id: 'shoulder_raise',
          nameEs: Tr.activeBreaksShoulderElevationEs,
          nameQu: Tr.activeBreaksShoulderElevationQu,
          descriptionEs: Tr.activeBreaksShoulderElevationDescEs,
          descriptionQu: Tr.activeBreaksShoulderElevationDescQu,
          durationSeconds: 60,
        ),
        ActiveBreakStep(
          id: 'wrist_stretch',
          nameEs: Tr.activeBreaksWristStretchEs,
          nameQu: Tr.activeBreaksWristStretchQu,
          descriptionEs: Tr.activeBreaksWristStretchDescEs,
          descriptionQu: Tr.activeBreaksWristStretchDescQu,
          durationSeconds: 60,
        ),
        ActiveBreakStep(
          id: 'lumbar_arch',
          nameEs: Tr.activeBreaksLumbarArchEs,
          nameQu: Tr.activeBreaksLumbarArchQu,
          descriptionEs: Tr.activeBreaksLumbarArchDescEs,
          descriptionQu: Tr.activeBreaksLumbarArchDescQu,
          durationSeconds: 60,
        ),
        ActiveBreakStep(
          id: 'deep_breathing',
          nameEs: Tr.activeBreaksDeepBreathingEs,
          nameQu: Tr.activeBreaksDeepBreathingQu,
          descriptionEs: Tr.activeBreaksDeepBreathingDescEs,
          descriptionQu: Tr.activeBreaksDeepBreathingDescQu,
          durationSeconds: 60,
        ),
      ];

  String activeBreaksIntro(bool isKichwa) =>
      Tr.activeBreaksWhatIsDesc(isKichwa);

  String activeBreaksFrequency(bool isKichwa) =>
      Tr.activeBreaksFrequency(isKichwa);

  List<ExerciseCategory> get exerciseCategories => const [
        ExerciseCategory(
          id: 'neck',
          nameEs: Tr.exercisesNeckTitleEs,
          nameQu: Tr.exercisesNeckTitleQu,
          iconName: 'neck',
        ),
        ExerciseCategory(
          id: 'shoulders',
          nameEs: Tr.exercisesShouldersTitleEs,
          nameQu: Tr.exercisesShouldersTitleQu,
          iconName: 'shoulders',
        ),
        ExerciseCategory(
          id: 'hands',
          nameEs: Tr.exercisesHandsTitleEs,
          nameQu: Tr.exercisesHandsTitleQu,
          iconName: 'hands',
        ),
        ExerciseCategory(
          id: 'back',
          nameEs: Tr.exercisesBackTitleEs,
          nameQu: Tr.exercisesBackTitleQu,
          iconName: 'back',
        ),
        ExerciseCategory(
          id: 'hips',
          nameEs: Tr.exercisesHipsTitleEs,
          nameQu: Tr.exercisesHipsTitleQu,
          iconName: 'hips',
        ),
        ExerciseCategory(
          id: 'legs',
          nameEs: Tr.exercisesLegsTitleEs,
          nameQu: Tr.exercisesLegsTitleQu,
          iconName: 'legs',
        ),
        ExerciseCategory(
          id: 'vision',
          nameEs: Tr.exercisesVisionTitleEs,
          nameQu: Tr.exercisesVisionTitleQu,
          iconName: 'vision',
        ),
        ExerciseCategory(
          id: 'breathing',
          nameEs: Tr.exercisesBreathingTitleEs,
          nameQu: Tr.exercisesBreathingTitleQu,
          iconName: 'breathing',
        ),
      ];

  List<Exercise> get exercises => const [
        Exercise(
          id: 'neck_1',
          categoryId: 'neck',
          nameEs: Tr.exercisesNeckRotationTitleEs,
          nameQu: Tr.exercisesNeckRotationTitleQu,
          descriptionEs: Tr.exercisesNeckRotationDescEs,
          descriptionQu: Tr.exercisesNeckRotationDescQu,
          durationSeconds: 60,
        ),
        Exercise(
          id: 'neck_2',
          categoryId: 'neck',
          nameEs: Tr.exercisesNeckFlexionTitleEs,
          nameQu: Tr.exercisesNeckFlexionTitleQu,
          descriptionEs: Tr.exercisesNeckFlexionDescEs,
          descriptionQu: Tr.exercisesNeckFlexionDescQu,
          durationSeconds: 40,
        ),
        Exercise(
          id: 'neck_3',
          categoryId: 'neck',
          nameEs: Tr.exercisesNeckLateralTitleEs,
          nameQu: Tr.exercisesNeckLateralTitleQu,
          descriptionEs: Tr.exercisesNeckLateralDescEs,
          descriptionQu: Tr.exercisesNeckLateralDescQu,
          durationSeconds: 30,
        ),
        Exercise(
          id: 'shoulders_1',
          categoryId: 'shoulders',
          nameEs: Tr.exercisesShouldersElevationTitleEs,
          nameQu: Tr.exercisesShouldersElevationTitleQu,
          descriptionEs: Tr.exercisesShouldersElevationDescEs,
          descriptionQu: Tr.exercisesShouldersElevationDescQu,
          durationSeconds: 50,
        ),
        Exercise(
          id: 'shoulders_2',
          categoryId: 'shoulders',
          nameEs: Tr.exercisesShouldersCirclesTitleEs,
          nameQu: Tr.exercisesShouldersCirclesTitleQu,
          descriptionEs: Tr.exercisesShouldersCirclesDescEs,
          descriptionQu: Tr.exercisesShouldersCirclesDescQu,
          durationSeconds: 45,
        ),
        Exercise(
          id: 'shoulders_3',
          categoryId: 'shoulders',
          nameEs: Tr.exercisesShouldersCrossStretchTitleEs,
          nameQu: Tr.exercisesShouldersCrossStretchTitleQu,
          descriptionEs: Tr.exercisesShouldersCrossStretchDescEs,
          descriptionQu: Tr.exercisesShouldersCrossStretchDescQu,
          durationSeconds: 40,
        ),
        Exercise(
          id: 'hands_1',
          categoryId: 'hands',
          nameEs: Tr.exercisesHandsFingerExtensionTitleEs,
          nameQu: Tr.exercisesHandsFingerExtensionTitleQu,
          descriptionEs: Tr.exercisesHandsFingerExtensionDescEs,
          descriptionQu: Tr.exercisesHandsFingerExtensionDescQu,
          durationSeconds: 40,
        ),
        Exercise(
          id: 'hands_2',
          categoryId: 'hands',
          nameEs: Tr.exercisesHandsWristRotationTitleEs,
          nameQu: Tr.exercisesHandsWristRotationTitleQu,
          descriptionEs: Tr.exercisesHandsWristRotationDescEs,
          descriptionQu: Tr.exercisesHandsWristRotationDescQu,
          durationSeconds: 35,
        ),
        Exercise(
          id: 'hands_3',
          categoryId: 'hands',
          nameEs: Tr.exercisesHandsFingerOppositionTitleEs,
          nameQu: Tr.exercisesHandsFingerOppositionTitleQu,
          descriptionEs: Tr.exercisesHandsFingerOppositionDescEs,
          descriptionQu: Tr.exercisesHandsFingerOppositionDescQu,
          durationSeconds: 30,
        ),
        Exercise(
          id: 'back_1',
          categoryId: 'back',
          nameEs: Tr.exercisesBackArchRoundTitleEs,
          nameQu: Tr.exercisesBackArchRoundTitleQu,
          descriptionEs: Tr.exercisesBackArchRoundDescEs,
          descriptionQu: Tr.exercisesBackArchRoundDescQu,
          durationSeconds: 60,
        ),
        Exercise(
          id: 'back_2',
          categoryId: 'back',
          nameEs: Tr.exercisesBackTrunkRotationTitleEs,
          nameQu: Tr.exercisesBackTrunkRotationTitleQu,
          descriptionEs: Tr.exercisesBackTrunkRotationDescEs,
          descriptionQu: Tr.exercisesBackTrunkRotationDescQu,
          durationSeconds: 45,
        ),
        Exercise(
          id: 'hips_1',
          categoryId: 'hips',
          nameEs: Tr.exercisesHipsCirclesTitleEs,
          nameQu: Tr.exercisesHipsCirclesTitleQu,
          descriptionEs: Tr.exercisesHipsCirclesDescEs,
          descriptionQu: Tr.exercisesHipsCirclesDescQu,
          durationSeconds: 40,
        ),
        Exercise(
          id: 'hips_2',
          categoryId: 'hips',
          nameEs: Tr.exercisesHipsLateralLungeTitleEs,
          nameQu: Tr.exercisesHipsLateralLungeTitleQu,
          descriptionEs: Tr.exercisesHipsLateralLungeDescEs,
          descriptionQu: Tr.exercisesHipsLateralLungeDescQu,
          durationSeconds: 60,
        ),
        Exercise(
          id: 'hips_3',
          categoryId: 'hips',
          nameEs: Tr.exercisesHipsStandingHipTitleEs,
          nameQu: Tr.exercisesHipsStandingHipTitleQu,
          descriptionEs: Tr.exercisesHipsStandingHipDescEs,
          descriptionQu: Tr.exercisesHipsStandingHipDescQu,
          durationSeconds: 60,
        ),
        Exercise(
          id: 'legs_1',
          categoryId: 'legs',
          nameEs: Tr.exercisesLegsHeelRaiseTitleEs,
          nameQu: Tr.exercisesLegsHeelRaiseTitleQu,
          descriptionEs: Tr.exercisesLegsHeelRaiseDescEs,
          descriptionQu: Tr.exercisesLegsHeelRaiseDescQu,
          durationSeconds: 60,
        ),
        Exercise(
          id: 'legs_2',
          categoryId: 'legs',
          nameEs: Tr.exercisesLegsAnkleRotationTitleEs,
          nameQu: Tr.exercisesLegsAnkleRotationTitleQu,
          descriptionEs: Tr.exercisesLegsAnkleRotationDescEs,
          descriptionQu: Tr.exercisesLegsAnkleRotationDescQu,
          durationSeconds: 50,
        ),
        Exercise(
          id: 'vision_1',
          categoryId: 'vision',
          nameEs: Tr.exercisesVisionRule202020TitleEs,
          nameQu: Tr.exercisesVisionRule202020TitleQu,
          descriptionEs: Tr.exercisesVisionRule202020DescEs,
          descriptionQu: Tr.exercisesVisionRule202020DescQu,
          durationSeconds: 60,
          stepsEs: [
            Tr.exercisesVisionStep1Es,
            Tr.exercisesVisionStep2Es,
            Tr.exercisesVisionStep3Es,
          ],
          stepsQu: [
            Tr.exercisesVisionStep1Qu,
            Tr.exercisesVisionStep2Qu,
            Tr.exercisesVisionStep3Qu,
          ],
        ),
        Exercise(
          id: 'breathing_1',
          categoryId: 'breathing',
          nameEs: Tr.exercisesBreathingTechnique478TitleEs,
          nameQu: Tr.exercisesBreathingTechnique478TitleQu,
          descriptionEs: Tr.exercisesBreathingStep2Es,
          descriptionQu: Tr.exercisesBreathingStep2Qu,
          durationSeconds: 300,
          stepsEs: [
            Tr.exercisesBreathingStep1Es,
            Tr.exercisesBreathingStep2Es,
          ],
          stepsQu: [
            Tr.exercisesBreathingStep1Qu,
            Tr.exercisesBreathingStep2Qu,
          ],
        ),
      ];

  List<Exercise> exercisesByCategory(String categoryId) =>
      exercises.where((e) => e.categoryId == categoryId).toList();

  List<Tip> get tips => const [
        Tip(
          id: 'chair_desk',
          titleEs: Tr.tipsAdjustChairDeskEs,
          titleQu: Tr.tipsAdjustChairDeskQu,
          contentEs: Tr.tipsAdjustChairDeskDescEs,
          contentQu: Tr.tipsAdjustChairDeskDescQu,
          iconName: 'chair',
        ),
        Tip(
          id: 'blackboard',
          titleEs: Tr.tipsBlackboardWritingEs,
          titleQu: Tr.tipsBlackboardWritingQu,
          contentEs: Tr.tipsBlackboardWritingDescEs,
          contentQu: Tr.tipsBlackboardWritingDescQu,
          iconName: 'blackboard',
        ),
        Tip(
          id: 'laptop',
          titleEs: Tr.tipsLaptopErgonomicsEs,
          titleQu: Tr.tipsLaptopErgonomicsQu,
          contentEs: Tr.tipsLaptopErgonomicsDescEs,
          contentQu: Tr.tipsLaptopErgonomicsDescQu,
          iconName: 'laptop',
        ),
        Tip(
          id: 'vary_tasks',
          titleEs: Tr.tipsVaryTasksEs,
          titleQu: Tr.tipsVaryTasksQu,
          contentEs: Tr.tipsVaryTasksDescEs,
          contentQu: Tr.tipsVaryTasksDescQu,
          iconName: 'tasks',
        ),
        Tip(
          id: 'posture',
          titleEs: Tr.tipsGoldenRuleEs,
          titleQu: Tr.tipsGoldenRuleQu,
          contentEs: _goldenRuleEs,
          contentQu: _goldenRuleQu,
          iconName: 'posture',
        ),
        Tip(
          id: 'footwear',
          titleEs: Tr.tipsFootwearEs,
          titleQu: Tr.tipsFootwearQu,
          contentEs: Tr.tipsFootwearDescEs,
          contentQu: Tr.tipsFootwearDescQu,
          iconName: 'shoes',
        ),
      ];

  List<Emotion> get emotions => const [
        Emotion(
          id: 'anger',
          nameEs: Tr.mentalHealthAngerNameEs,
          nameQu: Tr.mentalHealthAngerNameQu,
          whatIsEs: Tr.mentalHealthAngerWhatIsEs,
          whatIsQu: Tr.mentalHealthAngerWhatIsQu,
          causesTitleEs: Tr.mentalHealthAngerCausesTitleEs,
          causesTitleQu: Tr.mentalHealthAngerCausesTitleQu,
          causesEs:
              '${Tr.mentalHealthAngerCauseDisrespectEs}\n${Tr.mentalHealthAngerCauseOverloadEs}\n${Tr.mentalHealthAngerCauseUnheardEs}',
          causesQu:
              '${Tr.mentalHealthAngerCauseDisrespectQu}\n${Tr.mentalHealthAngerCauseOverloadQu}\n${Tr.mentalHealthAngerCauseUnheardQu}',
          actionsTitleEs: Tr.mentalHealthAngerWhatToDoTitleEs,
          actionsTitleQu: Tr.mentalHealthAngerWhatToDoTitleQu,
          actionsEs:
              '${Tr.mentalHealthAngerActionBreathingEs}\n${Tr.mentalHealthAngerActionLeaveEs}\n${Tr.mentalHealthAngerActionWriteEs}\n${Tr.mentalHealthAngerActionPauseEs}',
          actionsQu:
              '${Tr.mentalHealthAngerActionBreathingQu}\n${Tr.mentalHealthAngerActionLeaveQu}\n${Tr.mentalHealthAngerActionWriteQu}\n${Tr.mentalHealthAngerActionPauseQu}',
          phraseEs: Tr.mentalHealthAngerAffirmationEs,
          phraseQu: Tr.mentalHealthAngerAffirmationQu,
          colorHex: 0xFFE57373,
          iconName: 'anger',
          imageAsset: AppAssets.emotionEnojo,
        ),
        Emotion(
          id: 'sadness',
          nameEs: Tr.mentalHealthSadnessNameEs,
          nameQu: Tr.mentalHealthSadnessNameQu,
          whatIsEs: Tr.mentalHealthSadnessWhatIsEs,
          whatIsQu: Tr.mentalHealthSadnessWhatIsQu,
          causesTitleEs: Tr.mentalHealthSadnessSignalsTitleEs,
          causesTitleQu: Tr.mentalHealthSadnessSignalsTitleQu,
          causesEs:
              '${Tr.mentalHealthSadnessSignalNoResultsEs}\n${Tr.mentalHealthSadnessSignalBurnoutEs}\n${Tr.mentalHealthSadnessSignalMisunderstoodEs}',
          causesQu:
              '${Tr.mentalHealthSadnessSignalNoResultsQu}\n${Tr.mentalHealthSadnessSignalBurnoutQu}\n${Tr.mentalHealthSadnessSignalMisunderstoodQu}',
          actionsTitleEs: Tr.mentalHealthSadnessStrategiesTitleEs,
          actionsTitleQu: Tr.mentalHealthSadnessStrategiesTitleQu,
          actionsEs:
              '${Tr.mentalHealthSadnessStrategyTalkEs}\n${Tr.mentalHealthSadnessStrategyAchievementEs}\n${Tr.mentalHealthSadnessStrategyWalkEs}',
          actionsQu:
              '${Tr.mentalHealthSadnessStrategyTalkQu}\n${Tr.mentalHealthSadnessStrategyAchievementQu}\n${Tr.mentalHealthSadnessStrategyWalkQu}',
          phraseEs: Tr.mentalHealthSadnessAffirmationEs,
          phraseQu: Tr.mentalHealthSadnessAffirmationQu,
          colorHex: 0xFF64B5F6,
          iconName: 'sadness',
          imageAsset: AppAssets.emotionTristeza,
        ),
        Emotion(
          id: 'joy',
          nameEs: Tr.mentalHealthJoyNameEs,
          nameQu: Tr.mentalHealthJoyNameQu,
          whatIsEs: Tr.mentalHealthJoyWhatIsEs,
          whatIsQu: Tr.mentalHealthJoyWhatIsQu,
          causesTitleEs: Tr.mentalHealthJoySourcesTitleEs,
          causesTitleQu: Tr.mentalHealthJoySourcesTitleQu,
          causesEs:
              '${Tr.mentalHealthJoySourceStudentEs}\n${Tr.mentalHealthJoySourcePositiveEs}\n${Tr.mentalHealthJoySourceRecognitionEs}',
          causesQu:
              '${Tr.mentalHealthJoySourceStudentQu}\n${Tr.mentalHealthJoySourcePositiveQu}\n${Tr.mentalHealthJoySourceRecognitionQu}',
          actionsEs: '',
          actionsQu: '',
          phraseEs: Tr.mentalHealthJoyAffirmationEs,
          phraseQu: Tr.mentalHealthJoyAffirmationQu,
          colorHex: 0xFFFFB74D,
          iconName: 'joy',
          imageAsset: AppAssets.emotionAlegria,
        ),
        Emotion(
          id: 'fear',
          nameEs: Tr.mentalHealthFearNameEs,
          nameQu: Tr.mentalHealthFearNameQu,
          whatIsEs: Tr.mentalHealthFearWhatIsEs,
          whatIsQu: Tr.mentalHealthFearWhatIsQu,
          causesTitleEs: Tr.mentalHealthFearFearsTitleEs,
          causesTitleQu: Tr.mentalHealthFearFearsTitleQu,
          causesEs:
              '${Tr.mentalHealthFearFearNotEnoughEs}\n${Tr.mentalHealthFearFearCriticismEs}\n${Tr.mentalHealthFearFearJobLossEs}\n${Tr.mentalHealthFearFearTechnologyEs}',
          causesQu:
              '${Tr.mentalHealthFearFearNotEnoughQu}\n${Tr.mentalHealthFearFearCriticismQu}\n${Tr.mentalHealthFearFearJobLossQu}\n${Tr.mentalHealthFearFearTechnologyQu}',
          actionsTitleEs: Tr.mentalHealthFearWhatToDoTitleEs,
          actionsTitleQu: Tr.mentalHealthFearWhatToDoTitleQu,
          actionsEs:
              '${Tr.mentalHealthFearActionAnalyzeEs}\n${Tr.mentalHealthFearActionSmallStepsEs}\n${Tr.mentalHealthFearActionRememberEs}',
          actionsQu:
              '${Tr.mentalHealthFearActionAnalyzeQu}\n${Tr.mentalHealthFearActionSmallStepsQu}\n${Tr.mentalHealthFearActionRememberQu}',
          phraseEs: Tr.mentalHealthFearAffirmationEs,
          phraseQu: Tr.mentalHealthFearAffirmationQu,
          colorHex: 0xFF9575CD,
          iconName: 'fear',
          imageAsset: AppAssets.emotionMiedo,
        ),
        Emotion(
          id: 'anxiety',
          nameEs: Tr.mentalHealthAnxietyNameEs,
          nameQu: Tr.mentalHealthAnxietyNameQu,
          whatIsEs: Tr.mentalHealthAnxietyWhatIsEs,
          whatIsQu: Tr.mentalHealthAnxietyWhatIsQu,
          causesEs: '',
          causesQu: '',
          actionsTitleEs: Tr.mentalHealthAnxietyWhatToDoTitleEs,
          actionsTitleQu: Tr.mentalHealthAnxietyWhatToDoTitleQu,
          actionsEs:
              '${Tr.mentalHealthAnxietyActionBreatheEs}\n${Tr.mentalHealthAnxietyActionPrioritizeEs}\n${Tr.mentalHealthAnxietyAction54321Es}',
          actionsQu:
              '${Tr.mentalHealthAnxietyActionBreatheQu}\n${Tr.mentalHealthAnxietyActionPrioritizeQu}\n${Tr.mentalHealthAnxietyAction54321Qu}',
          phraseEs: Tr.mentalHealthAnxietyAffirmationEs,
          phraseQu: Tr.mentalHealthAnxietyAffirmationQu,
          colorHex: 0xFF4DB6AC,
          iconName: 'anxiety',
          imageAsset: AppAssets.emotionAnsiedad,
        ),
      ];

  List<MusicTrack> get musicTracks => const [
        MusicTrack(
          id: 'forest',
          titleEs: Tr.mediaTrackForestEs,
          titleQu: Tr.mediaTrackForestQu,
          descriptionEs: Tr.mediaTrackForestEs,
          descriptionQu: Tr.mediaTrackForestQu,
          assetPath: 'assets/audio/Sonido-del-bosque.mp3',
          isAsset: true,
        ),
        MusicTrack(
          id: 'rain',
          titleEs: Tr.mediaTrackRainEs,
          titleQu: Tr.mediaTrackRainQu,
          descriptionEs: Tr.mediaTrackRainEs,
          descriptionQu: Tr.mediaTrackRainQu,
          assetPath: 'assets/audio/Lluvia-Suave.mp3',
          isAsset: true,
        ),
        MusicTrack(
          id: 'energizing',
          titleEs: Tr.mediaTrackEnergizingEs,
          titleQu: Tr.mediaTrackEnergizingQu,
          descriptionEs: Tr.mediaTrackEnergizingEs,
          descriptionQu: Tr.mediaTrackEnergizingQu,
          assetPath: 'assets/audio/Musica-energizante.mp3',
          isAsset: true,
        ),
      ];

  List<VideoItem> get videos => const [
        VideoItem(
          id: 'ergo_posture',
          titleEs: Tr.mediaVideoErgonomicsEs,
          titleQu: Tr.mediaVideoErgonomicsQu,
          descriptionEs: Tr.mediaVideoErgonomicsEs,
          descriptionQu: Tr.mediaVideoErgonomicsQu,
          assetPath: 'assets/videos/Ergonomia_Postura_correcta.mp4',
        ),
        VideoItem(
          id: 'yoga_10',
          titleEs: Tr.mediaVideoYogaEs,
          titleQu: Tr.mediaVideoYogaQu,
          descriptionEs: Tr.mediaVideoYogaEs,
          descriptionQu: Tr.mediaVideoYogaQu,
          assetPath: 'assets/videos/5_MINUTOS_DE_YOGA.mp4',
        ),
      ];
}
