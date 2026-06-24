import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import 'tr.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const supportedLocales = [
    Locale('es'),
    Locale('qu'),
  ];

  bool get isKichwa => locale.languageCode == AppConstants.langKichwa;

  String _t(String es, String qu) => Tr.pick(isKichwa, es, qu);

  // General
  String get appName => Tr.appName(isKichwa);
  String get appSubtitle => Tr.appTagline(isKichwa);
  String get welcome => Tr.greetingsWelcome(isKichwa);
  String get welcomeMorning => Tr.greetingsGoodMorning(isKichwa);
  String get welcomeAfternoon => Tr.greetingsGoodAfternoon(isKichwa);
  String get welcomeEvening => Tr.greetingsGoodEvening(isKichwa);
  String get wellnessToday => Tr.greetingsWellbeingStartsToday(isKichwa);
  String get selectLanguage => Tr.languageSelectionTitle(isKichwa);
  String get spanish => Tr.languageSelectionSpanish(isKichwa);
  String get kichwa => Tr.languageSelectionKichwa(isKichwa);
  String get continueBtn => Tr.languageSelectionContinueSpanish(isKichwa);
  String get home => Tr.navHome(isKichwa);
  String get settings => Tr.navSettings(isKichwa);
  String get progress => _t('Progreso', 'Progreso');
  String get wellbeing => _t('Bienestar', Tr.vocabularyPhysicalWellbeingQu);
  String get start => _t('Iniciar', 'Kallariy');
  String get pause => _t('Pausar', 'Sayachiy');
  String get resume => _t('Reanudar', 'Kutichiy');
  String get finish => _t('Finalizar', 'Tukuchiy');
  String get back => _t('Volver', 'Kutiy');
  String get description => _t('Descripción', 'Willay');
  String get cause => _t('Causa', 'Imamanta');
  String get warningSign => _t('Señal de alerta', 'Imapi rikunchik');
  String get whenToSeeDoctor => Tr.seeDoctorTitle(isKichwa);
  String get duration => _t('Duración', 'Pacha');
  String get minutes => _t('minutos', 'chiniku');
  String get seconds => _t('segundos', 'chinilla');
  String get whatIsIt => _t('¿Qué es?', 'Imatak kan?');
  String get commonCauses =>
      Tr.mentalHealthAngerCausesTitle(isKichwa);
  String get whatCanIDo =>
      Tr.mentalHealthAngerWhatToDoTitle(isKichwa);
  String get motivationalPhrase => _t('Frase motivacional', 'Alli nikuy');
  String get save => _t('Guardar', 'Wachay');
  String get notifications => _t('Notificaciones', 'Willaykuna');
  String get appInfo => _t('Información de la app', 'App willay');
  String get version => _t('Versión', 'Laya');
  String get changeLanguage => _t('Cambiar idioma', 'Shimita tikray');
  String get noData => _t('Sin datos aún', 'Manarak willaykuna');

  // Módulos
  String get moduleErgonomics => Tr.modulesErgonomics(isKichwa);
  String get moduleDiseases => _t('Enfermedades', Tr.diseasesTitleQu);
  String get moduleActiveBreaks => Tr.activeBreaksTitle(isKichwa);
  String get moduleExercises => Tr.exercisesTitle(isKichwa);
  String get moduleReminders => Tr.remindersTitle(isKichwa);
  String get moduleTips => Tr.tipsTitle(isKichwa);
  String get moduleEmotions => _t('Salud Mental', Tr.mentalHealthTitleQu);
  String get moduleMusic => Tr.mediaMusicTitle(isKichwa);
  String get moduleVideos => Tr.mediaVideosTitle(isKichwa);
  String get moduleProgress => _t('Progreso', 'Progreso');

  // Ergonomía
  String get ergoWhatIs => Tr.ergonomicsWhatIsTitle(isKichwa);
  String get ergoRepetitive => Tr.ergonomicsRepetitiveMovementsTitle(isKichwa);
  String get ergoPhysicalCauses => Tr.physicalCausesTitle(isKichwa);
  String get ergoAffectedZones => Tr.affectedZonesTitle(isKichwa);
  String get ergoPosture => Tr.workstationTitle(isKichwa);
  String get ergoWhoFact => _t('Dato clave OMS', 'OMS');

  // Pausas activas
  String get activeBreaksWhat => Tr.activeBreaksWhatIsTitle(isKichwa);
  String get activeBreaksSubtitle => Tr.activeBreaksSubtitle(isKichwa);
  String get sequence5min => Tr.activeBreaksSequenceTitle(isKichwa);
  String get activeBreaksFrequency => Tr.activeBreaksFrequency(isKichwa);

  // Recordatorios
  String get remindersActive => Tr.remindersActiveNotifications(isKichwa);
  String get breakFrequency => Tr.remindersActiveBreaksTitle(isKichwa);
  String get dailyExercise => Tr.remindersDailyExerciseTitle(isKichwa);
  String get nightSilence => Tr.remindersNightSilence(isKichwa);
  String get nightSilenceDesc => Tr.remindersNightSilenceHours(isKichwa);
  String get remindersMotivational =>
      Tr.remindersMotivationalMessage(isKichwa);

  // Salud mental
  String get mentalHealthTitle => Tr.mentalHealthTitle(isKichwa);
  String get recognizeEmotions => Tr.mentalHealthRecognizeCareTitle(isKichwa);
  String get recognizeEmotionsDesc =>
      Tr.mentalHealthRecognizeCareDesc(isKichwa);
  String get tapEmotion => Tr.mentalHealthTapEmotion(isKichwa);
  String get mediaClosingReminder => Tr.mediaClosingReminder(isKichwa);

  // Progreso
  String get exercisesCompleted =>
      _t('Ejercicios completados', 'Kuyuykuna tukurishka');
  String get breaksCompleted =>
      _t('Pausas activas completadas', 'Samariykuna tukurishka');
  String get emotionsRecorded =>
      _t('Emociones registradas', 'Munaykuna wachashka');
  String get usageDays => _t('Días de uso', 'Punchakuna ushak');

  // Música
  String get play => _t('Reproducir', 'Paskay');
  String get musicPause => _t('Pausar', 'Sayachiy');
  String get volume => _t('Volumen', 'Sinchi kay');
  String get musicPlaylist => Tr.mediaPlaylistTitle(isKichwa);

  // Videos
  String get recommendedVideos => Tr.mediaVideosTitle(isKichwa);

  // Consejos
  String get tipsPreventive => Tr.tipsPreventiveTitle(isKichwa);

  String welcomeByHour(int hour) {
    if (hour < 12) return welcomeMorning;
    if (hour < 18) return welcomeAfternoon;
    return welcomeEvening;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'es' || locale.languageCode == 'qu';

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
