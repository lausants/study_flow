import 'package:flutter/material.dart';
import '../models/conteudo.dart';

class ConteudoCard extends StatelessWidget {
  final Conteudo conteudo;
  final VoidCallback aoTocar;

  const ConteudoCard({
    super.key,
    required this.conteudo,
    required this.aoTocar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(conteudo.titulo),
        subtitle: Text(conteudo.nivel),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: aoTocar,
      ),
    );
  }
}	
