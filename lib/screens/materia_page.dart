import 'package:flutter/material.dart';
import '../models/conteudo.dart';
import '../models/materia.dart';
import '../widget/conteudo_card.dart';
import 'conteudo_page.dart';

class MateriaPage extends StatefulWidget {
  final Materia materia;

  const MateriaPage({
    super.key,
    required this.materia,
  });

  @override
  State<MateriaPage> createState() => _MateriaPageState();
}

class _MateriaPageState extends State<MateriaPage> {
  String filtroSelecionado = 'Todos';

  List<Conteudo> get conteudosFiltrados {
    if (filtroSelecionado == 'Todos') {
      return widget.materia.conteudos;
    }

    return widget.materia.conteudos
        .where((conteudo) => conteudo.nivel == filtroSelecionado)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final conteudos = conteudosFiltrados;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.materia.nome),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.materia.descricao,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Filtrar por nível',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: [
                'Todos',
                'Básico',
                'Intermediário',
                'Avançado',
              ].map((nivel) {
                return ChoiceChip(
                  label: Text(nivel),
                  selected: filtroSelecionado == nivel,
                  onSelected: (_) {
                    setState(() {
                      filtroSelecionado = nivel;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: conteudos.isEmpty
                  ? const Center(
                      child: Text('Nenhum conteúdo neste nível.'),
                    )
                  : ListView.builder(
                      itemCount: conteudos.length,
                      itemBuilder: (context, index) {
                        final conteudo = conteudos[index];

                        return ConteudoCard(
                          conteudo: conteudo,
                          aoTocar: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ConteudoPage(
                                  conteudo: conteudo,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}