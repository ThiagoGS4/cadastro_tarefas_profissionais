import 'package:cadastro_tarefas_profissionais/services/databaseHelper.dart';
import 'package:cadastro_tarefas_profissionais/widgets/insertEditDialog.dart';
import 'package:flutter/material.dart';
import '../models/tarefaModel.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  List<Tarefa> details = [];
  bool _ordenarPorPrioridade = false;

  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  Future<void> _carregarTarefas() async {
    final lista = await DatabaseHelper.listarTarefas();
    setState(() {
      details = lista ?? [];
      if (_ordenarPorPrioridade) {
        _aplicarOrdenacao();
      }
    });
  }

  void _toggleOrdenacaoPrioridade() {
    setState(() {
      _ordenarPorPrioridade = !_ordenarPorPrioridade;
      _aplicarOrdenacao();
    });
  }

  void _aplicarOrdenacao() {
    if (_ordenarPorPrioridade) {
      details.sort((a, b) => a.prioridade.compareTo(b.prioridade));
    } else {
      details.sort((a, b) => b.criadoEm.compareTo(a.criadoEm));
    }
  }

  String formatarData(String criadoEm) {
    final dt = DateTime.parse(criadoEm);
    return DateFormat('dd/MM/yyyy HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _ordenarPorPrioridade ? Icons.sort_by_alpha : Icons.sort,
            ),
            tooltip: _ordenarPorPrioridade
                ? 'Ordenar por data'
                : 'Ordenar por prioridade',
            onPressed: _toggleOrdenacaoPrioridade,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  color: const Color.fromARGB(221, 34, 34, 34),
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.list_alt),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Minhas tarefas',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Adicione ou edite tarefas profissionais',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 58, 58, 58),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: _ordenarPorPrioridade
                          ? 'Ordenar por data'
                          : 'Ordenar por prioridade',
                      icon: Icon(
                        _ordenarPorPrioridade
                            ? Icons.filter_alt_off
                            : Icons.filter_alt,
                      ),
                      onPressed: _toggleOrdenacaoPrioridade,
                    ),
                    const SizedBox(width: 4),
                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) => InsertEditDialog(
                            isEditing: false,
                            onFinish: _carregarTarefas,
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Nova'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: details.isEmpty
                ? const Center(child: Text('Nenhuma tarefa cadastrada'))
                : ListView.builder(
                    itemCount: details.length,
                    itemBuilder: (context, index) {
                      final tarefa = details[index];
                      final prioridade = PrioridadeLabel.fromPrio(
                        tarefa.prioridade,
                      );
                      return Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                            color: const Color.fromARGB(221, 34, 34, 34),
                            width: 1.0,
                          ),
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: prioridade.color,
                            child: Text(
                              prioridade.prio.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(tarefa.titulo),
                          subtitle: Text(
                            'Descrição: ${tarefa.descricao}\n'
                            '${PrioridadeLabel.fromPrio(tarefa.prioridade).text} • '
                            'Código: ${tarefa.codigoRegistro}\n'
                            'Criado em: ${formatarData(tarefa.criadoEm)}',
                          ),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                        Theme.of(context).colorScheme.primary,
                                      ),
                                ),
                                onPressed: () async {
                                  final resultado = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => InsertEditDialog(
                                      isEditing: true,
                                      itemSelecionado: tarefa,
                                      onFinish: _carregarTarefas,
                                    ),
                                  );
                                  if (resultado == true) {
                                    await _carregarTarefas();
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                        Colors.red,
                                      ),
                                ),
                                onPressed: () async {
                                  await DatabaseHelper.removerTarefa(
                                    tarefa.id!,
                                  );
                                  await _carregarTarefas();
                                },
                              ),
                            ],
                          ),
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
