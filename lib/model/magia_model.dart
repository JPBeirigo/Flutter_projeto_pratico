class Magia {
  final String id;
  final String nome;
  final String nivel;
  final String descricao;
  final String escola;
  final String tempoConjuracao;
  final String alcance;
  final String componentes;

  Magia({
    required this.id,
    required this.nome,
    required this.nivel,
    required this.descricao,
    required this.escola,
    required this.tempoConjuracao,
    required this.alcance,
    required this.componentes,
  });

  factory Magia.fromMap(String id, Map<String, dynamic> map) {
    return Magia(
      id: id,
      nome: map['nome'] ?? '',
      nivel: map['nivel'] ?? '',
      descricao: map['descricao'] ?? '',
      escola: map['escola'] ?? '',
      tempoConjuracao: map['tempoConjuracao'] ?? '',
      alcance: map['alcance'] ?? '',
      componentes: map['componentes'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'nivel': nivel,
      'descricao': descricao,
      'escola': escola,
      'tempoConjuracao': tempoConjuracao,
      'alcance': alcance,
      'componentes': componentes,
    };
  }
}
