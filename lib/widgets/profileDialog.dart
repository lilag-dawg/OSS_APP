import 'package:flutter/material.dart';
import 'package:oss_app/databases/db.dart';
import 'package:oss_app/databases/userProfileModel.dart';
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

  Future <void> createUser() async {
    var userRow = UserProfileModel(userName: userNameController.text, selected: Constants.isSelected);
    DatabaseProvider.insert(UserProfileModel.tableName, userRow);
    //TODO : check errors
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                    controller: userNameController,
                    maxLength: 30,
                    decoration: InputDecoration(
                        icon: Icon(Icons.person), hintText: 'User Name'),
                    onSaved: (String userName) {
                      //
                      print('test');
                    }),
                RaisedButton(
                  child: Text("Submit"),
                  onPressed: () async {await createUser();
                  Navigator.of(context, rootNavigator: true).pop(true);},
                  
                ),
              ]),
        ],
      ),
    );
  }
}
