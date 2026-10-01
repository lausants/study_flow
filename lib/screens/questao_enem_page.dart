import 'package:flutter/material.dart';

import '../models/questao_enem.dart';

class QuestaoEnemPage extends StatefulWidget {
  final QuestaoEnem questao;

  const QuestaoEnemPage({
    super.key,
    required this.questao,
  });

  @override
  State<QuestaoEnemPage> createState() => _QuestaoEnemPageState();
}

class _QuestaoEnemPageState extends State<QuestaoEnemPage> {
  String? _resposta;

  Widget _imagem(String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Image.network(
        url,
        errorBuilder: (context, error, stackTrace) {
          return const Text('Imagem indisponível nesta questão.');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.questao;

    return Scaffold(
      appBar: AppBar(
        title: Text('Questão ${q.numero}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            q.titulo,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(q.disciplina),
          const SizedBox(height: 20),
          if (q.enunciado.isNotEmpty) Text(q.enunciado),
          for (final imagem in q.imagens) _imagem(imagem),
          if (q.introducao.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(q.introducao),
          ],
          const SizedBox(height: 12),
          for (final alternativa in q.alternativas)
            Card(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _resposta = alternativa.letra;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${alternativa.letra}) ${alternativa.texto}',
                      ),
                      if (alternativa.imagem != null)
                        _imagem(alternativa.imagem!),
                    ],
                  ),
                ),
              ),
            ),
          if (_resposta != null) ...[
            const SizedBox(height: 16),
            Text(
              q.gabarito == null
                  ? 'Resposta registrada: $_resposta. Gabarito indisponível.'
                  : _resposta == q.gabarito
                      ? 'Você acertou! Gabarito: ${q.gabarito}'
                      : 'Você marcou $_resposta. Gabarito: ${q.gabarito}',
            ),
          ],
        ],
      ),
    );
  }
}