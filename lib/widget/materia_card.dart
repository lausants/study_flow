import 'package:flutter/material.dart';
import '../models/materia.dart';

class MateriaCard extends StatelessWidget {
  final Materia materia;
  final VoidCallback aoTocar;

  const MateriaCard({
    super.key,
    required this.materia,
    required this.aoTocar,
  });

  @override
  Widget build(BuildContext context){
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          materia.nome,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            '${materia.conteudos.length} conteúdos'
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: aoTocar,
      ),
    );
  }
}