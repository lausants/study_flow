import 'conteudo.dart';

class Materia {
  final String nome;
  final String descricao;
  final List<Conteudo> conteudos;

  const Materia({
    required this.nome,
    required this.descricao,
    required this.conteudos,
  });
}