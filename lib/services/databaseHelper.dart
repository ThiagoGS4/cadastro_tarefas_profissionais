import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const int version = 1;
  static const String bdName = "202310209_202310180.db";

  static Future<Database> getBD() async {
    return openDatabase(
      join(await getDatabasesPath(), bdName),
      onCreate: (db, version) async => await db.execute(
        'CREATE TABLE IF NOT EXISTS Tarefa(id INTEGER PRIMARY KEY, titulo TEXT, prioridade INTEGER, criadoEm STRING, codigoRegistro TEXT)',
      ),
      onOpen: (db) async => await db.execute(
        'CREATE TABLE IF NOT EXISTS Tarefa(id INTEGER PRIMARY KEY, titulo TEXT, prioridade INTEGER, criadoEm STRING, codigoRegistro TEXT)',
      ),
      version: version,
    );
  }
}
