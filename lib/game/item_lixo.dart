import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../models/tipo_lixo.dart';
import '../theme/cores.dart';

/// Emoji de cada tipo de lixo (aparência provisória, a frente D pode trocar
/// por sprites depois).
extension TipoLixoEmoji on TipoLixo {
  String get emoji => switch (this) {
        TipoLixo.papel => '📰',
        TipoLixo.plastico => '🍾',
        TipoLixo.vidro => '🫙',
        TipoLixo.metal => '🥫',
      };
}

/// Item de lixo que cai pela arena.
///
/// A posição é o CENTRO do item (anchor center). Quem decide o que acontece
/// quando ele chega ao chão ou é solto é o EcoGame.
class ItemLixo extends PositionComponent {
  ItemLixo({
    required this.tipo,
    required Vector2 position,
    this.velocidade = 80,
  }) : super(
          position: position,
          size: Vector2.all(diametro),
          anchor: Anchor.center,
        );

  static const double diametro = 64;

  final TipoLixo tipo;

  /// Velocidade de queda em px/s. O EcoGame atualiza conforme o nível.
  double velocidade;

  static final TextPaint _emoji =
      TextPaint(style: const TextStyle(fontSize: 32));

  @override
  void update(double dt) {
    super.update(dt);
    position.y += velocidade * dt;
  }

  @override
  void render(Canvas canvas) {
    final centro = Offset(size.x / 2, size.y / 2);
    final raio = size.x / 2;

    // Sombra dura, como no resto do tema.
    canvas.drawCircle(
      centro.translate(0, Tema.alturaSombra),
      raio,
      Paint()..color = Cores.contorno,
    );
    canvas.drawCircle(centro, raio, Paint()..color = Cores.superficie);
    canvas.drawCircle(
      centro,
      raio - Tema.borda / 2,
      Paint()
        ..color = Cores.contorno
        ..style = PaintingStyle.stroke
        ..strokeWidth = Tema.borda,
    );

    _emoji.render(
      canvas,
      tipo.emoji,
      Vector2(size.x / 2, size.y / 2),
      anchor: Anchor.center,
    );
  }
}
