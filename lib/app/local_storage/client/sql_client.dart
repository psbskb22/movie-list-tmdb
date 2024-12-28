import 'dart:convert';
import 'package:movie_list_tmdb/app/failure/exceptions.dart';

import '../database/sql_database.dart';

class SQLClient {
  final String tableName;
  final StorageType storageType;
  late SQLDatabase sqlDatabase;

  SQLClient({required this.tableName, this.storageType = StorageType.internal});

  Future<bool> delete({String? id}) async {
    await _init();
    return await sqlDatabase.delete(id: id);
  }

  Future<List<Map<String, dynamic>>> read(
      {String? id, Duration? exprireIn}) async {
    await _init();
    exprireIn ??= const Duration(days: 1);
    List<Map<String, dynamic>> data = [];
    List<Map<String, dynamic>> dataList = await sqlDatabase.read(id: id);
    if (dataList.isEmpty) {
      throw EmptyCacheException();
    }
    for (var i = 0; i < dataList.length; i++) {
      DateTime dataTime =
          DateTime.fromMillisecondsSinceEpoch(dataList[i]['dateTime']);
      int dataAge = DateTime.now().difference(dataTime).inSeconds;
      // Check Data Exprire Data
      if (dataAge < exprireIn.inSeconds) {
        Map<String, dynamic>? decyptedData = json.decode(dataList[i]['data']);
        if (decyptedData != null) data.add(decyptedData);
        // data.add(json.decode(dataList[i]['data']));
      } else {
        data.clear();
        throw CacheExpireException();
      }
    }
    return data;
  }

  Future<bool> write(
      {required String id, required Map<String, dynamic> data}) async {
    await _init();
    return await sqlDatabase.write(id: id, data: json.encode(data));
  }

  Future<void> _init() async {
    sqlDatabase = SQLDatabase(tableName: tableName, storageType: storageType);
    await sqlDatabase.init();
  }
}
