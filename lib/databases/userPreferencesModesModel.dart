import 'base_model.dart';

class UserPreferencesModesModel extends BaseModel {
  int userId;
  int preferencesId;
  bool selected;
  String modeName;

  static String primaryKeyWhereString = 'preferencesId = ? OR userId = ?';
  static String tableName = 'userPreferences';

  UserPreferencesModesModel(
      {
    this.userId,
    this.preferencesId,
    this.selected,
    this.modeName,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'userId': userId,
      'preferencesId': preferencesId,
      'selected': selected,
      'modeName': modeName,
    };
    return map;
  }

  static UserPreferencesModesModel fromMap(Map<String, dynamic> map) {
    return UserPreferencesModesModel(
        userId: map['userId'],
        preferencesId: map['preferencesId'],
        selected: map['selected'],
        modeName: map['modeName']);
  }
}
