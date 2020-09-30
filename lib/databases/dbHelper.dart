import 'dart:async';
import '../constants.dart' as Constants;
import '../databases/userProfileModel.dart';
import '../databases/db.dart';
import '../databases/userPreferencesModesModel.dart';

abstract class DatabaseHelper {
  static Future<UserProfileModel> getSelectedUserProfile() async {
    var userRow = await DatabaseProvider.queryByParameters(
        UserProfileModel.tableName,
        UserProfileModel.getSelectedString,
        [Constants.isSelected]);

    if (userRow.length == 0) {
      return null;
    } else {
      return UserProfileModel.fromMap(userRow.first);
    }
  }

  static Future<void> selectUser(String userName) async {
    var userRows = await DatabaseProvider.query(UserProfileModel.tableName);

    if (userRows.length != 0) {
      userRows.forEach((i) async {
        var user = UserProfileModel.fromMap(i);
        user.selected = user.userName == userName
            ? Constants.isSelected
            : Constants.isNotSelected;
        await DatabaseProvider.updateByPrimaryKey(UserProfileModel.tableName,
            user, UserProfileModel.primaryKeyWhereString, user.userName);
      });
    }
  }

  static Future<List<String>> getUserNames() async {
    var userRows = await DatabaseProvider.query(UserProfileModel.tableName);
    List<String> list = [];

    if (userRows.length != 0) {
      userRows.forEach((i) {
        list.add(UserProfileModel.fromMap(i).userName);
      });
    }

    return list;
  }

  static Future<UserPreferencesModesModel> getSelectedPreferencesMode() async {
    var profile = await DatabaseHelper.getSelectedUserProfile();
    var rows = await DatabaseProvider.queryByParameters(
        UserPreferencesModesModel.tableName,
        UserPreferencesModesModel.userWhereString,
        [profile.userName]);

    if (rows.length != 0) {
      for (int i = 0; i < rows.length; i++) {
        if (UserPreferencesModesModel.fromMap(rows[i]).selected ==
            Constants.isSelected) {
          return UserPreferencesModesModel.fromMap(rows[i]);
        }
      }
    }
    return null;
  }
}
