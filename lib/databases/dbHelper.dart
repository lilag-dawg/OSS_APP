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
  static Future<void> initDatabase() async {
    await DatabaseProvider.database;
  }

  static Future<List<UserProfileModel>> getUsers() async {
    List<UserProfileModel> list = [];
    var users = await DatabaseProvider.query(UserProfileModel.tableName);

    if (users.length != 0) {
      users.forEach((i) {
        list.add(UserProfileModel.fromMap(i));
      });
    }

    return list;
  }

  static Future<UserProfileModel> getSelectedUserProfile() async {
    var users = await DatabaseHelper.getUsers();

    if (users.length != 0) {
      for (int i = 0; i < users.length; i++) {
        if (users[i].selected == Constants.isSelected) {
          return users[i];
        }
      }

      await DatabaseHelper.selectUser(users.first.userName);
      return users.first;
    }
    return null;
  }

  static Future<void> selectUser(String userName) async {
    var users = await DatabaseHelper.getUsers();

    if (users.length != 0) {
      users.forEach((user) async {
        user.selected = user.userName == userName
            ? Constants.isSelected
            : Constants.isNotSelected;
        await DatabaseProvider.updateByPrimaryKey(UserProfileModel.tableName,
            user, UserProfileModel.primaryKeyWhereString, user.userName);
      });
    }
  }

  static Future<void> createUser(String userName) async {
    var userRow =
        UserProfileModel(userName: userName, selected: Constants.isSelected);
    await DatabaseProvider.insert(UserProfileModel.tableName, userRow);

    await DatabaseHelper.selectUser(userName);

    var preferences = await DatabaseHelper.createDefaultPreferencesRow();
    await DatabaseHelper.createPreferencesMode(
        Constants.defaultPreferencesModeName, preferences);
  }

  static Future<void> deleteUser(String userName) async {
    await DatabaseProvider.deleteTableDataByParameters(
        UserProfileModel.tableName,
        UserProfileModel.primaryKeyWhereString,
        [userName]);

    var users = await DatabaseHelper.getUsers();
    if (users.length == 0) {
      await DatabaseHelper.createUser(Constants.defaultProfileName);
    }
  }

  static Future<void> updateUser(
      UserProfileModel user, String oldUserName) async {
    await DatabaseProvider.updateByPrimaryKey(UserProfileModel.tableName, user,
        UserProfileModel.primaryKeyWhereString, oldUserName);
  }

  static Future<UserPreferencesModesModel> getSelectedPreferencesMode() async {
    var modes = await DatabaseHelper.getUserPreferencesModes();
    if (modes.length != 0) {
      for (int i = 0; i < modes.length; i++) {
        if (modes[i].selected == Constants.isSelected) {
          return modes[i];
        }
      }

      await DatabaseHelper.selectPreferencesMode(modes.first.modeName);
      return modes.first;
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
    var modes = await DatabaseHelper.getUserPreferencesModes();
    if (modes.length != 0) {
      modes.forEach((mode) async {
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

  static Future<List<UserPreferencesModesModel>>
      getUserPreferencesModes() async {
    var profile = await DatabaseHelper.getSelectedUserProfile();
    List<UserPreferencesModesModel> list = [];
    if (profile != null) {
      var rows = await DatabaseProvider.queryByParameters(
          UserPreferencesModesModel.tableName,
          UserPreferencesModesModel.userWhereString,
          [profile.userName]);

      if (rows.length != 0) {
        rows.forEach((i) {
          list.add(UserPreferencesModesModel.fromMap(i));
        });
      }
    }
    return list;
  }

  static PreferencesModel getDefaultPreferencesRow(int preferencesId) {
    return new PreferencesModel(
        preferencesId: preferencesId,
        ftp: Constants.defaultFtp,
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

  static Future<void> updatePreferences(PreferencesModel preferences) async {
    await DatabaseProvider.updateByPrimaryKey(
        PreferencesModel.tableName,
        preferences,
        PreferencesModel.primaryKeyWhereString,
        preferences.preferencesId);
  }

  static Future<void> createPreferencesMode(
      String modeName, PreferencesModel preferences) async {
    var profile = await DatabaseHelper.getSelectedUserProfile();
    if (profile != null) {
      var modeRow = UserPreferencesModesModel(
          userName: profile.userName,
          preferencesId: preferences.preferencesId,
          selected: Constants.isSelected,
          modeName: modeName);
      await DatabaseProvider.insert(
          UserPreferencesModesModel.tableName, modeRow);

      await DatabaseHelper.selectPreferencesMode(modeName);
    }
  }

  static Future<void> updatePreferencesMode(
      UserPreferencesModesModel mode) async {
    await DatabaseProvider.updateByPrimaryKey(
        UserPreferencesModesModel.tableName,
        mode,
        UserPreferencesModesModel.preferencesWhereString,
        mode.preferencesId);
  }

  static Future<void> deletePreferencesMode(int preferencesId) async {
    await DatabaseProvider.deleteTableDataByParameters(
        UserPreferencesModesModel.tableName,
        UserPreferencesModesModel.preferencesWhereString,
        [preferencesId]);

    var list = await DatabaseHelper.getUserPreferencesModes();

    if (list.length == 0) {
      var preferences = await DatabaseHelper.createDefaultPreferencesRow();
      await DatabaseHelper.createPreferencesMode(
          Constants.defaultPreferencesModeName, preferences);
    }
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

  static Future<CranksetsModel> getSelectedCrankset() async {
    var preferences = await DatabaseHelper.getCurrentPreferences();

    if (preferences != null) {
      var crankset = await DatabaseProvider.queryByParameters(
          CranksetsModel.tableName,
          CranksetsModel.primaryKeyWhereString,
          [preferences.cranksetName]);
      if (crankset.length != 0) {
        return CranksetsModel.fromMap(crankset.first);
      }
    }
    return null;
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

  static Future<SprocketsModel> getSelectedSprocket() async {
    var preferences = await DatabaseHelper.getCurrentPreferences();

    if (preferences != null) {
      var sprocket = await DatabaseProvider.queryByParameters(
          SprocketsModel.tableName,
          SprocketsModel.primaryKeyWhereString,
          [preferences.sprocketName]);
      if (sprocket.length != 0) {
        return SprocketsModel.fromMap(sprocket.first);
      }
    }
    return null;
  }

  static Future<void> getSize() async {
    await DatabaseProvider.getSize();
  }
}
