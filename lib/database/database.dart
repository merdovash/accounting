import 'dart:io';

import 'package:accounting/database/pay_category.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class OnCreateDatabase {
  call() async {

  }
}


abstract class IDatabase {
  Future<Database> get db;

  Future<List<Map<String, dynamic>>> rawQuery(body, [List<dynamic>? args]) async {
    var _args = prepareArgs(args);
    print(_args);
    print(body);
    return (await this.db).rawQuery(body, _args);
  }

  List<String>? prepareArgs(List<dynamic>? args) {
    if (args == null) return null;
    return args.map((el) {
      if (el is DateTime) return '${el.year}-${el.month<10?0:''}${el.month}-${el.day<10?0:''}${el.day}';
      return el.toString();
    }).toList();
  }
}


class DatabaseConnection extends IDatabase {
  Future<Database> get db async => await createAndOpenDatabase();
  late Future<Database> opener;

  DatabaseConnection() {
    opener = createAndOpenDatabase();
  }

  Future<Database> createAndOpenDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "db1.db");

    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    return await openDatabase(
      path,
      version: 4,

      onCreate: (Database db, int version) async {
        // When creating the db, create the table
        initTablePayCategory(db);

        await db.execute(
          '''
            CREATE TABLE Pay (
              id INTEGER PRIMARY KEY,
              date TEXT NOT NULL,
              description TEXT,
              paySum NUMERIC NOT NULL,
              payCategory INTEGER NOT NULL,
              FOREIGN KEY(payCategory) REFERENCES PayCategory(id)
            )
          '''
        );
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        switch (oldVersion) {
          case 1:
            await db.execute('''
              alter table Pay 
              add column payCategory INTEGER NOT NULL DEFAULT (1) REFERENCES PayCategory(id);
            ''');
            continue second;

          second:
          case 2:
            initTablePayCategory(db);
            db.execute('update Pay set PayCategory = 1;');
        }
      }
    );
  }

  void dispose() async {
    (await db).close();
  }

  void execute(){}
}