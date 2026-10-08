import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/questao_enem.dart';

class EnemService {
  Future<void> _fila = Future<void>.value();
  DateTime? _ultimoPedido;
  final Map<int, List<QuestaoEnem>> _cache = {};

  Future<dynamic> _obter(Uri uri) {
    final pedido = _fila.then((_) async {
      if (_ultimoPedido != null) {
        final intervalo = DateTime.now().difference(_ultimoPedido!);
        final espera = const Duration(milliseconds: 1100) - intervalo;
        if (espera > Duration.zero) await Future.delayed(espera);
      }
      _ultimoPedido = DateTime.now();
      final resposta = await http.get(uri).timeout(
        const Duration(seconds: 20),
      );
      if (resposta.statusCode != 200) {
        throw Exception('A API respondeu com status ${resposta.statusCode}.');
      }
      return jsonDecode(utf8.decode(resposta.bodyBytes));
    });
    // Um pedido com erro não bloqueia as próximas tentativas.
    _fila = pedido.then<void>((valor) {},
        onError: (Object erro, StackTrace pilha) {});
    return pedido;
  }

  Future<List<int>> buscarAnos() async {
    final itens = await _obter(
      Uri.https('api.enem.dev', '/v1/exams'),
    ) as List<dynamic>;
    return itens
        .map((item) => (item as Map<String, dynamic>)['year'] as int)
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));
  }

  Future<List<QuestaoEnem>> buscarQuestoes({required int ano}) async {
    if (_cache.containsKey(ano)) return List.of(_cache[ano]!);
    final questoes = <QuestaoEnem>[];
    final numerosVistos = <int>{};
    var offset = 0;
    var temMais = true;

    while (temMais) {
      final dados = await _obter(Uri.https(
        'api.enem.dev',
        '/v1/exams/$ano/questions',
        {'limit': '50', 'offset': '$offset', 'language': 'ingles'},
      )) as Map<String, dynamic>;
      final itens = dados['questions'] as List<dynamic>;
      final metadata = dados['metadata'] as Map<String, dynamic>;
      temMais = metadata['hasMore'] == true;

      if (itens.isEmpty && temMais) {
        throw Exception('A API retornou uma página sem avanço.');
      }
      for (final item in itens) {
        final questao = QuestaoEnem.fromJson(item as Map<String, dynamic>);
        if (numerosVistos.add(questao.numero)) questoes.add(questao);
      }
      offset += metadata['limit'] as int;
    }

    _cache[ano] = List.of(questoes);
    return questoes;
  }
}