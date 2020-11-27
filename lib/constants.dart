library constants;

import 'package:flutter/material.dart';

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

//profileScreen
const String defaultProfileName = 'New User';

//PreferencesScreen
const String defaultPreferencesModeName = 'Medium Intensity';
const int defaultFtp = 200;
const double defaultShiftingResponsiveness = 1.0;
const int defaultDesiredRpm = 90;
const int defaultDesiredBpm = 150;
const String defaultCranksetName = null;
const String defaultSprocketName = null;

const int minFtp = 50;
const double minShiftingResponsiveness = 0.2;
const int minDesiredRpm = 40;
const int minDesiredBpm = 70;

const int maxFtp = 500;
const double maxShiftingResponsiveness = 5.0;
const int maxDesiredRpm = 150;
const int maxDesiredBpm = 220;

const String ftpInfo = 'Maximum average power for an hour-long session';
const String shiftingResponsivenessInfo =
    'Defines the delta of rotations per minute (versus the desired cadence) necessary to trigger a shift';
const String desiredRpmInfo =
    'Desired average rotations per minute (cadence) for the bicycle crankset';
const String desiredBpmInfo = 'Desired average heartbeats per minute';

Column dialogLoadingWidget = Column(
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[CircularProgressIndicator()],
  mainAxisAlignment: MainAxisAlignment.center,
);

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
