import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../databases/db_base_model.dart';

class DB {
  Database _db;

  static int get _version => 1;

  String dbFormat;
  String dbName;

  DB({this.dbFormat, this.dbName});

  Future<void> init() async {
    if (_db != null) {
      return;
    }

    try {
      String _dbPath = await getDatabasesPath() + dbName;
      _db = await openDatabase(_dbPath, version: _version, onCreate: create);
    } catch (ex) {
      print(ex);
    }
  }

  void create(Database db, int version) async {
    await db.execute(dbFormat);
  }

  Future<List<Map<String, dynamic>>> query(String table) async =>
      _db.query(table);

  Future<Map<String, dynamic>> queryByParameter(
      String table, String parameter) async {
    var query =
        await _db.query(table, where: 'parameter = ?', whereArgs: [parameter]);
    if (query.length != 0) {
      return query[0];
    } else {
      return null;
    }
  }

  Future<int> insert(String table, BaseModel model) async =>
      await _db.insert(table, model.toMap());

  Future<int> updateByParameter(String table, BaseModel model) async =>
      await _db.update(table, model.toMap(),
          where: 'parameter = ?', whereArgs: [model.parameter]);

  Future<int> deleteById(String table, int rowid) async =>
      await _db.delete(table, where: 'rowid = ?', whereArgs: [rowid]);

  Future<int> delete(String table) async => await _db.delete(table);
}
