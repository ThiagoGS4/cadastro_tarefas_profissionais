import 'dart:collection';

import 'package:cadastro_tarefas_profissionais/models/tarefaModel.dart';
import 'package:cadastro_tarefas_profissionais/services/databaseHelper.dart';
import 'package:flutter/material.dart';

PrioridadeLabel? selectedPrio;

typedef PrioridadeEntry = DropdownMenuEntry<PrioridadeLabel>;

enum PrioridadeLabel {
  emergente(1, 'Emergente', Colors.red),
  murgente(2, 'Muito Urgente', Colors.orange),
  urgente(3, 'Urgente', Colors.yellow),
  purgente(4, 'Pouco Urgente', Colors.lightGreen),
  nurgente(5, 'Não Urgente', Colors.lightBlue);

  const PrioridadeLabel(this.prio, this.text, this.color);
  final int prio;
  final String text;
  final Color color;

  static PrioridadeLabel fromPrio(int prio) {
    return values.firstWhere((p) => p.prio == prio, orElse: () => nurgente);
  }

  static final List<PrioridadeEntry> entries =
      UnmodifiableListView<PrioridadeEntry>(
        values.map<PrioridadeEntry>(
          (PrioridadeLabel prio) => PrioridadeEntry(
            value: prio,
            label: prio.text,
            style: MenuItemButton.styleFrom(foregroundColor: prio.color),
          ),
        ),
      );
}

class InsertEditDialog extends StatefulWidget {
  final bool isEditing;
  final Tarefa? itemSelecionado;
  final VoidCallback? onFinish;

  const InsertEditDialog({
    super.key,
    required this.isEditing,
    this.itemSelecionado,
    this.onFinish,
  });

  @override
  State<InsertEditDialog> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<InsertEditDialog> {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController prioController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController codigoRegistroController =
      TextEditingController();
  bool autoGerarCodigoRegistro = false;

  PrioridadeLabel? prioObject;
  int? selectedPrio;

  @override
  void initState() {
    super.initState();

    if (widget.isEditing && widget.itemSelecionado != null) {
      final t = widget.itemSelecionado!;
      tituloController.text = t.titulo;
      descricaoController.text = t.descricao;
      codigoRegistroController.text = t.codigoRegistro;

      prioObject = PrioridadeLabel.values.firstWhere(
        (p) => p.prio == t.prioridade,
        orElse: () => PrioridadeLabel.nurgente,
      );
      selectedPrio = t.prioridade;
    } else {
      prioObject = PrioridadeLabel.nurgente;
      selectedPrio = PrioridadeLabel.nurgente.prio;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Text(
                    widget.isEditing ? 'Editando Terefa' : 'Adicionando Tarefa',
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: TextFormField(
                    controller: tituloController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Título',
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: TextFormField(
                    controller: descricaoController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Descrição',
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: DropdownMenu<PrioridadeLabel>(
                    initialSelection: prioObject,
                    width: double.infinity,
                    requestFocusOnTap: false,
                    label: const Text('Prioridade'),
                    onSelected: (PrioridadeLabel? prio) {
                      setState(() {
                        prioObject = prio;
                        selectedPrio = prio?.prio;
                      });
                    },
                    dropdownMenuEntries: PrioridadeLabel.entries,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Auto gerar código de registro?"),
                          Checkbox(
                            value: autoGerarCodigoRegistro,
                            onChanged: (bool? value) {
                              setState(() {
                                autoGerarCodigoRegistro = value ?? false;
                                codigoRegistroController.text = "";
                              });
                            },
                          ),
                        ],
                      ),

                      TextFormField(
                        controller: codigoRegistroController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Código de Registro',
                        ),
                        enabled: !autoGerarCodigoRegistro,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          FloatingActionButton(
            onPressed: () async {
              widget.isEditing
                  ? await _atualizarTarefa()
                  : await _inserirTarefa();

              widget.onFinish?.call();
              Navigator.pop(context);
            },
            child: Icon(
              widget.isEditing ? Icons.edit_document : Icons.add_task,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Fechar'),
            ),
          ),
        ],
      ),
    );
  }

  String gerarCodigoRegistro(DateTime dt) {
    final ano = dt.year.toString().padLeft(4, '0');
    final mes = dt.month.toString().padLeft(2, '0');
    final dia = dt.day.toString().padLeft(2, '0');
    final hora = dt.hour.toString().padLeft(2, '0');
    final minuto = dt.minute.toString().padLeft(2, '0');
    final segundo = dt.second.toString().padLeft(2, '0');

    return '$ano$mes$dia$hora$minuto$segundo';
  }

  Future<void> _inserirTarefa() async {
    final prioNum = selectedPrio ?? PrioridadeLabel.nurgente.prio;

    if (autoGerarCodigoRegistro) {
      codigoRegistroController.text = gerarCodigoRegistro(DateTime.now());
    }

    final Tarefa model = Tarefa(
      titulo: tituloController.value.text,
      prioridade: prioNum,
      descricao: descricaoController.value.text,
      criadoEm: DateTime.now().toString(),
      codigoRegistro: codigoRegistroController.value.text,
    );

    await DatabaseHelper.inserirTarefa(model);
  }

  Future<void> _atualizarTarefa() async {
    final prioNum = selectedPrio ?? PrioridadeLabel.nurgente.prio;

    if (autoGerarCodigoRegistro) {
      codigoRegistroController.text = gerarCodigoRegistro(DateTime.now());
    }
    final Tarefa model = Tarefa(
      id: widget.itemSelecionado!.id,
      titulo: tituloController.value.text,
      prioridade: prioNum,
      descricao: descricaoController.value.text,
      criadoEm: DateTime.now().toString(),
      codigoRegistro: codigoRegistroController.value.text,
    );

    await DatabaseHelper.atualizarTarefa(model);
  }
}
