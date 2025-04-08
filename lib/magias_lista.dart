import '../model/magia_model.dart';

final List<Magia> magias = [
  Magia(
    nome: 'Bola de Fogo',
    nivel: 3,
    descricao: 'Uma explosão flamejante que causa 8d6 de dano em área.',
  ),
  Magia(
    nome: 'Mísseis Mágicos',
    nivel: 1,
    descricao: 'Três dardos de energia que atingem automaticamente o alvo, cada missel causando 1d4+1 de dano.',
  ),
  Magia(
    nome: 'Escudo Arcano',
    nivel: 1,
    descricao: 'Cria uma barreira mágica que aumenta a CA em +5 até o início do seu próximo turno.',
  ),
  Magia(
    nome: 'Luz',
    nivel: 0,
    descricao: 'Ilumina um objeto tocado com luz brilhante por até 1 hora.',
  ),
];
