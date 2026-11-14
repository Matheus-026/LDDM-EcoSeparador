import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../services/pontuacao_service.dart';
import '../theme/cores.dart';

/// Esqueleto do jogo. A frente A coloca aqui o item que cai, o sorteio e o arrasto.
class EcoGame extends FlameGame {
  EcoGame(this.service);

  final PontuacaoService service;

  @override
  Color backgroundColor() => Cores.papel;

  @override
  Future<void> onLoad() async {
    add(
      TextComponent(
        text: 'Flame rodando ✔',
        position: Vector2(16, 16),
        textRenderer: TextPaint(style: Tema.texto(tamanho: 16)),
      ),
    );
  }
}