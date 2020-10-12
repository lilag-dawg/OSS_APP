import 'base_model.dart';

class PreferencesModel extends BaseModel {
  int preferencesId;
  int ftp; // W
  int targetEffort; // %
  int shiftingResponsiveness; // deltaRPM
  int desiredRpm;
  int desiredBpm;
  String cranksetName;
  String sprocketName;

  static String primaryKeyWhereString = 'preferencesId = ?';
  static String tableName = 'preferences';

  PreferencesModel(
      {this.preferencesId,
      this.ftp,
      this.targetEffort,
      this.shiftingResponsiveness,
      this.desiredRpm,
      this.desiredBpm,
      this.cranksetName,
      this.sprocketName});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'preferencesId': preferencesId,
      'ftp': ftp,
      'targetEffort': targetEffort,
      'shiftingResponsiveness': shiftingResponsiveness,
      'desiredRpm': desiredRpm,
      'desiredBpm': desiredBpm,
      'cranksetName': cranksetName,
      'sprocketName': sprocketName,
    };
    return map;
  }

  static PreferencesModel fromMap(Map<String, dynamic> map) {
    return PreferencesModel(
        preferencesId: map['preferencesId'],
        ftp: map['ftp'],
        targetEffort: map['targetEffort'],
        shiftingResponsiveness: map['shiftingResponsiveness'],
        desiredRpm: map['desiredRpm'],
        desiredBpm: map['desiredBpm'],
        cranksetName: map['cranksetName'],
        sprocketName: map['sprocketName']);
  }
}
