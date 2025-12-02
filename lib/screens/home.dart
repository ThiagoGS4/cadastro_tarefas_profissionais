import 'package:cadastro_tarefas_profissionais/services/databaseHelper.dart';
import 'package:flutter/material.dart';
import '../models/tarefaModel.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  final tituloController = TextEditingController();
  final prioridadeController = TextEditingController();
  final codigoRegistroController = TextEditingController();

  List<Tarefa> details = [];

  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  Future<void> _carregarTarefas() async {
    final lista = await DatabaseHelper.listarTarefas();
    setState(() {
      details = lista!;
    });
  }

  Future<void> _inserirTarefa() async {
    final Tarefa model = Tarefa(
      titulo: "titulo teste",
      prioridade: 1,
      criadoEm: DateTime.now().toString(),
      codigoRegistro: "codigoRegistro teste",
    );

    await DatabaseHelper.inserirTarefa(model);
    await _carregarTarefas(); // recarrega a lista depois de inserir
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tarefas'), centerTitle: true),
      body: Column(
        children: [
          Row(
            children: [
              FloatingActionButton(
                onPressed: () async {
                  await _inserirTarefa();
                },
                child: const Icon(Icons.add),
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
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
