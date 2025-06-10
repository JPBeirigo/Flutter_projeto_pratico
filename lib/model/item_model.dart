class Item {
  final String nome;
  final int valor;
  final String descricao;
  final double peso; // em libras (lb)
  final int quantidade;

  Item({
    required this.nome,
    required this.valor,
    required this.descricao,
    required this.peso,
    required this.quantidade,
  });

  // Converte o objeto Item para um Map (para salvar no Firebase)
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'valor': valor,
      'descricao': descricao,
      'peso': peso,
      'quantidade': quantidade,
    };
  }

  // Cria um Item a partir de um Map (para ler do Firebase)
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      nome: map['nome'] ?? '',
      valor: map['valor'] ?? 0,
      descricao: map['descricao'] ?? '',
      peso: (map['peso'] ?? 0).toDouble(),
      quantidade: map['quantidade'] ?? 1,
    );
  }
}
