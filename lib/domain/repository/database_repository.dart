import 'package:path/path.dart';
import 'package:social_net/domain/entities/db_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:uuid/uuid.dart';

class DatabaseRepository {
  DatabaseRepository._();

  late final Database _db;
  final String _version = "1.0.014";
  static final DatabaseRepository instance = DatabaseRepository._();

  Future<void> init() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "database_$_version.db");

    _db = await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    final initScript = await rootBundle.loadString("assets/scripts/db_init.sql");
    final commands = initScript.split(";").map((x) => x.trim()).where((x) => x.isNotEmpty);

    // execute commands from script
    for (var command in commands) {
      await db.execute(command);
    }
  }

  Future<Iterable<Map<String, dynamic>>> getAll<T extends DbModel<dynamic>>({
    Map<String, dynamic>? whereMap,
    int? skip,
    int? take,
  }) async {
    if (whereMap == null) {
      return await _db.query(T.toString(), offset: skip, limit: take);
    }

    var whereBuilder = <String>[];
    var whereArgs = <dynamic>[];

    whereMap.forEach((key, value) {
      if (value is Iterable<dynamic>) {
        var placeHolders = List.filled(value.length, '?').join(',');
        var stringValues = value.map((e) => e.toString());

        whereBuilder.add("$key IN ($placeHolders)");
        whereArgs.addAll(stringValues);
      } else {
        whereBuilder.add("$key = ?");
        whereArgs.add(value);
      }

      whereBuilder.add("$key = ?");
      whereArgs.add(value);
    });

    return await _db.query(
      T.toString(),
      offset: skip,
      limit: take,
      where: whereBuilder.join(' and '),
      whereArgs: whereArgs,
    );
  }

  Future<Map<String, dynamic>?> get<T extends DbModel<dynamic>>(dynamic id) async {
    var res = await _db.query(T.toString(), where: 'id = ? ', whereArgs: [id]);
    return res.isNotEmpty ? res.first : null;
  }

  Future<void> insert<T extends DbModel<dynamic>>(T model) async {
    var modelMap = model.toMap();

    if (model.id == "") {
      modelMap["id"] = const Uuid().v4();
    }

    await _db.insert(T.toString(), modelMap, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> inserRange<T extends DbModel<dynamic>>(Iterable<T> values) async {
    var batch = _db.batch();

    for (var row in values) {
      var data = row.toMap();

      if (row.id == "") {
        data["id"] = const Uuid().v4();
      }

      batch.insert(T.toString(), data, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit(noResult: true);
  }

  Future<void> delete<T extends DbModel<dynamic>>(T model) async {
    await _db.delete(T.toString(), where: 'id = ?', whereArgs: [model.id]);
  }

  Future<void> cleanTable<T extends DbModel<dynamic>>() async {
    await _db.delete(T.toString());
  }
}
