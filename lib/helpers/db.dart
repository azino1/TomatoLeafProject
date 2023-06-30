import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

import '../models/virus_model.dart';

class DBHelper {
  ///create a database instance.
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'plants.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE plants_data(id TEXT PRIMARY KEY, image BLOB, date TEXT, virus_name Text, analysis_status INTEGER, health_status INTEGER)');
    }, version: 1);
  }

  static Future<Database> virusDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'virus.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE virus_data(id TEXT PRIMARY KEY, name TEXT, about TEXT, language TEXT, management TEXT, transmission TEXT)');
    }, version: 1);
  }

  ///inserts a new item into the already created database.
  static Future<void> insert(String table, Map<String, dynamic> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  ///fetches data from the database.
  ///
  ///Returns an Array of Maps.
  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  ///deletes a single item from the local database.
  static Future<void> deleteData(String table, String id) async {
    final db = await DBHelper.database();
    db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  ///deletes all item from the local database.
  static Future<void> deleteAllData(String table) async {
    final db = await DBHelper.database();
    db.delete(table);
  }

  ///update an item in the local database.
  static Future<void> updatePlantData(
      String table, Map<String, dynamic> data, String id) async {
    final db = await DBHelper.database();
    db.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> insertVirusItem(Virus virus) async {
    final _virusDB = await virusDatabase();
    await _virusDB.insert('virus_data', virus.toMap());
  }

  static Future<List<Virus>> getVirusItems() async {
    final _virusDB = await virusDatabase();
    final List<Map<String, dynamic>> maps = await _virusDB.query('virus_data');

    return List.generate(maps.length, (index) {
      return Virus.fromMap(maps[index], maps[index]['language']);
    });
  }

  ///deletes all item from the local database.
  static Future<void> deleteAllVirusData(String table) async {
    final db = await DBHelper.virusDatabase();
    db.delete(table);
  }
}
