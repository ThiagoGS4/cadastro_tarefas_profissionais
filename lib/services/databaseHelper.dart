import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:cadastro_tarefas_profissionais/models/tarefaModel.dart';

class DatabaseHelper {
  static const int version = 1;
  static const String bdName = "202310209_202310180.db";

  static Future<Database> getBD() async {
    return openDatabase(
      join(await getDatabasesPath(), bdName),
      onCreate: (db, version) async => await db.execute(
        'CREATE TABLE IF NOT EXISTS Tarefa(id INTEGER PRIMARY KEY, titulo TEXT, prioridade TEXT, criadoEm STRING, codigoRegistro INTEGER)',
      ),
      onOpen: (db) async => await db.execute(
        'CREATE TABLE IF NOT EXISTS Tarefa(id INTEGER PRIMARY KEY, titulo TEXT, prioridade TEXT, criadoEm STRING, codigoRegistro INTEGER)',
      ),
      version: version,
    );
  }

  static Future<int> inserirTarefa(Tarefa tarefa) async {
    final db = await getBD();
    return await db.insert(
      "Tarefa",
      tarefa.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> atualizarTarefa(Tarefa tarefa) async {
    final db = await getBD();
    return await db.update(
      "Tarefa",
      tarefa.toJson(),
      where: 'id = ?',
      whereArgs: [tarefa.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> removerTarefa(Tarefa tarefa) async {
    final db = await getBD();
    return await db.delete("Tarefa", where: 'id = ?', whereArgs: [tarefa.id]);
  }

  static Future<List<Tarefa>?> listarTarefas() async {
    final db = await getBD();

    final List<Map<String, dynamic>> maps = await db.query("Tarefa");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(maps.length, (index) => Tarefa.fromJson(maps[index]));
  }
}
