import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/questao_enem.dart';

class EnemService {
  Future<List<QuestaoEnem>> buscarQuestoes({int ano = 2022}) async {
    final uri = Uri.https(
      'api.enem.dev',
      'v1/exams/$ano/questions',
      {'limit': '10', 'offset': '0'},
    );
    final resposta = await http.get(uri).timeout(
      const Duration(seconds: 15),
    );

    if (resposta.statusCode != 200) {
      throw Exception('A API respondeu com o status ${resposta.statusCode}.');
    }

    final decoded = jsonDecode(utf8.decode(resposta.bodyBytes));
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Formato inesperado na resposta da API.');
    }   
    final itens = decoded['questions'];
    if (itens is! List) {
      throw const FormatException('A resposta da API não contém a lista questions.');
    }

    return itens
        .whereType<Map<String, dynamic>>()
        .map(QuestaoEnem.fromJson)
        .toList();
  }
}
