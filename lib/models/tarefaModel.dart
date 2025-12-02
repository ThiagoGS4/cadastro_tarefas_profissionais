class Tarefa {
  final int id;
  final String titulo;
  final int prioridade;
  final DateTime criadoEm;
  final int codigoRegistro;

  Tarefa({required this.id, required this.titulo, required this.prioridade, required this.criadoEm, required this.codigoRegistro});

//toMap caso não queira JSON
/*   Map<String, Object?> toMap() {
    return {'id': id, 'titulo': titulo, 'prioridade': prioridade, 'criadoEm': criadoEm, 'codigoRegistro': codigoRegistro};
  } */

  factory Tarefa.fromJson(Map<String,dynamic> json) => Tarefa(
    id: json['id'],
    titulo: json['titulo'],
    prioridade: json['prioridade'],
    criadoEm: json['criadoEm'], 
    codigoRegistro: json['codigoRegistro']
  );

   Map<String,dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'prioridade': prioridade,
    'criadoEm': criadoEm, 
    'codigoRegistro': codigoRegistro
  };

  @override
  String toString() {
    return 'Tarefa{id: $id, titulo: $titulo, prioridade: $prioridade, criadoEm: $criadoEm, codigoRegistro: $codigoRegistro}';
  }
}