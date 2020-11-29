import 'package:flutter/material.dart';
import '../generated/l10n.dart';
import '../databases/dbHelper.dart';
import '../constants.dart' as Constants;
import '../databases/userPreferencesModesModel.dart';

class UserPreferencesModesDialog extends StatefulWidget {
  UserPreferencesModesDialog();
  @override
  State<StatefulWidget> createState() {
    return UserPreferencesModesDialogState();
  }
}

class UserPreferencesModesDialogState
    extends State<UserPreferencesModesDialog> {
  var nameController = TextEditingController();
  final nameKey = GlobalKey<FormState>();
  Column modeDialog;

  Future<void> buildLayout() async {
    var list = await DatabaseHelper.getUserPreferencesModes();
    var currentSelection = await DatabaseHelper.getSelectedPreferencesMode();

    modeDialog = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Form(
              key: nameKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: nameController,
                    maxLength: 30,
                    decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: S.of(context).preferenceModeDialogNewMode,
                    ),
                    validator: (name) {
                      if (name.isEmpty) {
                        return S.of(context).preferenceModeDialogEnterMode;
                      }
                      if (list.any((i) => i.modeName == name)) {
                        return S.of(context).preferenceModeDialogAlreadyExists;
                      }
                      return null;
                    },
                  ),
                  RaisedButton(
                    child: Text(S.of(context).dialogSubmit),
                    onPressed: () async {
                      if (nameKey.currentState.validate()) {
                        var preferences =
                            await DatabaseHelper.createDefaultPreferencesRow();
                        await DatabaseHelper.createPreferencesMode(
                            nameController.text, preferences);
                        Navigator.of(context, rootNavigator: true).pop();
                      }
                    },
                  ),
                ],
              )),
          DropdownButton(
            isExpanded: true,
            iconSize: 20,
            icon: Icon(Icons.arrow_downward),
            value: currentSelection == null
                ? S.of(context).preferenceModeDialogNoModeSelected
                : currentSelection.modeName,
            items: list.map<DropdownMenuItem<String>>(
                (UserPreferencesModesModel mode) {
              return DropdownMenuItem<String>(
                value: mode.modeName,
                child: Text(mode.modeName),
              );
            }).toList(),
            onChanged: (String newValue) async {
              await DatabaseHelper.selectPreferencesMode(newValue);
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text("Rename"),
                  onPressed: () async {
                    if (nameKey.currentState.validate()) {
                      currentSelection.modeName = nameController.text;
                      await DatabaseHelper.updatePreferencesMode(
                          currentSelection);
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                  },
                ),
                SizedBox(width: 10),
                RaisedButton(
                    child: Text("Delete"),
                    onPressed: () async {
                      await DatabaseHelper.deletePreferencesMode(
                          currentSelection.preferencesId);

                      Navigator.of(context, rootNavigator: true).pop();
                    }),
              ]),
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
            return modeDialog;
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
