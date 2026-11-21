import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../models/tipo_lixo.dart';
import '../theme/cores.dart';
import 'desenho_item.dart';

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

    // Figura do item desenhada com formas (sem emoji, sem depender de fonte).
    desenharItem(canvas, tipo, centro, raio);
  }
}