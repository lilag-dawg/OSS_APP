import 'dart:async';
import '../constants.dart' as Constants;
import '../databases/userProfileModel.dart';
import '../databases/db.dart';
import '../databases/userPreferencesModesModel.dart';
import '../databases/preferencesModel.dart';

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

  static Future<void> createUser(String userName) async {
    var userRow =
        UserProfileModel(userName: userName, selected: Constants.isSelected);
    await DatabaseProvider.insert(UserProfileModel.tableName, userRow);

    await DatabaseHelper.selectUser(userName);
    //TODO : check errors
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

  static Future<void> selectPreferencesMode(String modeName) async {
    var profile = await DatabaseHelper.getSelectedUserProfile();
    var rows = await DatabaseProvider.queryByParameters(
        UserPreferencesModesModel.tableName,
        UserPreferencesModesModel.userWhereString,
        [profile.userName]);

    if (rows.length != 0) {
      rows.forEach((i) async {
        var mode = UserPreferencesModesModel.fromMap(i);
        mode.selected = mode.modeName == modeName
            ? Constants.isSelected
            : Constants.isNotSelected;
        await DatabaseProvider.updateByPrimaryKey(
            UserPreferencesModesModel.tableName,
            mode,
            UserPreferencesModesModel.preferencesWhereString,
            mode.preferencesId);
      });
    }
  }

  static Future<List<String>> getPreferencesModesNames() async {
    var profile = await DatabaseHelper.getSelectedUserProfile();

    var rows = await DatabaseProvider.queryByParameters(
        UserPreferencesModesModel.tableName,
        UserPreferencesModesModel.userWhereString,
        [profile.userName]);

    List<String> list = [];

    if (rows.length != 0) {
      rows.forEach((i) {
        list.add(UserPreferencesModesModel.fromMap(i).modeName);
      });
    }
    return list;
  }

  static Future<PreferencesModel> createDefaultPreferencesRow() async {
    var preferences = new PreferencesModel(
        ftp: Constants.defaultFtp,
        targetEffort: Constants.defaultTargetEffort,
        shiftingResponsiveness: Constants.defaultShiftingResponsiveness,
        desiredRpm: Constants.defaultDesiredRpm,
        desiredBpm: Constants.defaultDesiredBpm);

    await DatabaseProvider.insert(PreferencesModel.tableName, preferences);
    var rows = await DatabaseProvider.query(
        PreferencesModel.tableName); // get preferencesId
    if (rows.length != 0) {
      return PreferencesModel.fromMap(rows.last);
    }

    return null;
  }

  static Future<UserPreferencesModesModel> createPreferencesMode(
      String modeName, PreferencesModel preferences) async {
    var profile = await DatabaseHelper.getSelectedUserProfile();
    var modeRow = UserPreferencesModesModel(
        userName: profile.userName,
        preferencesId: preferences.preferencesId,
        selected: Constants.isSelected,
        modeName: modeName);
    await DatabaseProvider.insert(UserPreferencesModesModel.tableName, modeRow);

    await DatabaseHelper.selectPreferencesMode(modeName);

    return modeRow;

    //TODO : check errors
  }
}
