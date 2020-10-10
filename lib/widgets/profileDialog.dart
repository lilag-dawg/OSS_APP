import 'package:flutter/material.dart';
import '../databases/dbHelper.dart';
import '../constants.dart' as Constants;

class ProfileDialog extends StatefulWidget {
  ProfileDialog();
  @override
  State<StatefulWidget> createState() {
    return ProfileDialogState();
  }
}

class ProfileDialogState extends State<ProfileDialog> {
  var userNameController = TextEditingController();
  final userNameKey = GlobalKey<FormState>();
  Column profileDialog;

  Future<void> buildLayout() async {
    var list = await DatabaseHelper.getUserNames();
    var currentUser = await DatabaseHelper.getSelectedUserProfile();

    profileDialog = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Form(
              key: userNameKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: userNameController,
                    maxLength: 30,
                    decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: 'New User Name',
                    ),
                    validator: (userName) {
                      if (userName.isEmpty) {
                        return 'Please enter some text';
                      }
                      if (list.any((i) => i == userName)) {
                        return 'User name already exists';
                      }
                      return null;
                    },
                  ),
                  RaisedButton(
                    child: Text("Submit"),
                    onPressed: () async {
                      if (userNameKey.currentState.validate()) {
                        await DatabaseHelper.createUser(
                            userNameController.text);
                        Navigator.of(context, rootNavigator: true).pop(true);
                      }
                    },
                  ),
                ],
              )),
          DropdownButton(
            isExpanded: true,
            iconSize: 20,
            icon: Icon(Icons.arrow_downward),
            value: currentUser == null
                ? 'No User Currently Defined'
                : currentUser.userName,
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String newValue) async {
              await DatabaseHelper.selectUser(newValue);
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
