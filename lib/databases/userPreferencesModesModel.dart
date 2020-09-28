import 'base_model.dart';

class UserPreferencesModesModel extends BaseModel {
  String userName;
  int preferencesId;
  int selected; // max 1 selected per user
  String modeName;

  static String primaryKeyWhereString = 'preferencesId = ? OR userName = ?';
  static String tableName = 'userPreferences';

  UserPreferencesModesModel(
      {
    this.userName,
    this.preferencesId,
    this.selected,
    this.modeName,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'userName': userName,
      'preferencesId': preferencesId,
      'selected': selected,
      'modeName': modeName,
    };
    return map;
  }

  static UserPreferencesModesModel fromMap(Map<String, dynamic> map) {
    return UserPreferencesModesModel(
        userName: map['userName'],
        preferencesId: map['preferencesId'],
        selected: map['selected'],
        modeName: map['modeName']);
  }
}
