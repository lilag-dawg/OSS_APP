import 'package:flutter/material.dart';
import '../databases/db_base_model.dart';

class PreferencesModel extends BaseModel {
  static String dbName = 'preferences';
  static String dbFormat = 'CREATE TABLE ' +
      dbName +
      ' (rowid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, parameter STRING, parameterValue DOUBLE)';

  String parameter;
  int parameterValue;

  PreferencesModel({@required this.parameter, @required this.parameterValue});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'parameter': parameter,
      'parameterValue': parameterValue,
    };
    return map;
  }

  static PreferencesModel fromMap(Map<String, dynamic> map) {
    return PreferencesModel(
        parameter: map['parameter'], parameterValue: map['parameterValue']);
  }
}
