import 'package:flutter/material.dart';
import '../databases/dbHelper.dart';
import '../constants.dart' as Constants;
import '../databases/userProfileModel.dart';
import '../generated/l10n.dart';

class ProfileDialog extends StatefulWidget {
  ProfileDialog();
  @override
  State<StatefulWidget> createState() {
    return ProfileDialogState();
  }
}

class ProfileDialogState extends State<ProfileDialog> {
  final userNameController = TextEditingController();
  final userNameKey = GlobalKey<FormState>();
  Column profileDialog;

  Future<void> buildLayout() async {
    var list = await DatabaseHelper.getUsers();
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
                      hintText: S.of(context).profileDialogNewUser,
                    ),
                    validator: (userName) {
                      if (userName.isEmpty) {
                        return S.of(context).profileDialogEnterUserName;
                      }
                      if (list.any((user) => user.userName == userName)) {
                        return S.of(context).profileDialogUserAlreadyExists;
                      }
                      return null;
                    },
                  ),
                  RaisedButton(
                    child: Text(S.of(context).dialogSubmit),
                    onPressed: () async {
                      if (userNameKey.currentState.validate()) {
                        await DatabaseHelper.createUser(
                            userNameController.text);
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
            value: currentUser == null
                ? S.of(context).profileDialogNoUserDefined
                : currentUser.userName,
            items: list.map<DropdownMenuItem<String>>((UserProfileModel user) {
              return DropdownMenuItem<String>(
                value: user.userName,
                child: Text(user.userName),
              );
            }).toList(),
            onChanged: (String newValue) async {
              await DatabaseHelper.selectUser(newValue);
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
                    if (userNameKey.currentState.validate()) {
                      var oldUserName = currentUser.userName;
                      currentUser.userName = userNameController.text;
                      await DatabaseHelper.updateUser(currentUser, oldUserName);
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                  },
                ),
                SizedBox(width: 10),
                RaisedButton(
                    child: Text("Delete"),
                    onPressed: () async {
                      await DatabaseHelper.deleteUser(currentUser.userName);

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
