import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../models/tipo_lixo.dart';
import '../services/pontuacao_service.dart';
import '../theme/cores.dart';
import 'item_lixo.dart';
import 'lixeira.dart';

/// Jogo da coleta seletiva: sorteia itens que caem e (nos próximos passos)
/// deixa o jogador arrastá-los até a lixeira certa.
class EcoGame extends FlameGame {
  EcoGame(this.service, {math.Random? random})
      : _random = random ?? math.Random();

  final PontuacaoService service;
  final math.Random _random;

  /// Faixa da base da arena, reservada para as lixeiras.
  /// O item que encosta nela sem ter sido solto é um item perdido.
  static const double alturaFaixaLixeiras = 112;

  static const double _tempoAteOPrimeiroItem = 0.8;

  final List<Lixeira> _lixeiras = [];

  double _tempoParaProximo = _tempoAteOPrimeiroItem;
  bool _encerrado = false;

  /// Contrato da frente A: 80 + 15 × (nível − 1) px/s.
  static double velocidadeDeQueda(int nivel) => 80.0 + 15.0 * (nivel - 1);

  /// Segundos entre um item e o próximo. Diminui com o nível, com piso.
  static double intervaloDeSorteio(int nivel) =>
      math.max(0.9, 2.0 - 0.1 * (nivel - 1));

  double get _chaoY => size.y - alturaFaixaLixeiras;

  @override
  Color backgroundColor() => Cores.papel;

  @override
  Future<void> onLoad() async {
    for (final tipo in TipoLixo.values) {
      final lixeira = Lixeira(
        tipo: tipo,
        position: Vector2.zero(),
        size: Vector2.zero(),
      );
      _lixeiras.add(lixeira);
      add(lixeira);
    }
    _posicionarLixeiras();
    service.addListener(_aoMudarService);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _posicionarLixeiras(); // não faz nada antes do onLoad criar as lixeiras
  }

  /// Alinha as 4 lixeiras na base, dividindo a largura igualmente.
  void _posicionarLixeiras() {
    if (_lixeiras.isEmpty) return;
    const margem = 12.0;
    const espaco = 8.0;
    final n = _lixeiras.length;
    final largura = (size.x - 2 * margem - (n - 1) * espaco) / n;
    final altura = alturaFaixaLixeiras - 2 * margem;
    final topo = size.y - margem - altura;
    for (var i = 0; i < n; i++) {
      final lixeira = _lixeiras[i];
      lixeira.size = Vector2(largura, altura);
      lixeira.position = Vector2(margem + i * (largura + espaco), topo);
    }
  }

  @override
  void onDispose() {
    service.removeListener(_aoMudarService);
    super.onDispose();
  }

  /// Pausa quando o jogo acaba e recomeça limpo quando o jogador reinicia.
  void _aoMudarService() {
    final fim = service.fimDeJogo;
    if (fim == _encerrado) return;
    _encerrado = fim;
    if (fim) {
      pauseEngine();
    } else {
      _limparItens();
      _tempoParaProximo = _tempoAteOPrimeiroItem;
      resumeEngine();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    _tempoParaProximo -= dt;
    if (_tempoParaProximo <= 0) {
      _sortearItem();
      _tempoParaProximo = intervaloDeSorteio(service.nivel);
    }

    _verificarChao();
  }

  void _sortearItem() {
    const margem = 8.0;
    const raio = ItemLixo.diametro / 2;
    final minX = margem + raio;
    final maxX = size.x - margem - raio;
    if (maxX <= minX) return; // arena ainda sem largura

    final x = minX + _random.nextDouble() * (maxX - minX);
    final tipo = TipoLixo.values[_random.nextInt(TipoLixo.values.length)];

    add(
      ItemLixo(
        tipo: tipo,
        position: Vector2(x, -raio), // nasce logo acima da arena
        aoSoltar: _aoSoltar,
        velocidade: velocidadeDeQueda(service.nivel),
      ),
    );
  }

  /// Mantém a velocidade de todos os itens de acordo com o nível atual e
  /// conta como perdido quem chegou ao chão.
  void _verificarChao() {
    final velocidade = velocidadeDeQueda(service.nivel);
    for (final item in children.whereType<ItemLixo>().toList()) {
      if (item.isRemoving) continue;
      item.velocidade = velocidade;
      if (item.isDragged) continue; // o jogador está segurando

      if (item.position.y + ItemLixo.diametro / 2 >= _chaoY) {
        item.removeFromParent();
        service.registrarItemPerdido();
      }
    }
  }

  /// Soltou sobre uma lixeira: compara o tipo e pontua. Soltou fora: o item
  /// simplesmente volta a cair (e conta como perdido se chegar ao chão).
  void _aoSoltar(ItemLixo item) {
    if (_encerrado) return;
    for (final lixeira in _lixeiras) {
      if (!lixeira.containsPoint(item.absoluteCenter)) continue;

      // Feedback antes do service: se esta jogada acabar o jogo, o listener
      // pausa o motor e a animação não chegaria a rodar.
      final acertou = lixeira.aceita(item.tipo);
      if (acertou) {
        lixeira.feedbackAcerto();
      } else {
        lixeira.feedbackErro();
      }
      item.removeFromParent();
      if (acertou) {
        service.registrarAcerto();
      } else {
        service.registrarErro();
      }
      return;
    }
  }

  void _limparItens() {
    removeAll(children.whereType<ItemLixo>().toList());
  }
}
