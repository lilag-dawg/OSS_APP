import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import '../databases/base_model.dart';

class DatabaseProvider {
  DatabaseProvider._();
  static final DatabaseProvider provider = DatabaseProvider._();
  static Database _database;

  static int get _version => 1; //onCreate
  static final String databaseName = 'ossDatabase_test27.db';

  static Future<Database> get database async {
    if (_database != null) return _database;

    _database = await init();
    return _database;
  }

  static Future<Database> init() async {
    return await openDatabase(join(await getDatabasesPath(), databaseName),
        version: _version, onCreate: create, onConfigure: _onConfigure);
  }

  static Future<void> eraseDatabase() async {
    if (_database == null) {
      return;
    }

    await deleteDatabase(join(await getDatabasesPath(), databaseName));
    _database = null;

    return;
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  static void create(Database db, int version) async {
    await db.execute('''
    CREATE TABLE userProfile (
      userName TEXT PRIMARY KEY NOT NULL, 
      birthday TEXT,
      sex TEXT,
      height REAL,
      metricHeight INTEGER,
      weight REAL,
      metricWeight INTEGER,
      selected INTEGER NOT NULL
    );
    ''');

    await db.execute('''
    CREATE TABLE preferences (
      preferencesId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
      ftp INTEGER NOT NULL, 
      shiftingResponsiveness REAL NOT NULL, 
      desiredRpm INTEGER NOT NULL, 
      desiredBpm INTEGER NOT NULL,
      cranksetName TEXT,
      sprocketName TEXT,
      FOREIGN KEY(cranksetName) REFERENCES cranksets(cranksetName) ON DELETE SET NULL,
      FOREIGN KEY(sprocketName) REFERENCES sprockets(sprocketName) ON DELETE SET NULL
    );
    ''');

    await db.execute('''
    CREATE TABLE userPreferencesModes (
      userName TEXT NOT NULL,
      preferencesId INTEGER NOT NULL UNIQUE, 
      selected INTEGER NOT NULL,
      modeName TEXT NOT NULL,
      FOREIGN KEY(userName) REFERENCES userProfile(userName) ON DELETE CASCADE ON UPDATE CASCADE,
      FOREIGN KEY(preferencesId) REFERENCES preferences(preferencesId) ON DELETE CASCADE
    );
    ''');

    await db.execute('''
    CREATE TABLE cranksets  (
      cranksetName TEXT PRIMARY KEY NOT NULL UNIQUE,
      bigGear INTEGER NOT NULL, 
      gear2 INTEGER,
      gear3 INTEGER
    );
    ''');

    await db.execute('''
    CREATE TABLE sprockets  (
      sprocketName TEXT PRIMARY KEY NOT NULL UNIQUE,
      smallGear INTEGER NOT NULL, 
      gear2 INTEGER,
      gear3 INTEGER,
      gear4 INTEGER,
      gear5 INTEGER,
      gear6 INTEGER,
      gear7 INTEGER,
      gear8 INTEGER,
      gear9 INTEGER,
      gear10 INTEGER,
      gear11 INTEGER,
      gear12 INTEGER,
      gear13 INTEGER
    );
    ''');
  }

  static Future<List<Map<String, dynamic>>> getSize() async {
    return await _database.rawQuery("PRAGMA page_size");
  }

  static Future<List<Map<String, dynamic>>> query(String tableName) async =>
      await _database.query(tableName);

  static Future<void> insert(String tableName, BaseModel tableRow) async =>
      await _database.insert(tableName, tableRow.toMap());

  static Future<int> deleteTable(String tableName) async =>
      await _database.delete(tableName);

  static Future<int> deleteTableDataByParameters(String tableName,
          String whereString, List<dynamic> parameters) async =>
      await _database.delete(tableName,
          where: whereString, whereArgs: parameters);

  static Future<List<Map<String, dynamic>>> queryByParameters(String tableName,
          String whereString, List<dynamic> parameters) async =>
      await _database.query(tableName,
          where: whereString, whereArgs: parameters);

  static Future<int> updateByPrimaryKey(String tableName, BaseModel tableRow,
          String primaryKeySearchString, dynamic primaryKey) async =>
      await _database.update(tableName, tableRow.toMap(),
          where: primaryKeySearchString, whereArgs: [primaryKey]);

  /*Future<int> deleteByPrimaryKey(String table, BaseModel usersTable,
          String primaryKeySearchString, String primaryKey) async =>
      await _db.delete(table,
          where: primaryKeySearchString, whereArgs: [primaryKey]);*/
}
