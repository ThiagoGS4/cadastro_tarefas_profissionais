import 'package:cadastro_tarefas_profissionais/services/databaseHelper.dart';
import 'package:cadastro_tarefas_profissionais/widgets/insertEditDialog.dart';
import 'package:flutter/material.dart';
import '../models/tarefaModel.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  List<Tarefa> details = [];
  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  Future<void> _carregarTarefas() async {
    final lista = await DatabaseHelper.listarTarefas();
    setState(() {
      details = lista ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tarefas'), centerTitle: true),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FloatingActionButton(
                      onPressed: () async => {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => InsertEditDialog(
                            isEditing: false,
                            onFinish: _carregarTarefas,
                          ),
                        ),
                      },
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: details.isEmpty
                ? const Center(child: Text('Nenhuma tarefa cadastrada'))
                : ListView.builder(
                    itemCount: details.length,
                    itemBuilder: (context, index) {
                      final tarefa = details[index];
                      return ListTile(
                        title: Text(tarefa.titulo),
                        subtitle: Text(
                          'Prioridade: ${tarefa.prioridade} - Código: ${tarefa.codigoRegistro}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              tarefa.criadoEm.substring(
                                tarefa.criadoEm.length - 10,
                              ),
                            ),
                            FloatingActionButton.small(
                              onPressed: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) =>
                                    InsertEditDialog(
                                      isEditing: true,
                                      itemSelecionado: tarefa,
                                      onFinish: _carregarTarefas,
                                    ),
                              ),
                              child: const Icon(Icons.edit),
                            ),
                            FloatingActionButton.small(
                              heroTag: 'delete_${tarefa.id}',
                              onPressed: () async {
                                await DatabaseHelper.removerTarefa(tarefa.id!);
                                await _carregarTarefas();
                              },
                              child: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
