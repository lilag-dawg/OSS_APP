import 'base_model.dart';

class PreferencesModel extends BaseModel {
  int preferencesId;
  int ftp; // W
  double shiftingResponsiveness; // deltaRPM
  int desiredRpm;
  int desiredBpm;
  String cranksetName;
  String sprocketName;

  static String primaryKeyWhereString = 'preferencesId = ?';
  static String tableName = 'preferences';

  PreferencesModel(
      {this.preferencesId,
      this.ftp,
      this.shiftingResponsiveness,
      this.desiredRpm,
      this.desiredBpm,
      this.cranksetName,
      this.sprocketName});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'preferencesId': preferencesId,
      'ftp': ftp,
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
        shiftingResponsiveness: map['shiftingResponsiveness'],
        desiredRpm: map['desiredRpm'],
        desiredBpm: map['desiredBpm'],
        cranksetName: map['cranksetName'],
        sprocketName: map['sprocketName']);
  }
}
