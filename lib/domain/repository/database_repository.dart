import 'package:path/path.dart';
import 'package:social_net/domain/entities/db_model.dart';
import 'package:social_net/domain/entities/notification.dart';
import 'package:social_net/domain/entities/post.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart' show rootBundle;

class DatabaseRepository {
  DatabaseRepository._();
  static final DatabaseRepository instance = DatabaseRepository._();

  late final Database _db;
  final _version = "1.0.14";

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

    final whereBuilder = <String>[];
    final whereArgs = <dynamic>[];

    whereMap.forEach((key, value) {
      if (value is Iterable<dynamic>) {
        var placeHolders = List.filled(value.length, '?').join(',');
        var stringValues = value.map((e) => e.toString());

        whereBuilder.add("$key IN ($placeHolders)");
        whereArgs.addAll(stringValues);
      } else {
        if (key.contains("LIKE")) {
          whereBuilder.add("$key ?");
        } else {
          whereBuilder.add("$key = ?");
        }

        whereArgs.add(value);
      }
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
    final res = await _db.query(T.toString(), where: "id = ? ", whereArgs: [id]);
    return res.isNotEmpty ? res.first : null;
  }

  Future<void> insert<T extends DbModel<dynamic>>(T model) async {
    final modelMap = model.toMap();

    final existsDataResult = await _db.query(
      T.toString(),
      where: "id = ? ",
      whereArgs: [model.id],
    );

    if (existsDataResult.isNotEmpty) {
      await _db.update(T.toString(), modelMap, conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      await _db.insert(T.toString(), modelMap, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await _db.insert(T.toString(), modelMap, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> inserRange<T extends DbModel<dynamic>>(Iterable<T> values) async {
    final batch = _db.batch();

    for (final row in values) {
      final data = row.toMap();

      final existsDataResult = await _db.query(
        T.toString(),
        where: "id = ? ",
        whereArgs: [row.id],
      );

      if (existsDataResult.isNotEmpty) {
        batch.update(T.toString(), data, conflictAlgorithm: ConflictAlgorithm.ignore);
      } else {
        batch.insert(T.toString(), data, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
    }

    await batch.commit(noResult: true);
  }

  Future<void> delete<T extends DbModel<dynamic>>(dynamic id) async {
    await _db.delete(T.toString(), where: 'id = ?', whereArgs: [id]);
  }

  Future<void> cleanTable<T extends DbModel<dynamic>>() async {
    await _db.delete(T.toString());
  }

  Future<Iterable<Post>> getPosts({int? skip, int? take, DateTime? fromTime, bool isPersonal = false, String? userId}) async {
    final whereBuilder = <String>[];
    final whereArgs = <dynamic>[];

    if (isPersonal) {
      whereBuilder.add("isPersonal = ?");
      whereArgs.add(true);
    } else if (userId != null) {
      whereBuilder.add("authorId = ?");
      whereArgs.add(userId);
    } else {
      throw ArgumentError("Invalid arguments for getPosts");
    }

    if (fromTime != null) {
      whereBuilder.add("createdAt < ?");
      whereArgs.add(fromTime.toIso8601String());
    }

    final result = await _db.query(
      (Post).toString(),
      offset: skip,
      limit: take,
      orderBy: "createdAt DESC",
      where: whereBuilder.isNotEmpty ? whereBuilder.join(' and ') : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
    );

    return result.map((e) => Post.fromMap(e));
  }

  Future<Iterable<Notification>> getNotifications(int? skip, int? take, DateTime? fromTime) async {
    final whereBuilder = <String>[];
    final whereArgs = <dynamic>[];

    if (fromTime != null) {
      whereBuilder.add("createdAt < ?");
      whereArgs.add(fromTime.toIso8601String());
    }

    final result = await _db.query(
      (Notification).toString(),
      offset: skip,
      limit: take,
      orderBy: "createdAt DESC",
      where: whereBuilder.isNotEmpty ? whereBuilder.join(' and ') : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
    );

    return result.map((e) => Notification.fromMap(e));
  }
}
