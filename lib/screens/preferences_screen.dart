import 'package:flutter/material.dart';
import '../constants.dart' as Constants;
import '../widgets/lowerNavigationBar.dart';
import '../widgets/slideBarCombo.dart';
import '../databases/db_preferences_model.dart';
import '../databases/db.dart';
import '../widgets/blueButton.dart';

var _db = new 
    DB(dbFormat: PreferencesModel.dbFormat, dbName: PreferencesModel.dbName);

class SpecificationScreen extends StatefulWidget {
  final PageController _currentPage;
  final Function selectHandler;
  SpecificationScreen(this._currentPage, this.selectHandler);

  @override
  _SpecificationScreenState createState() => _SpecificationScreenState();
}

class _SpecificationScreenState extends State<SpecificationScreen> {
  List<Map<String, Object>> sliderStepsMap;

  final _minRpm = 70;
  final _maxRpm = 110;

  var _shiftingResponsiveness = PreferencesModel(
      parameter: 'Shifting Responsiveness', parameterValue: null);

  var _desiredRpm =
      PreferencesModel(parameter: 'Desired RPM', parameterValue: null);

  var _intensityZone =
      PreferencesModel(parameter: 'Intensity Zone', parameterValue: null);

  void _updateSlideBarCombo(double newValue, String parameter) {
    setState(() {
      if (_shiftingResponsiveness.parameter == parameter) {
        _shiftingResponsiveness.parameterValue = newValue.toInt();
        _saveParameter(_shiftingResponsiveness);
      }
      if (_desiredRpm.parameter == parameter) {
        _desiredRpm.parameterValue = newValue.toInt();
        _saveParameter(_desiredRpm);
      }
      if (_intensityZone.parameter == parameter) {
        _intensityZone.parameterValue = newValue.toInt();
        _saveParameter(_intensityZone);
      }
    });
  }

  void _createStrings() {
    var rpms = [_minRpm.toString()];
    for (var i = _minRpm + 1; i <= _maxRpm; i++) {
      rpms.add(i.toString());
    }

    sliderStepsMap = [
      {
        'typeOfData': 'Shifting Responsiveness',
        'selectionMenu': ['Low', 'medium', 'High', 'Very high']
      },
      {
        'typeOfData': 'Desired RPM',
        'selectionMenu': rpms,
      },
      {
        'typeOfData': 'Intensity Zone',
        'selectionMenu': ['Zone 1', 'Zone 2', 'Zone 3', 'Zone 4', 'Zone 5']
      },
    ];
  }

  Future<void> _saveParameter(PreferencesModel parameter) async {
    if (await _db.queryByParameter(
            PreferencesModel.dbName, parameter.parameter) ==
        null) {
      await _db.insert(PreferencesModel.dbName, parameter);
    } else {
      await _db.updateByParameter(PreferencesModel.dbName, parameter);
    }
  }

  Future<void> _saveProfileDb() async {
    await _saveParameter(_shiftingResponsiveness);
    await _saveParameter(_desiredRpm);
    await _saveParameter(_intensityZone);
  }

  Future<PreferencesModel> _loadParameter(PreferencesModel parameter) async {
    var loadedParameter = await _db.queryByParameter(
        PreferencesModel.dbName, parameter.parameter);

    if (loadedParameter != null) {
      return PreferencesModel.fromMap(loadedParameter);
    } else {
      return parameter;
    }
  }

  Future<void> _loadProfileDb() async {
    await _db.init();
    _shiftingResponsiveness = await _loadParameter(_shiftingResponsiveness);
    _desiredRpm = await _loadParameter(_desiredRpm);
    _intensityZone = await _loadParameter(_intensityZone);

    _setToDefault();
    await _saveProfileDb();
  }

  void _setToDefault() {
    _shiftingResponsiveness.parameterValue =
        _shiftingResponsiveness.parameterValue != null
            ? _shiftingResponsiveness.parameterValue
            : (((sliderStepsMap[0]['selectionMenu'] as List<String>)
                        .length
                        .toDouble() -
                    1) ~/
                2);
    _desiredRpm.parameterValue =
        _desiredRpm.parameterValue != null
            ? _desiredRpm.parameterValue
            : (((sliderStepsMap[1]['selectionMenu'] as List<String>)
                        .length
                        .toDouble() -
                    1) ~/
                2);
    _intensityZone.parameterValue =
        _intensityZone.parameterValue != null
            ? _intensityZone.parameterValue
            : (((sliderStepsMap[2]['selectionMenu'] as List<String>)
                        .length
                        .toDouble() -
                    1) ~/
                2);
  }

  void _resetProfileDb() async {
    await _db.delete(PreferencesModel.dbName);
    setState(() {
      _shiftingResponsiveness = PreferencesModel(
          parameter: 'Shifting Responsiveness', parameterValue: null);

      _desiredRpm =
          PreferencesModel(parameter: 'Desired RPM', parameterValue: null);

      _intensityZone =
          PreferencesModel(parameter: 'Intensity Zone', parameterValue: null);
    });
    _setToDefault();
    await _saveProfileDb();
  }

  @override
  void initState() {
    super.initState();
    _loadProfileDb().then((_) => setState(() {
          _shiftingResponsiveness = _shiftingResponsiveness;
        }));
  }

  @override
  Widget build(BuildContext context) {
    double spaceTopItem = 30;
    double spaceItem1Item2 = 35;

    _createStrings();

    return Scaffold(
      bottomNavigationBar: LowerNavigationBar(
          widget._currentPage, context, widget.selectHandler),
      backgroundColor: Color(Constants.backGroundBlue),
      appBar: AppBar(
          backgroundColor: Color(Constants.blueButtonColor),
          title: Text("Preferences page")),
      body: Container(
        margin: EdgeInsets.only(left: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: spaceTopItem),
              SlideBarCombo(sliderStepsMap[0], _updateSlideBarCombo,
                  _shiftingResponsiveness),
              SizedBox(height: spaceItem1Item2),
              SlideBarCombo(
                  sliderStepsMap[1], _updateSlideBarCombo, _desiredRpm),
              SizedBox(height: spaceItem1Item2),
              SlideBarCombo(
                  sliderStepsMap[2], _updateSlideBarCombo, _intensityZone),
              SizedBox(height: Constants.appHeight * 0.1),
              BlueButton('Reset Profile', _resetProfileDb, Icons.delete, 70,
                  Constants.appWidth - 50),
              SizedBox(height: Constants.appHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
