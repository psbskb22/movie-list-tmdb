import 'dart:convert';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

enum StorageType { memory, internal }

class SQLDatabase {
  final String tableName;
  final StorageType storageType;
  late Database db;

  SQLDatabase({required this.tableName, required this.storageType});

  Future<void> init() async {
    await _createTable();
  }

  close() async {
    await db.close();
  }

  _createTable() async {
    var databaseFactory = databaseFactoryFfi;
    late String storagePath;
    if (storageType == StorageType.internal) {
      final io.Directory appDocumentsDir =
          await getApplicationDocumentsDirectory();
      String dbPath = join(appDocumentsDir.path, "databases", "my_db.db");
      storagePath = dbPath;
    } else {
      storagePath = inMemoryDatabasePath;
    }
    db = await databaseFactory.openDatabase(storagePath);
    // final ifTableExist = await _checkTable();
    try {
      await db.execute(
          'CREATE TABLE $tableName(id INTEGER PRIMARY KEY, uid TEXT, dateTime INTEGER, data BLOB)');
    } catch (e) {}
  }

  // Future<bool> _checkTable() async {
  //   try {
  //     final data = await db.rawQuery('SELECT * FROM $tableName');
  //     return data.isNotEmpty;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future<List<Map<String, dynamic>>> read({String? id}) async {
    if (id != null) {
      return await db.rawQuery(
          'SELECT * FROM $tableName WHERE uid = ? ORDER BY id DESC', [id]);
    }
    return await db.rawQuery('SELECT * FROM $tableName ORDER BY id DESC');
  }

  Future<bool> write({
    required String id,
    required String data,
  }) async {
    List<Map<String, dynamic>> readData = await read(id: id);
    if (readData.isEmpty) {
      int index = await db.insert(
        tableName,
        {
          "uid": id,
          "dateTime": DateTime.now().millisecondsSinceEpoch,
          "data": data
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return index == 0 ? false : true;
    } else {
      return await update(
        id: id,
        dateTime: DateTime.now().millisecondsSinceEpoch,
        data: data,
      );
    }
  }

  Future<bool> update({
    required String id,
    required int dateTime,
    required String data,
  }) async {
    int index = await db.rawUpdate(
        'UPDATE $tableName SET dateTime = ?, data = ? WHERE uid = ?',
        [dateTime, data, id]);
    return index == 0 ? false : true;
  }

  Future<bool> delete({String? id}) async {
    int index = (id != null)
        ? await db.rawDelete("DELETE FROM $tableName WHERE uid= ?", [id])
        : await db.rawDelete("DELETE FROM $tableName");
    return index == 0 ? false : true;
  }
}
