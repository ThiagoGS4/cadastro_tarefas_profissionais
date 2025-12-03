class Tarefa {
  final int? id;
  final String titulo;
  final String descricao;
  final int prioridade;
  final String criadoEm;
  final String codigoRegistro;
  Tarefa({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.prioridade,
    required this.criadoEm,
    required this.codigoRegistro,
  });
  factory Tarefa.fromJson(Map<String, dynamic> json) => Tarefa(
    id: json['id'],
    titulo: json['titulo'],
    descricao: json['descricao'],
    prioridade: json['prioridade'],
    criadoEm: json['criadoEm'],
    codigoRegistro: json['codigoRegistro'],
  );
  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'descricao': descricao,
    'prioridade': prioridade,
    'criadoEm': criadoEm,
    'codigoRegistro': codigoRegistro,
  };
}
