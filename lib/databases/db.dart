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
  static final String databaseName = 'ossDatabase.db';

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
      userId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
      birthday TEXT,
      sex TEXT,
      height TEXT,
      weight TEXT
    );
    ''');

    await db.execute('''
    CREATE TABLE preferences (
      preferencesId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
      ftp INTEGER NOT NULL, 
      targetEffort INTEGER NOT NULL, 
      shiftingResponsiveness INTEGER NOT NULL, 
      desiredRpm INTEGER NOT NULL, 
      desiredBpm INTEGER NOT NULL,
    );
    ''');

    await db.execute('''
    CREATE TABLE userPreferencesModes (
      userId INTEGER NOT NULL,
      FOREIGN KEY(userId) REFERENCES userProfile(userId) ON DELETE CASCADE
      preferencesId INTEGER NOT NULL, 
      FOREIGN KEY(preferencesId) REFERENCES preferences(preferencesId) ON DELETE CASCADE
      selected INTEGER NOT NULL,
      modeName TEXT NOT NULL,
    );
    ''');

    await db.execute('''
    CREATE TABLE defaultPreferences (
      defaultModeName TEXT PRIMARY KEY NOT NULL,
      preferencesId INTEGER NOT NULL UNIQUE, 
      FOREIGN KEY(preferencesId) REFERENCES preferences(preferencesId) ON DELETE CASCADE
      version INTEGER,
    );
    ''');
  }

  static Future<List<Map<String, dynamic>>> query(String tableName) async =>
      await _database.query(tableName);

  static Future<void> insert(String tableName, BaseModel tableRow) async =>
      await _database.insert(tableName, tableRow.toMap());

  static Future<int> deleteTableData(String tableName) async =>
      await _database.delete(tableName);

  static Future<List<Map<String, dynamic>>> queryByParameters(
      String tableName, String whereString, List<dynamic> parameter) async {
    var query = await _database
        .query(tableName, where: whereString, whereArgs: parameter);
    if (query.length != 0) {
      return query;
    } else {
      return null;
    }
  }

  static Future<int> updateByPrimaryKey(String tableName, BaseModel tableRow,
          String primaryKeySearchString, dynamic primaryKey) async =>
      await _database.update(tableName, tableRow.toMap(),
          where: primaryKeySearchString, whereArgs: [primaryKey]);

  /*Future<int> deleteByPrimaryKey(String table, BaseModel usersTable,
          String primaryKeySearchString, String primaryKey) async =>
      await _db.delete(table,
          where: primaryKeySearchString, whereArgs: [primaryKey]);*/
}
