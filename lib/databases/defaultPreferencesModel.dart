import 'base_model.dart';

class DefaultPreferencesModel extends BaseModel {
  String defaultModeName;
  int preferencesId;
  int version;

  static String primaryKeyWhereString =
      'defaultModeName = ?';
  static String tableName = 'defaultPreferences';

  DefaultPreferencesModel(
      //TODO : Verify for PK inclusion?
      {this.preferencesId,
      this.defaultModeName,
      this.version});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'preferencesId': preferencesId,
      'defaultModeName': defaultModeName,
      'version': version,
    };
    return map;
  }

  static DefaultPreferencesModel fromMap(Map<String, dynamic> map) {
    return DefaultPreferencesModel(
        preferencesId: map['preferencesId'],
        defaultModeName: map['defaultModeName'],
        version: map['version']);
  }
}
