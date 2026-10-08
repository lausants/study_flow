import 'package:flutter/material.dart';

import '../models/questao_enem.dart';

class SimuladoPage extends StatefulWidget {
  final List<QuestaoEnem> questoes;
  final int ano;
  final String area;

  const SimuladoPage({
    super.key,
    required this.questoes,
    required this.ano,
    required this.area,
  });

  @override
  State<SimuladoPage> createState() => _SimuladoPageState();
}

class _SimuladoPageState extends State<SimuladoPage> {
  int _indice = 0;
  int _acertos = 0;
  String? _marcada;

  bool get _terminou => _indice >= widget.questoes.length;

  void _responder(String letra) {
    if (_marcada != null) return;
    setState(() {
      _marcada = letra;
      if (letra == widget.questoes[_indice].gabarito) {
        _acertos++;
      }
    });
  }

  void _proxima() {
    setState(() {
      _indice++;
      _marcada = null;
    });
  }

  void _reiniciar() {
    setState(() {
      _indice = 0;
      _acertos = 0;
      _marcada = null;
    });
  }

  Widget _imagem(String url) {
    return Image.network(
      url,
      errorBuilder: (context, error, stackTrace) {
        return const Text('Imagem indisponível.');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_terminou) {
      final total = widget.questoes.length;
      final percentual = (_acertos * 100 / total).round();

      return Scaffold(
        appBar: AppBar(title: const Text('Resultado')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$_acertos de $total acertos'),
              Text('$percentual% de aproveitamento'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _reiniciar,
                child: const Text('Refazer'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Voltar à seleção'),
              ),
            ],
          ),
        ),
      );
    }

    final q = widget.questoes[_indice];

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.area} • ${widget.ano}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Questão ${_indice + 1} de ${widget.questoes.length}'),
          const SizedBox(height: 12),
          Text(q.titulo, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          if (q.enunciado.isNotEmpty) Text(q.enunciado),
          for (final url in q.imagens) _imagem(url),
          if (q.introducao.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(q.introducao),
          ],
          const SizedBox(height: 12),
          for (final alternativa in q.alternativas)
            Card(
              child: InkWell(
                onTap: () => _responder(alternativa.letra),
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
          if (_marcada != null) ...[
            const SizedBox(height: 12),
            Text(
              _marcada == q.gabarito
                  ? 'Correto! +1 ponto.'
                  : 'Incorreto. Gabarito: ${q.gabarito}.',
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _proxima,
              child: Text(
                _indice == widget.questoes.length - 1
                    ? 'Ver resultado'
                    : 'Próxima questão',
              ),
            ),
          ],
        ],
      ),
    );
  }
}