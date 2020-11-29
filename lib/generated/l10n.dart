// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Écran d'accueuil`
  String get homeScreenAppBarTitle {
    return Intl.message(
      'Écran d\'accueuil',
      name: 'homeScreenAppBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Calibration`
  String get homeScreenCalibration {
    return Intl.message(
      'Calibration',
      name: 'homeScreenCalibration',
      desc: '',
      args: [],
    );
  }

  /// `Statistiques`
  String get homeScreenStatistics {
    return Intl.message(
      'Statistiques',
      name: 'homeScreenStatistics',
      desc: '',
      args: [],
    );
  }

  /// `Préférences`
  String get homeScreenPreferences {
    return Intl.message(
      'Préférences',
      name: 'homeScreenPreferences',
      desc: '',
      args: [],
    );
  }

  /// `Paramètres`
  String get homeScreenSettings {
    return Intl.message(
      'Paramètres',
      name: 'homeScreenSettings',
      desc: '',
      args: [],
    );
  }

  /// `Batterie`
  String get homeScreenBatteryLevel {
    return Intl.message(
      'Batterie',
      name: 'homeScreenBatteryLevel',
      desc: '',
      args: [],
    );
  }

  /// `Profil`
  String get homeScreenProfile {
    return Intl.message(
      'Profil',
      name: 'homeScreenProfile',
      desc: '',
      args: [],
    );
  }

  /// `Page de calibration`
  String get calibrationScreenAppBarTitle {
    return Intl.message(
      'Page de calibration',
      name: 'calibrationScreenAppBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Démarrer`
  String get stopwatchStart {
    return Intl.message(
      'Démarrer',
      name: 'stopwatchStart',
      desc: '',
      args: [],
    );
  }

  /// `Arrêter`
  String get stopwatchStop {
    return Intl.message(
      'Arrêter',
      name: 'stopwatchStop',
      desc: '',
      args: [],
    );
  }

  /// `Remise à zéro`
  String get stopwatchReset {
    return Intl.message(
      'Remise à zéro',
      name: 'stopwatchReset',
      desc: '',
      args: [],
    );
  }

  /// `Page de statistiques`
  String get statisticsScreenAppBarTitle {
    return Intl.message(
      'Page de statistiques',
      name: 'statisticsScreenAppBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Aucun appareil connecté`
  String get statisticsNoDeviceConnected {
    return Intl.message(
      'Aucun appareil connecté',
      name: 'statisticsNoDeviceConnected',
      desc: '',
      args: [],
    );
  }

  /// `Gérer les appareils`
  String get statisticsManageDevices {
    return Intl.message(
      'Gérer les appareils',
      name: 'statisticsManageDevices',
      desc: '',
      args: [],
    );
  }

  /// `Nouveau mode...`
  String get preferenceModeDialogNewMode {
    return Intl.message(
      'Nouveau mode...',
      name: 'preferenceModeDialogNewMode',
      desc: '',
      args: [],
    );
  }

  /// `Aucun mode entré`
  String get preferenceModeDialogEnterMode {
    return Intl.message(
      'Aucun mode entré',
      name: 'preferenceModeDialogEnterMode',
      desc: '',
      args: [],
    );
  }

  /// `Mode déjà existant`
  String get preferenceModeDialogAlreadyExists {
    return Intl.message(
      'Mode déjà existant',
      name: 'preferenceModeDialogAlreadyExists',
      desc: '',
      args: [],
    );
  }

  /// `Aucun mode sélectionné`
  String get preferenceModeDialogNoModeSelected {
    return Intl.message(
      'Aucun mode sélectionné',
      name: 'preferenceModeDialogNoModeSelected',
      desc: '',
      args: [],
    );
  }

  /// `Page de préférences`
  String get preferencesScreenAppBarTitle {
    return Intl.message(
      'Page de préférences',
      name: 'preferencesScreenAppBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Choix du groupe`
  String get preferencesScreenSelectGroupset {
    return Intl.message(
      'Choix du groupe',
      name: 'preferencesScreenSelectGroupset',
      desc: '',
      args: [],
    );
  }

  /// `Puissance de seuil maximale`
  String get preferencesScreenThresholdPower {
    return Intl.message(
      'Puissance de seuil maximale',
      name: 'preferencesScreenThresholdPower',
      desc: '',
      args: [],
    );
  }

  /// `Puissance moyenne maximale par heure désirée`
  String get preferencesScreenThresholdPowerInfo {
    return Intl.message(
      'Puissance moyenne maximale par heure désirée',
      name: 'preferencesScreenThresholdPowerInfo',
      desc: '',
      args: [],
    );
  }

  /// `Puissance moyenne ciblée`
  String get preferencesScreenAveragePower {
    return Intl.message(
      'Puissance moyenne ciblée',
      name: 'preferencesScreenAveragePower',
      desc: '',
      args: [],
    );
  }

  /// `Puissance moyenne par heure ciblée`
  String get preferencesScreenAveragePowerInfo {
    return Intl.message(
      'Puissance moyenne par heure ciblée',
      name: 'preferencesScreenAveragePowerInfo',
      desc: '',
      args: [],
    );
  }

  /// `Sensibilité`
  String get preferencesScreenResponsiveness {
    return Intl.message(
      'Sensibilité',
      name: 'preferencesScreenResponsiveness',
      desc: '',
      args: [],
    );
  }

  /// `Variation de la rotation (par rapport à la cadence) requise pour causer un changement`
  String get preferencesScreenResponsivenessInfo {
    return Intl.message(
      'Variation de la rotation (par rapport à la cadence) requise pour causer un changement',
      name: 'preferencesScreenResponsivenessInfo',
      desc: '',
      args: [],
    );
  }

  /// `RPM désiré`
  String get preferencesScreenDesiredRPM {
    return Intl.message(
      'RPM désiré',
      name: 'preferencesScreenDesiredRPM',
      desc: '',
      args: [],
    );
  }

  /// `Vitesse en rotation par minutes (cadence) désirée du pédalier`
  String get preferencesScreenDesiredRPMInfo {
    return Intl.message(
      'Vitesse en rotation par minutes (cadence) désirée du pédalier',
      name: 'preferencesScreenDesiredRPMInfo',
      desc: '',
      args: [],
    );
  }

  /// `BPM désiré`
  String get preferencesScreenDesiredBPM {
    return Intl.message(
      'BPM désiré',
      name: 'preferencesScreenDesiredBPM',
      desc: '',
      args: [],
    );
  }

  /// `Rhythme cardiaque en battements par minutes désiré`
  String get preferencesScreenDesiredBPMInfo {
    return Intl.message(
      'Rhythme cardiaque en battements par minutes désiré',
      name: 'preferencesScreenDesiredBPMInfo',
      desc: '',
      args: [],
    );
  }

  /// `Réinitialiser les préférences`
  String get preferencesScreenResetProfile {
    return Intl.message(
      'Réinitialiser les préférences',
      name: 'preferencesScreenResetProfile',
      desc: '',
      args: [],
    );
  }

  /// `Fermer`
  String get infoDialogClose {
    return Intl.message(
      'Fermer',
      name: 'infoDialogClose',
      desc: '',
      args: [],
    );
  }

  /// `Page de paramètres`
  String get settingsScreenAppBarTitle {
    return Intl.message(
      'Page de paramètres',
      name: 'settingsScreenAppBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Partager`
  String get settingsScreenShare {
    return Intl.message(
      'Partager',
      name: 'settingsScreenShare',
      desc: '',
      args: [],
    );
  }

  /// `Page Facebook`
  String get settingsScreenFacebook {
    return Intl.message(
      'Page Facebook',
      name: 'settingsScreenFacebook',
      desc: '',
      args: [],
    );
  }

  /// `Déconnexion`
  String get settingsScreenLogout {
    return Intl.message(
      'Déconnexion',
      name: 'settingsScreenLogout',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get settingsScreenNotifications {
    return Intl.message(
      'Notifications',
      name: 'settingsScreenNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Gestion des appareils`
  String get settingsScreenDeviceManagement {
    return Intl.message(
      'Gestion des appareils',
      name: 'settingsScreenDeviceManagement',
      desc: '',
      args: [],
    );
  }

  /// `Page de gestion des appareils`
  String get findDeviceScreenAppBarTitle {
    return Intl.message(
      'Page de gestion des appareils',
      name: 'findDeviceScreenAppBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Recherche de OSS`
  String get findDeviceScreenLookingFor {
    return Intl.message(
      'Recherche de OSS',
      name: 'findDeviceScreenLookingFor',
      desc: '',
      args: [],
    );
  }

  /// `Recherche en cours...`
  String get findDeviceScreenCurrentlyLooking {
    return Intl.message(
      'Recherche en cours...',
      name: 'findDeviceScreenCurrentlyLooking',
      desc: '',
      args: [],
    );
  }

  /// `Rechercher plus tard`
  String get findDeviceScreenSearchLater {
    return Intl.message(
      'Rechercher plus tard',
      name: 'findDeviceScreenSearchLater',
      desc: '',
      args: [],
    );
  }

  /// `Page de batterie`
  String get batteryScreenAppBarTitle {
    return Intl.message(
      'Page de batterie',
      name: 'batteryScreenAppBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Gestion des appareils`
  String get batteryScreenDeviceManagement {
    return Intl.message(
      'Gestion des appareils',
      name: 'batteryScreenDeviceManagement',
      desc: '',
      args: [],
    );
  }

  /// `ACTIF`
  String get batteryScreenConnected {
    return Intl.message(
      'ACTIF',
      name: 'batteryScreenConnected',
      desc: '',
      args: [],
    );
  }

  /// `INACTIF`
  String get batteryScreenDisconnected {
    return Intl.message(
      'INACTIF',
      name: 'batteryScreenDisconnected',
      desc: '',
      args: [],
    );
  }

  /// `Appareil non disponible`
  String get batteryScreenDeviceUnavailable {
    return Intl.message(
      'Appareil non disponible',
      name: 'batteryScreenDeviceUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Page du profil`
  String get profileScreenAppBarTitle {
    return Intl.message(
      'Page du profil',
      name: 'profileScreenAppBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Anniversaire`
  String get profileScreenBirthday {
    return Intl.message(
      'Anniversaire',
      name: 'profileScreenBirthday',
      desc: '',
      args: [],
    );
  }

  /// `Sexe`
  String get profileScreenSex {
    return Intl.message(
      'Sexe',
      name: 'profileScreenSex',
      desc: '',
      args: [],
    );
  }

  /// `Taille`
  String get profileScreenHeight {
    return Intl.message(
      'Taille',
      name: 'profileScreenHeight',
      desc: '',
      args: [],
    );
  }

  /// `Poids`
  String get profileScreenWeight {
    return Intl.message(
      'Poids',
      name: 'profileScreenWeight',
      desc: '',
      args: [],
    );
  }

  /// `Réinitialiser le profil`
  String get profileScreenResetProfile {
    return Intl.message(
      'Réinitialiser le profil',
      name: 'profileScreenResetProfile',
      desc: '',
      args: [],
    );
  }

  /// `Soumettre`
  String get dialogSubmit {
    return Intl.message(
      'Soumettre',
      name: 'dialogSubmit',
      desc: '',
      args: [],
    );
  }

  /// `Enregistrer`
  String get dialogSave {
    return Intl.message(
      'Enregistrer',
      name: 'dialogSave',
      desc: '',
      args: [],
    );
  }

  /// `Nouvel utilisateur...`
  String get profileDialogNewUser {
    return Intl.message(
      'Nouvel utilisateur...',
      name: 'profileDialogNewUser',
      desc: '',
      args: [],
    );
  }

  /// `Utilisateur déjà enregistré`
  String get profileDialogUserAlreadyExists {
    return Intl.message(
      'Utilisateur déjà enregistré',
      name: 'profileDialogUserAlreadyExists',
      desc: '',
      args: [],
    );
  }

  /// `Entrer un nom d'utilisateur`
  String get profileDialogEnterUserName {
    return Intl.message(
      'Entrer un nom d\'utilisateur',
      name: 'profileDialogEnterUserName',
      desc: '',
      args: [],
    );
  }

  /// `Aucun utilisateur choisi`
  String get profileDialogNoUserDefined {
    return Intl.message(
      'Aucun utilisateur choisi',
      name: 'profileDialogNoUserDefined',
      desc: '',
      args: [],
    );
  }

  /// `Homme`
  String get sexDialogMale {
    return Intl.message(
      'Homme',
      name: 'sexDialogMale',
      desc: '',
      args: [],
    );
  }

  /// `Femme`
  String get sexDialogFemale {
    return Intl.message(
      'Femme',
      name: 'sexDialogFemale',
      desc: '',
      args: [],
    );
  }

  /// `Autre`
  String get sexDialogOther {
    return Intl.message(
      'Autre',
      name: 'sexDialogOther',
      desc: '',
      args: [],
    );
  }

  /// `Métrique`
  String get heightWeightDialogMetric {
    return Intl.message(
      'Métrique',
      name: 'heightWeightDialogMetric',
      desc: '',
      args: [],
    );
  }

  /// `Impérial`
  String get heightWeightDialogImperial {
    return Intl.message(
      'Impérial',
      name: 'heightWeightDialogImperial',
      desc: '',
      args: [],
    );
  }

  /// `Pédalier`
  String get groupsetDialogCranksetModel {
    return Intl.message(
      'Pédalier',
      name: 'groupsetDialogCranksetModel',
      desc: '',
      args: [],
    );
  }

  /// `Aucun pédalier sélectionné`
  String get groupsetDialogNoCranksetSelected {
    return Intl.message(
      'Aucun pédalier sélectionné',
      name: 'groupsetDialogNoCranksetSelected',
      desc: '',
      args: [],
    );
  }

  /// `Pignon`
  String get groupsetDialogSproketModel {
    return Intl.message(
      'Pignon',
      name: 'groupsetDialogSproketModel',
      desc: '',
      args: [],
    );
  }

  /// `Aucun pignon sélectionné`
  String get groupsetDialogNoSproketSelected {
    return Intl.message(
      'Aucun pignon sélectionné',
      name: 'groupsetDialogNoSproketSelected',
      desc: '',
      args: [],
    );
  }

  /// `Activé`
  String get customTileEnabled {
    return Intl.message(
      'Activé',
      name: 'customTileEnabled',
      desc: '',
      args: [],
    );
  }

  /// `Désactivé`
  String get customTileDisabled {
    return Intl.message(
      'Désactivé',
      name: 'customTileDisabled',
      desc: '',
      args: [],
    );
  }

  /// `En transition...`
  String get customTileInTransition {
    return Intl.message(
      'En transition...',
      name: 'customTileInTransition',
      desc: '',
      args: [],
    );
  }

  /// `Activé`
  String get sensorButtonEnabled {
    return Intl.message(
      'Activé',
      name: 'sensorButtonEnabled',
      desc: '',
      args: [],
    );
  }

  /// `Désactivé`
  String get sensorButtonDisabled {
    return Intl.message(
      'Désactivé',
      name: 'sensorButtonDisabled',
      desc: '',
      args: [],
    );
  }

  /// `ID`
  String get sensorButtonID {
    return Intl.message(
      'ID',
      name: 'sensorButtonID',
      desc: '',
      args: [],
    );
  }

  /// `Nom`
  String get sensorButtonName {
    return Intl.message(
      'Nom',
      name: 'sensorButtonName',
      desc: '',
      args: [],
    );
  }

  /// `Choisir`
  String get sensorButtonSelect {
    return Intl.message(
      'Choisir',
      name: 'sensorButtonSelect',
      desc: '',
      args: [],
    );
  }

  /// `Paramètre de notification`
  String get notificationSettingDialogTitle {
    return Intl.message(
      'Paramètre de notification',
      name: 'notificationSettingDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `OSS Changement de préférences rapide`
  String get notificationTitle {
    return Intl.message(
      'OSS Changement de préférences rapide',
      name: 'notificationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Appuyer pour accéder au choix des préférences`
  String get notificationInfo {
    return Intl.message(
      'Appuyer pour accéder au choix des préférences',
      name: 'notificationInfo',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'fr', countryCode: 'CA'),
      Locale.fromSubtags(languageCode: 'en', countryCode: 'CA'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}