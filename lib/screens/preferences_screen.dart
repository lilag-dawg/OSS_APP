import 'package:flutter/material.dart';
import '../constants.dart' as Constants;
import '../widgets/lowerNavigationBar.dart';
import '../widgets/slideBarCombo.dart';
import '../databases/preferencesModel.dart';
import '../databases/userPreferencesModesModel.dart';
import '../databases/defaultPreferencesModel.dart';
import '../databases/db.dart';
import '../widgets/blueButton.dart';

class SpecificationScreen extends StatefulWidget {
  final PageController _currentPage;
  final Function selectHandler;
  final int userId;
  final String defaultModeName;
  SpecificationScreen(
      this._currentPage, this.selectHandler, this.userId, this.defaultModeName);

  @override
  _SpecificationScreenState createState() => _SpecificationScreenState();
}

class _SpecificationScreenState extends State<SpecificationScreen> {
  PreferencesModel preferences;
  List<Map<String, Object>> visibleParameterNames;
  Future preferencesFuture;
  Container preferencesList;

  final _minRpm = 70;
  final _maxRpm = 110;

  void _updateSlideBarCombo(
      double newParameterValue, String parameterName) async {
    var preferencesRows = await DatabaseProvider.queryByParameters(
        PreferencesModel.tableName,
        PreferencesModel.primaryKeyWhereString,
        [preferences.preferencesId]);

    if (preferencesRows != null) {
      setState(() {
        preferences = PreferencesModel.fromMap(preferencesRows[0]);
      });
      await DatabaseProvider.updateByPrimaryKey(
          PreferencesModel.tableName,
          preferences,
          PreferencesModel.primaryKeyWhereString,
          preferences.preferencesId);
    }
  }

  void _createSlideBarComboContent() {
    var rpms = [_minRpm.toString()];
    for (var i = _minRpm + 1; i <= _maxRpm; i++) {
      rpms.add(i.toString());
    }

    visibleParameterNames = [
      {
        'name': 'Functional Threshold Power',
        'parameterValue': preferences.ftp,
        'possibleValues': rpms
      },
      {
        'name': 'Target Average Power',
        'parameterValue': preferences.targetEffort,
        'possibleValues': rpms
      },
      {
        'name': 'Shifting Responsiveness',
        'parameterValue': preferences.shiftingResponsiveness,
        'possibleValues': rpms
      },
      {
        'name': 'Desired RPM',
        'parameterValue': preferences.desiredRpm,
        'possibleValues': rpms
      },
      {
        'name': 'Desired BPM',
        'parameterValue': preferences.desiredBpm,
        'possibleValues': rpms
      }
    ];
  }

  Future<void> loadPreferences() async {
    var rows = await DatabaseProvider.queryByParameters(
        UserPreferencesModesModel.tableName,
        UserPreferencesModesModel.primaryKeyWhereString,
        [-1, widget.userId]);

    if (rows != null) {
      int preferencesId;

      for (int i = 0; i < rows.length; i++) {
        if (UserPreferencesModesModel.fromMap(rows[i]).selected == true) {
          preferencesId =
              UserPreferencesModesModel.fromMap(rows[i]).preferencesId;
        }
      }
      if (preferencesId != null) {
        var preferencesRows = await DatabaseProvider.queryByParameters(
            PreferencesModel.tableName,
            PreferencesModel.primaryKeyWhereString,
            [preferencesId]);

        if (preferencesRows != null) {
          preferences = PreferencesModel.fromMap(preferencesRows[0]);
        }
      }
    }
  }

  Future<void> loadDefaultPreferences() async {
    var row = await DatabaseProvider.queryByParameters(
        DefaultPreferencesModel.tableName,
        DefaultPreferencesModel.primaryKeyWhereString,
        [widget.defaultModeName]);

    if (row != null) {
      var defaultPreferencesRow = await DatabaseProvider.queryByParameters(
          PreferencesModel.tableName,
          PreferencesModel.primaryKeyWhereString,
          [DefaultPreferencesModel.fromMap(row[0]).preferencesId]);

      if (defaultPreferencesRow != null) {
        preferences = PreferencesModel.fromMap(defaultPreferencesRow[0]);
        preferences.preferencesId = null;
      }
    } else {
      preferences = new PreferencesModel(
          ftp: 0,
          targetEffort: 0,
          shiftingResponsiveness: 0,
          desiredRpm: 0,
          desiredBpm: 0);
    }
    await DatabaseProvider.insert(PreferencesModel.tableName, preferences);
    var rows = await DatabaseProvider.query(
        PreferencesModel.tableName); // get preferencesId
    if (rows != null) {
      preferences = PreferencesModel.fromMap(rows.last);
    } else {
      preferences = null; //make it crash (temporary)
    }

    var userPreferencesMode = new UserPreferencesModesModel( //assumes no other selected is true
        userId: widget.userId,
        preferencesId: preferences.preferencesId,
        selected: true,
        modeName: 'User Mode 1');
    
    await DatabaseProvider.insert(UserPreferencesModesModel.tableName, userPreferencesMode);
  }

  Future<void> resetProfileDb() async {}

  Future<void> setPreferences() async {
    preferences = null;

    await loadPreferences();
    if (preferences == null) {
      await loadDefaultPreferences();
    }
  }

  Future<void> buildLayout() async {
    await setPreferences();
    _createSlideBarComboContent();

    double spaceTopItem = 30;
    double spaceItem1Item2 = 35;

    preferencesList = Container(
      margin: EdgeInsets.only(left: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: spaceTopItem),
            SlideBarCombo(
                visibleParameterNames[0]['name'],
                visibleParameterNames[0]['possibleValues'],
                visibleParameterNames[0]['parameterValue'],
                _updateSlideBarCombo),
            SizedBox(height: spaceItem1Item2),
            SlideBarCombo(
                visibleParameterNames[1]['name'],
                visibleParameterNames[1]['possibleValues'],
                visibleParameterNames[1]['parameterValue'],
                _updateSlideBarCombo),
            SizedBox(height: spaceItem1Item2),
            SlideBarCombo(
                visibleParameterNames[2]['name'],
                visibleParameterNames[2]['possibleValues'],
                visibleParameterNames[2]['parameterValue'],
                _updateSlideBarCombo),
            SizedBox(height: Constants.appHeight * 0.1),
            BlueButton('Reset Profile', resetProfileDb, Icons.delete, 70,
                Constants.appWidth - 50),
            SizedBox(height: Constants.appHeight * 0.03),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    preferencesFuture = buildLayout();
  }

  Widget futureBody() {
    return FutureBuilder<void>(
      future: preferencesFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            return preferencesList;
          default:
            return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: LowerNavigationBar(
          widget._currentPage, context, widget.selectHandler),
      backgroundColor: Color(Constants.backGroundBlue),
      appBar: AppBar(
          backgroundColor: Color(Constants.blueButtonColor),
          title: Text("Preferences page")),
      body: futureBody(),
    );
  }
}
