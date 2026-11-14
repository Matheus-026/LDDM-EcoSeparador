class Conquista {
  const Conquista({
    required this.id,
    required this.titulo,
    required this.descricao,
    this.desbloqueada = false,
  });

  final String id;
  final String titulo;
  final String descricao;
  final bool desbloqueada;
}