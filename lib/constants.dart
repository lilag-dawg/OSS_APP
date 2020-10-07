library constants;

//import 'dart:js';

//const double appWidth = 410;
//const double appHeight = 700;

double _appWidth;
double _appHeight;

const int blueButtonColor = 0xFF1565C0;
const int backGroundBlue = 0xFF0D47A1;

const int defaultPageIndex = 1;

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
