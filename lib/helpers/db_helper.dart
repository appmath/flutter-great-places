import 'package:great_places/helpers/constants.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class DBHelper {
  static Future<sql.Database> database() async {
    var dbPath = await sql.getDatabasesPath();

    var placesDbPath = path.join(dbPath, 'places.db');

    return sql.openDatabase(placesDbPath, version: 1, onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE $kPlacesTable($kId TEXT PRIMARY KEY, $kTitle TEXT, $kImage TEXT, $kLocationLatitude REAL,$kLocationLongitude REAL, $kAddress TEXT)',
      );
    });
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    sql.Database db = await DBHelper.database();

    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    sql.Database db = await DBHelper.database();
    return db.query(table);
  }
}

// Description: Handles getting a location on Android and iOS. It also provides callbacks when the location is changed.
// URL: https://pub.dev/packages/location
// Install: flutter pub add location
// App: Name (full location)

// Example:

// Full example
