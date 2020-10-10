library constants;

//import 'dart:js';

//const double appWidth = 410;
//const double appHeight = 700;

double _appWidth;
double _appHeight;

const int blueButtonColor = 0xFF1565C0;
const int greyButtonColor = 0xFF252525;
const int backGroundBlue = 0xFF0D47A1;

const int defaultPageIndex = 1;

// emulator
final bool isWorkingOnEmulator = false;
const int isSelected = 1;
const int isNotSelected = 0;

//HeightWeightDialog
const double defaultWeight = 70.0;
const double defaultHeight = 175.0;

const double poundsToKg = 0.454;
const double inchToCm = 2.54;
const double footToCm = 30.48;
const int maxKg = 200;
const int minKg = 20;
const int maxCm = 250;
const int minCm = 50;

//PreferencesScreen
const String defaultPreferencesModeName = 'Medium Intensity';
const int defaultFtp = 200;
const int defaultTargetEffort = 150;
const int defaultShiftingResponsiveness = 10;
const int defaultDesiredRpm = 90;
const int defaultDesiredBpm = 150;

const String ftpInfo = 'Maximum average power for an hour-long session';
const String targetEffortInfo = 'Target average power for an hour-long session';
const String shiftingResponsivenessInfo =
    'Defines the delta of rotations per minute (versus the desired cadence) necessary to trigger a shift';
const String desiredRpmInfo =
    'Desired average rotations per minute (cadence) for the bicycle crankset';
const String desiredBpmInfo = 'Desired average heartbeats per minute';

double getAppWidth() {
  return _appWidth;
}

void setAppWidth(double newWidth) {
  _appWidth = newWidth;
}

double getAppHeight() {
  return _appHeight;
}

void setAppHeight(double newHeight) {
  _appHeight = newHeight;
}
