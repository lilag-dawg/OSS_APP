// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en_CA locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en_CA';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "batteryScreenAppBarTitle" : MessageLookupByLibrary.simpleMessage("Battery Page"),
    "batteryScreenCompatible" : MessageLookupByLibrary.simpleMessage("CONNECTED"),
    "batteryScreenDeviceManagement" : MessageLookupByLibrary.simpleMessage("Manage Devices"),
    "batteryScreenDeviceUnavailable" : MessageLookupByLibrary.simpleMessage("Battery unavailable"),
    "batteryScreenIncompatible" : MessageLookupByLibrary.simpleMessage("INCOMPATIBLE"),
    "calibrationScreenAppBarTitle" : MessageLookupByLibrary.simpleMessage("Calibration Page"),
    "customTileDisabled" : MessageLookupByLibrary.simpleMessage("Disabled"),
    "customTileEnabled" : MessageLookupByLibrary.simpleMessage("Enabled"),
    "customTileInTransition" : MessageLookupByLibrary.simpleMessage("In transition..."),
    "dialogSave" : MessageLookupByLibrary.simpleMessage("Save"),
    "dialogSubmit" : MessageLookupByLibrary.simpleMessage("Submit"),
    "findDeviceScreenAppBarTitle" : MessageLookupByLibrary.simpleMessage("Manage Devices Page"),
    "findDeviceScreenCurrentlyLooking" : MessageLookupByLibrary.simpleMessage("Search in progress..."),
    "findDeviceScreenLookingFor" : MessageLookupByLibrary.simpleMessage("Search for OSS"),
    "findDeviceScreenSearchLater" : MessageLookupByLibrary.simpleMessage("Search later"),
    "groupsetDialogCranksetModel" : MessageLookupByLibrary.simpleMessage("Crankset"),
    "groupsetDialogNoCranksetSelected" : MessageLookupByLibrary.simpleMessage("No crankset selected"),
    "groupsetDialogNoSproketSelected" : MessageLookupByLibrary.simpleMessage("No sproket selected"),
    "groupsetDialogSproketModel" : MessageLookupByLibrary.simpleMessage("Sproket"),
    "heightWeightDialogImperial" : MessageLookupByLibrary.simpleMessage("Imperial"),
    "heightWeightDialogMetric" : MessageLookupByLibrary.simpleMessage("Metric"),
    "homeScreenAppBarTitle" : MessageLookupByLibrary.simpleMessage("Home Page"),
    "homeScreenBatteryLevel" : MessageLookupByLibrary.simpleMessage("Battery"),
    "homeScreenCalibration" : MessageLookupByLibrary.simpleMessage("Calibration"),
    "homeScreenPreferences" : MessageLookupByLibrary.simpleMessage("Preferences"),
    "homeScreenProfile" : MessageLookupByLibrary.simpleMessage("Profile"),
    "homeScreenSettings" : MessageLookupByLibrary.simpleMessage("Settings"),
    "homeScreenStatistics" : MessageLookupByLibrary.simpleMessage("Statistics"),
    "infoDialogClose" : MessageLookupByLibrary.simpleMessage("Close"),
    "manageDeviceScreenActive" : MessageLookupByLibrary.simpleMessage("Active - Tap for information"),
    "manageDeviceScreenBattery" : MessageLookupByLibrary.simpleMessage("Battery"),
    "manageDeviceScreenCadence" : MessageLookupByLibrary.simpleMessage("Cadence"),
    "manageDeviceScreenConnected" : MessageLookupByLibrary.simpleMessage("Connected devices"),
    "manageDeviceScreenForget" : MessageLookupByLibrary.simpleMessage("Forget"),
    "manageDeviceScreenGear" : MessageLookupByLibrary.simpleMessage("Gear"),
    "manageDeviceScreenListOfFeatures" : MessageLookupByLibrary.simpleMessage("List of supported features"),
    "manageDeviceScreenNotOSS" : MessageLookupByLibrary.simpleMessage("Device is not OSS"),
    "manageDeviceScreenPair" : MessageLookupByLibrary.simpleMessage("Pair"),
    "manageDeviceScreenPaired" : MessageLookupByLibrary.simpleMessage("Paired devices"),
    "manageDeviceScreenPower" : MessageLookupByLibrary.simpleMessage("Power"),
    "manageDeviceScreenSpeed" : MessageLookupByLibrary.simpleMessage("Speed"),
    "notificationInfo" : MessageLookupByLibrary.simpleMessage("Press to acccess the preference selection page"),
    "notificationSettingDialogTitle" : MessageLookupByLibrary.simpleMessage("Notification settings"),
    "notificationTitle" : MessageLookupByLibrary.simpleMessage("OSS Quick preference change"),
    "preferenceModeDialogAlreadyExists" : MessageLookupByLibrary.simpleMessage("Mode already exists"),
    "preferenceModeDialogEnterMode" : MessageLookupByLibrary.simpleMessage("No modes entered"),
    "preferenceModeDialogNewMode" : MessageLookupByLibrary.simpleMessage("New mode..."),
    "preferenceModeDialogNoModeSelected" : MessageLookupByLibrary.simpleMessage("No mode selected"),
    "preferencesScreenAppBarTitle" : MessageLookupByLibrary.simpleMessage("Preferences Page"),
    "preferencesScreenAveragePower" : MessageLookupByLibrary.simpleMessage("Target Average Power"),
    "preferencesScreenAveragePowerInfo" : MessageLookupByLibrary.simpleMessage("Target average power for an hour-long session"),
    "preferencesScreenDesiredBPM" : MessageLookupByLibrary.simpleMessage("Desired BPM"),
    "preferencesScreenDesiredBPMInfo" : MessageLookupByLibrary.simpleMessage("Desired average heartbeats per minute"),
    "preferencesScreenDesiredRPM" : MessageLookupByLibrary.simpleMessage("Desired RPM"),
    "preferencesScreenDesiredRPMInfo" : MessageLookupByLibrary.simpleMessage("Desired average rotations per minute (cadence) for the bicycle crankset"),
    "preferencesScreenResetProfile" : MessageLookupByLibrary.simpleMessage("Reset preferences"),
    "preferencesScreenResponsiveness" : MessageLookupByLibrary.simpleMessage("Shifting Responsiveness"),
    "preferencesScreenResponsivenessInfo" : MessageLookupByLibrary.simpleMessage("Defines the delta of rotations per minute (versus the desired cadence) necessary to trigger a shift"),
    "preferencesScreenSelectGroupset" : MessageLookupByLibrary.simpleMessage("Select groupset"),
    "preferencesScreenThresholdPower" : MessageLookupByLibrary.simpleMessage("Functional Threshold Power"),
    "preferencesScreenThresholdPowerInfo" : MessageLookupByLibrary.simpleMessage("Maximum average power for an hour-long session"),
    "profileDialogEnterUserName" : MessageLookupByLibrary.simpleMessage("Enter a user name"),
    "profileDialogNewUser" : MessageLookupByLibrary.simpleMessage("New user..."),
    "profileDialogNoUserDefined" : MessageLookupByLibrary.simpleMessage("No user selected"),
    "profileDialogUserAlreadyExists" : MessageLookupByLibrary.simpleMessage("User already exists"),
    "profileScreenAppBarTitle" : MessageLookupByLibrary.simpleMessage("Profile Page"),
    "profileScreenBirthday" : MessageLookupByLibrary.simpleMessage("Birthday"),
    "profileScreenHeight" : MessageLookupByLibrary.simpleMessage("Height"),
    "profileScreenResetProfile" : MessageLookupByLibrary.simpleMessage("Reset profile"),
    "profileScreenSex" : MessageLookupByLibrary.simpleMessage("Sex"),
    "profileScreenWeight" : MessageLookupByLibrary.simpleMessage("Weight"),
    "sensorButtonDisabled" : MessageLookupByLibrary.simpleMessage("Discabled"),
    "sensorButtonEnabled" : MessageLookupByLibrary.simpleMessage("Enabled"),
    "sensorButtonID" : MessageLookupByLibrary.simpleMessage("ID"),
    "sensorButtonName" : MessageLookupByLibrary.simpleMessage("Name"),
    "sensorButtonSelect" : MessageLookupByLibrary.simpleMessage("Select"),
    "settingsScreenAppBarTitle" : MessageLookupByLibrary.simpleMessage("Settings Page"),
    "settingsScreenDeviceManagement" : MessageLookupByLibrary.simpleMessage("Device Management"),
    "settingsScreenFacebook" : MessageLookupByLibrary.simpleMessage("Facebook"),
    "settingsScreenLogout" : MessageLookupByLibrary.simpleMessage("Log Out"),
    "settingsScreenNotifications" : MessageLookupByLibrary.simpleMessage("Notifications"),
    "settingsScreenShare" : MessageLookupByLibrary.simpleMessage("Share"),
    "sexDialogFemale" : MessageLookupByLibrary.simpleMessage("Female"),
    "sexDialogMale" : MessageLookupByLibrary.simpleMessage("Male"),
    "sexDialogOther" : MessageLookupByLibrary.simpleMessage("Other"),
    "statisticsManageDevices" : MessageLookupByLibrary.simpleMessage("Manage devices"),
    "statisticsNoDeviceConnected" : MessageLookupByLibrary.simpleMessage("No device connected"),
    "statisticsScreenAppBarTitle" : MessageLookupByLibrary.simpleMessage("Statistics Page"),
    "stopwatchReset" : MessageLookupByLibrary.simpleMessage("Reset"),
    "stopwatchStart" : MessageLookupByLibrary.simpleMessage("Start"),
    "stopwatchStop" : MessageLookupByLibrary.simpleMessage("Stop")
  };
}
