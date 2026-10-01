class AlternativaEnem {
  final String letra;
  final String texto;
  final String? imagem;
  const AlternativaEnem({
    required this.letra,
    required this.texto,
    required this.imagem,
  });

  factory AlternativaEnem.fromJson(Map<String, dynamic> json) {
    return AlternativaEnem(
      letra: json['letter'] as String? ?? '',
      texto: json['text'] as String? ?? '',
      imagem: json['file'] as String?,
    );
  }
}

class QuestaoEnem {
  final int numero;
  final String titulo;
  final String disciplina;
  final String enunciado;
  final String introducao;
  final String? gabarito;
  final List<String> imagens;
  final List<AlternativaEnem> alternativas;
  const QuestaoEnem({
    required this.numero,
    required this.titulo,
    required this.disciplina,
    required this.enunciado,
    required this.introducao,
    required this.gabarito,
    required this.imagens,
    required this.alternativas,
  });
  factory QuestaoEnem.fromJson(Map<String, dynamic> json) {
    return QuestaoEnem(
      numero: (json['index'] as num?)?.toInt() ?? 0,
      titulo: json['title'] as String? ?? 'Questão sem título',
      disciplina: json['discipline'] as String? ?? 'Não informada',
      enunciado: json['context'] as String? ?? '',
      introducao: json['alternativasIntroduction'] as String? ?? '',
      gabarito: json['correctAlternative'] as String?,
      imagens: (json['files'] as List<dynamic>? ?? [])
          .whereType<String>()
          .toList(),
      alternativas: (json['alternatives'] as List<dynamic>? ?? [])
          .map((item) => AlternativaEnem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
