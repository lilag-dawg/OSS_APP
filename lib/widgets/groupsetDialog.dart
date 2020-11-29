import 'package:flutter/material.dart';
import '../databases/dbHelper.dart';
import '../constants.dart' as Constants;
import '../generated/l10n.dart';

class GroupsetDialog extends StatefulWidget {
  GroupsetDialog();
  @override
  State<StatefulWidget> createState() {
    return GroupsetDialogDialogState();
  }
}

class GroupsetDialogDialogState extends State<GroupsetDialog> {
  var userNameController = TextEditingController();
  final userNameKey = GlobalKey<FormState>();
  Column profileDialog;

  Future<void> buildLayout() async {
    var listCranksets = await DatabaseHelper.getCranksets();
    var listSprockets = await DatabaseHelper.getSprockets();
    var currentPreferences = await DatabaseHelper.getCurrentPreferences();

    profileDialog = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            S.of(context).groupsetDialogCranksetModel + ' :',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          DropdownButton(
            isExpanded: true,
            iconSize: 20,
            icon: Icon(Icons.arrow_downward),
            value: currentPreferences == null
                ? S.of(context).groupsetDialogNoCranksetSelected
                : currentPreferences.cranksetName,
            items: listCranksets.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String newValue) async {
              currentPreferences.cranksetName = newValue;
              await DatabaseHelper.updatePreferences(currentPreferences);
              setState(() {});
              //Navigator.of(context, rootNavigator: true).pop(true);
            },
          ),
          SizedBox(height: 20),
          Text(
            S.of(context).groupsetDialogSproketModel + ' :',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          DropdownButton(
            isExpanded: true,
            iconSize: 20,
            icon: Icon(Icons.arrow_downward),
            value: currentPreferences == null
                ? S.of(context).groupsetDialogNoSproketSelected
                : currentPreferences.sprocketName,
            items: listSprockets.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String newValue) async {
              currentPreferences.sprocketName = newValue;
              await DatabaseHelper.updatePreferences(currentPreferences);
              setState(() {});
              //Navigator.of(context, rootNavigator: true).pop(true);
            },
          ),
          RaisedButton(
            child: Text(S.of(context).dialogSubmit),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(true);
            },
          ),
        ]);
  }

  Widget futureBody() {
    return FutureBuilder<void>(
      future: buildLayout(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Constants.dialogLoadingWidget;
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Constants.dialogLoadingWidget;
          case ConnectionState.done:
            return profileDialog;
          default:
            return Constants.dialogLoadingWidget;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: futureBody(),
    );
  }
}
