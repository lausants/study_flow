import 'package:flutter/material.dart';

import '../models/questao_enem.dart';
import '../services/enem_services.dart';
import 'simulado_page.dart';

class EnemPage extends StatefulWidget {
  const EnemPage({super.key});

  @override
  State<EnemPage> createState() => _EnemPageState();
}

class _EnemPageState extends State<EnemPage> {
  final _service = EnemService();

  final Map<String, String> _areas = const {
    'Matemática': 'matematica',
    'Linguagens': 'linguagens',
    'Ciências Humanas': 'ciencias-humanas',
    'Ciências da Natureza': 'ciencias-natureza',
  };

  late Future<List<int>> _anos;
  Future<List<QuestaoEnem>>? _questoes;
  int? _ano;
  String _area = 'Matemática';

  @override
  void initState() {
    super.initState();
    _anos = _service.buscarAnos();
  }

  void _selecionarAno(int ano) {
    setState(() {
      _ano = ano;
      _questoes = _service.buscarQuestoes(ano: ano);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Questões do ENEM')),
      body: FutureBuilder<List<int>>(
        future: _anos,
        builder: (context, anosSnapshot) {
          if (anosSnapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (anosSnapshot.hasError) {
            return Center(
              child: ElevatedButton(
                onPressed: () => setState(() {
                  _anos = _service.buscarAnos();
                }),
                child: const Text('Erro ao buscar anos. Tentar novamente'),
              ),
            );
          }

          final anos = anosSnapshot.data!;
          if (anos.isEmpty) {
            return const Center(child: Text('Nenhum ano disponível.'));
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<int>(
                  initialValue: _ano,
                  decoration: const InputDecoration(labelText: 'Ano'),
                  items: [
                    for (final ano in anos)
                      DropdownMenuItem(value: ano, child: Text('$ano')),
                  ],
                  onChanged: (ano) {
                    if (ano != null) _selecionarAno(ano);
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _area,
                  decoration: const InputDecoration(labelText: 'Área'),
                  items: [
                    for (final nome in _areas.keys)
                      DropdownMenuItem(value: nome, child: Text(nome)),
                  ],
                  onChanged: (nome) {
                    if (nome != null) setState(() => _area = nome);
                  },
                ),
                const SizedBox(height: 20),
                if (_questoes == null)
                  const Text('Escolha um ano para carregar as questões.')
                else
                  Expanded(
                    child: FutureBuilder<List<QuestaoEnem>>(
                      future: _questoes,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Falha ao carregar: ${snapshot.error}'),
                                ElevatedButton(
                                  onPressed: () => _selecionarAno(_ano!),
                                  child: const Text('Tentar novamente'),
                                ),
                              ],
                            ),
                          );
                        }

                        final filtradas = snapshot.data!
                            .where((q) => q.disciplina == _areas[_area])
                            .where((q) =>
                                q.alternativas.isNotEmpty &&
                                q.gabarito != null)
                            .toList();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              '${filtradas.length} questões disponíveis '
                              'em $_area (${_ano!}).',
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: filtradas.isEmpty
                                  ? null
                                  : () {
                                      final selecionadas = [...filtradas]
                                        ..shuffle();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => SimuladoPage(
                                            questoes: selecionadas
                                                .take(5)
                                                .toList(),
                                            ano: _ano!,
                                            area: _area,
                                          ),
                                        ),
                                      );
                                    },
                              child: const Text('Iniciar simulado'),
                            ),
                            if (filtradas.isEmpty)
                              const Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: Text(
                                  'Não há questões completas nesta área '
                                  'para esta edição.',
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}