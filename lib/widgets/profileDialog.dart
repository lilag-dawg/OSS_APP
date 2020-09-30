import 'package:flutter/material.dart';
import 'package:oss_app/databases/db.dart';
import 'package:oss_app/databases/userProfileModel.dart';
import '../constants.dart' as Constants;
import '../databases/dbHelper.dart';

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

  Future<void> createUser() async {
    var userRow = UserProfileModel(
        userName: userNameController.text, selected: Constants.isSelected);
    await DatabaseProvider.insert(UserProfileModel.tableName, userRow);

    await DatabaseHelper.selectUser(userNameController.text);
    //TODO : check errors
  }

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
                      //errorText: validateUserName(userNameController.text)
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
                        await createUser();
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
            return Center(child: CircularProgressIndicator());
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            return profileDialog;
          default:
            return Center(child: CircularProgressIndicator());
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
