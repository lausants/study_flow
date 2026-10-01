import 'package:flutter/material.dart';
import '../models/conteudo.dart';

class ConteudoPage extends StatelessWidget {
  final Conteudo conteudo;

  const ConteudoPage({
    super.key,
    required this.conteudo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(conteudo.titulo),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              conteudo.titulo,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Chip(
              label: Text('Nível: ${conteudo.nivel}'),
            ),
            const SizedBox(height: 20),
            Text(
              conteudo.descricao,
              style: const TextStyle(
                fontSize: 17,
                height: 1.5,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Voltar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}