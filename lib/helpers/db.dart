import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  ///create a database instance.
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'plants.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE plants_data(id TEXT PRIMARY KEY, image BLOB, date TEXT)');
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
  static Future<void> deleteAllData(String table, String id) async {
    final db = await DBHelper.database();
    db.delete(table);
  }
}
