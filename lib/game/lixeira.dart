import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/services.dart' show HapticFeedback;

import '../models/tipo_lixo.dart';
import '../theme/cores.dart';

/// Lixeira da coleta seletiva (Resolução CONAMA 275/2001).
///
/// Só desenha e dá feedback. Quem decide acerto/erro e chama o
/// PontuacaoService é o EcoGame.
class Lixeira extends PositionComponent {
  Lixeira({
    required this.tipo,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  final TipoLixo tipo;

  // Feedback controlado no update(dt), sem depender da API de Effects.
  static const double _duracao = 0.35;
  double _flashRestante = 0;
  double _tremorRestante = 0;
  Color _corFlash = const Color(0xFFFFFFFF);

  late final TextPaint _rotulo = TextPaint(
    style: Tema.titulo(tamanho: 13),
  );

  /// Acerto = tipos iguais (contrato 6.3).
  bool aceita(TipoLixo tipoDoItem) => tipoDoItem == tipo;

  /// Flash claro + vibração leve.
  void feedbackAcerto() {
    _corFlash = const Color(0xFFFFFFFF);
    _flashRestante = _duracao;
    HapticFeedback.lightImpact();
  }

  /// Flash vermelho + tremor + vibração forte.
  void feedbackErro() {
    _corFlash = const Color(0xFFD62828);
    _flashRestante = _duracao;
    _tremorRestante = _duracao;
    HapticFeedback.heavyImpact();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_flashRestante > 0) _flashRestante = math.max(0, _flashRestante - dt);
    if (_tremorRestante > 0) {
      _tremorRestante = math.max(0, _tremorRestante - dt);
    }
  }

  @override
  void render(Canvas canvas) {
    // O tremor desloca só o desenho. A posição (e a área de soltura)
    // continua exata.
    if (_tremorRestante > 0) {
      final forca = _tremorRestante / _duracao;
      canvas.translate(math.sin(_tremorRestante * 80) * 6 * forca, 0);
    }

    final corpo = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 12, size.x, size.y - 12),
      const Radius.circular(12),
    );
    final tampa = RRect.fromRectAndRadius(
      Rect.fromLTWH(-4, 0, size.x + 8, 14),
      const Radius.circular(6),
    );

    final preenchimento = Paint()..color = tipo.cor;
    final borda = Paint()
      ..color = Cores.contorno
      ..style = PaintingStyle.stroke
      ..strokeWidth = Tema.borda;

    canvas.drawRRect(corpo, preenchimento);
    canvas.drawRRect(tampa, preenchimento);

    if (_flashRestante > 0) {
      final alfa = (_flashRestante / _duracao * 150).round();
      final flash = Paint()..color = _corFlash.withAlpha(alfa);
      canvas.drawRRect(corpo, flash);
      canvas.drawRRect(tampa, flash);
    }

    canvas.drawRRect(corpo, borda);
    canvas.drawRRect(tampa, borda);

    _rotulo.render(
      canvas,
      tipo.rotulo,
      Vector2(size.x / 2, size.y / 2 + 6),
      anchor: Anchor.center,
    );
  }
}