import 'package:flame/components.dart';
import 'package:flame/events.dart';
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
///
/// Enquanto o jogador arrasta, o item para de cair (DragCallbacks).
class ItemLixo extends PositionComponent with DragCallbacks {
  ItemLixo({
    required this.tipo,
    required Vector2 position,
    required this.aoSoltar,
    this.velocidade = 80,
  }) : super(
          position: position,
          size: Vector2.all(diametro),
          anchor: Anchor.center,
        );

  static const double diametro = 64;

  final TipoLixo tipo;

  /// Chamado quando o jogador solta o item (ou o toque é cancelado).
  final void Function(ItemLixo item) aoSoltar;

  /// Velocidade de queda em px/s. O EcoGame atualiza conforme o nível.
  double velocidade;

  static final TextPaint _emoji =
      TextPaint(style: const TextStyle(fontSize: 32));

  @override
  void update(double dt) {
    super.update(dt);
    if (isDragged) return; // preso ao dedo, não cai
    position.y += velocidade * dt;
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    priority = 10; // fica por cima dos outros itens enquanto arrasta
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position += event.localDelta;

    // Mantém o item dentro da arena.
    final arena = findGame()?.size;
    if (arena == null) return;
    const raio = diametro / 2;
    position.x = position.x.clamp(raio, arena.x - raio).toDouble();
    position.y = position.y.clamp(raio, arena.y - raio).toDouble();
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    priority = 0;
    aoSoltar(this);
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
