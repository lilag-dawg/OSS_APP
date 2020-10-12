import 'dart:async';
import '../constants.dart' as Constants;
import '../groupsets.dart' as Groupsets;
import '../databases/userProfileModel.dart';
import '../databases/db.dart';
import '../databases/userPreferencesModesModel.dart';
import '../databases/preferencesModel.dart';
import '../databases/cranksetsModel.dart';
import '../databases/sprocketsModel.dart';

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

  static Future<PreferencesModel> getCurrentPreferences() async {
    var preferencesMode = await DatabaseHelper.getSelectedPreferencesMode();

    if (preferencesMode != null) {
      var preferencesRow = await DatabaseProvider.queryByParameters(
          PreferencesModel.tableName,
          PreferencesModel.primaryKeyWhereString,
          [preferencesMode.preferencesId]);

      if (preferencesRow.length != 0) {
        return PreferencesModel.fromMap(preferencesRow.first);
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

  static PreferencesModel getDefaultPreferencesRow(int preferencesId) {
    return new PreferencesModel(
        preferencesId: preferencesId,
        ftp: Constants.defaultFtp,
        targetEffort: Constants.defaultTargetEffort,
        shiftingResponsiveness: Constants.defaultShiftingResponsiveness,
        desiredRpm: Constants.defaultDesiredRpm,
        desiredBpm: Constants.defaultDesiredBpm,
        cranksetName: Constants.defaultCranksetName,
        sprocketName: Constants.defaultSprocketName);
  }

  static Future<PreferencesModel> createDefaultPreferencesRow() async {
    var preferences = DatabaseHelper.getDefaultPreferencesRow(null);

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

  static Future<void> updateCranksets() async {
    var list = await DatabaseHelper.getCranksets();

    Groupsets.cranksets.forEach((i) async {
      if (!(list.any((j) => j == i['cranksetName']))) {
        var crankset = CranksetsModel(
          cranksetName: i['cranksetName'],
          bigGear: i['bigGear'],
          gear2: i['gear2'],
          gear3: i['gear3'],
        );
        await DatabaseProvider.insert(CranksetsModel.tableName, crankset);
      }
    });

    list.forEach((j) async {
      if (!(Groupsets.cranksets.any((i) => i['cranksetName'] == j))) {
        await DatabaseProvider.deleteTableDataByParameters(
            CranksetsModel.tableName,
            CranksetsModel.primaryKeyWhereString,
            [j]);
      }
    });

    //TODO : check errors
  }

  static Future<void> updateSprockets() async {
    var list = await DatabaseHelper.getSprockets();

    Groupsets.sprockets.forEach((i) async {
      if (!(list.any((j) => j == i['sprocketName']))) {
        var sprocket = SprocketsModel(
          sprocketName: i['sprocketName'],
          smallGear: i['smallGear'],
          gear2: i['gear2'],
          gear3: i['gear3'],
          gear4: i['gear4'],
          gear5: i['gear5'],
          gear6: i['gear6'],
          gear7: i['gear7'],
          gear8: i['gear8'],
          gear9: i['gear9'],
          gear10: i['gear10'],
          gear11: i['gear11'],
          gear12: i['gear12'],
          gear13: i['gear13'],
        );
        await DatabaseProvider.insert(SprocketsModel.tableName, sprocket);
      }
    });

    list.forEach((j) async {
      if (!(Groupsets.sprockets.any((i) => i['sprocketName'] == j))) {
        await DatabaseProvider.deleteTableDataByParameters(
            SprocketsModel.tableName,
            SprocketsModel.primaryKeyWhereString,
            [j]);
      }
    });

    //TODO : check errors
  }

  static Future<List<String>> getCranksets() async {
    var rows = await DatabaseProvider.query(CranksetsModel.tableName);

    List<String> list = [];

    if (rows.length != 0) {
      rows.forEach((i) {
        list.add(CranksetsModel.fromMap(i).cranksetName);
      });
    }
    list.sort((a, b) => a.toString().compareTo(b.toString()));
    return list;
  }

  static Future<List<String>> getSprockets() async {
    var rows = await DatabaseProvider.query(SprocketsModel.tableName);

    List<String> list = [];

    if (rows.length != 0) {
      rows.forEach((i) {
        list.add(SprocketsModel.fromMap(i).sprocketName);
      });
    }
    list.sort((a, b) => a.toString().compareTo(b.toString()));
    return list;
  }
}
