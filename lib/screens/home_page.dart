import 'package:flutter/material.dart';
import '../data/dados_estudo.dart';
import '../widget/materia_card.dart';
import 'materia_page.dart';
import 'enem_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StudyFlow')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Áreas de estudo',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.quiz_outlined),
                label: const Text('Questões do ENEM'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EnemPage()),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: materias.length,
                itemBuilder: (context, index) {
                  final materia = materias[index];

                  return MateriaCard(
                    materia: materia,
                    aoTocar: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MateriaPage(materia: materia),
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
