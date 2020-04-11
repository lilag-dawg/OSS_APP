import 'package:flutter/material.dart';
import '../databases/db_base_model.dart';

class UserSettingsModel extends BaseModel {
  static String dbName = 'user_settings';
  static String dbFormat = 'CREATE TABLE ' +
      dbName +
      ' (rowid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, parameter STRING, parameterValue STRING)';

  String parameter;
  String parameterValue;

  UserSettingsModel({@required this.parameter, @required this.parameterValue});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'parameter': parameter,
      'parameterValue': parameterValue,
    };
    return map;
  }

  static UserSettingsModel fromMap(Map<String, dynamic> map) {
    return UserSettingsModel(
        parameter: map['parameter'], parameterValue: map['parameterValue']);
  }
}
