import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'app.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE League (id INTEGER PRIMARY KEY)');

    await db.execute('CREATE TABLE Player (id INTEGER PRIMARY KEY)');

    await db.execute('CREATE TABLE Team (id INTEGER PRIMARY KEY)');
  }

  Future<int> add(int id, String table) async {
    Database db = await instance.database;
    try {
      var res = await db.insert(table, {"id": id});
      return res;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> entryExists(String table, String entryID) async {
    Database db = await instance.database;
    var entries =
        await db.query(table, columns: ["id"], where: "id = $entryID");
    return entries.isNotEmpty;
  }

  Future<List<Map<String, Object?>>> getEntries(String table) async {
    Database db = await instance.database;
    var entries = await db.query(table, columns: ["id"]);
    return entries;
  }

  Future<int> removeEntry(String table, String entryID) async {
    Database db = await instance.database;
    var deleted = await db.delete(table, where: "id = $entryID");
    return deleted;
  }
}
