import 'package:flutter/material.dart';
import '../models/questao_enem.dart';
import '../services/enem_services.dart';
import 'questao_enem_page.dart';
class EnemPage extends StatefulWidget {
	const EnemPage({super.key});
	@override
	State<EnemPage> createState() => _EnemPageState();
}
class _EnemPageState extends State<EnemPage> {
	final _service = EnemServices();
	late Future<List<QuestaoEnem>> _busca;
	@override
	void initState() {
		super.initState();
		_busca = _service.buscarQuestoes();
	}
	void _tentarNovamente() {
		setState(() {
			_busca = _service.buscarQuestoes();
		});
	}
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text('Questões do ENEM 2020')),
			body: FutureBuilder<List<QuestaoEnem>>(
				future: _busca,
				builder: (context, snapshot) {
					if (snapshot.connectionState != ConnectionState.done) {
						return const Center(child: CircularProgressIndicator());
					}
					if (snapshot.hasError) {
						return Center(
							child: Column(
								mainAxisSize: MainAxisSize.min,
								children: [
									const Text('Não foi possível carregar as questões.'),
									const SizedBox(height: 12),
									ElevatedButton(
										onPressed: _tentarNovamente,
										child: const Text('Tentar novamente'),
									),
								],
							),
						);
					}
					final questoes = snapshot.data ?? [];
					if (questoes.isEmpty) {
						return const Center(child: Text('Nenhuma questão encontrada.'));
					}
					return ListView.builder(
						padding: const EdgeInsets.all(16),
						itemCount: questoes.length,
						itemBuilder: (context, index) {
							final questao = questoes[index];
							return Card(
								child: ListTile(
									title: Text(questao.titulo),
									subtitle: Text(questao.disciplina),
									trailing: const Icon(Icons.chevron_right),
									onTap: () {
										Navigator.push(
											context,
											MaterialPageRoute(
												builder: (_) => QuestaoEnemPage(questao: questao),
											),
										);
									},
								),
							);
						},
					);
				},
			),
		);
	}
}