import 'package:flutter/foundation.dart';

import '../models/conquista.dart';

/// VERSÃO PROVISÓRIA: regras básicas, sem salvar no aparelho e sem conquistas.
/// A frente B completa mantendo os mesmos nomes (contrato).
class PontuacaoService extends ChangeNotifier {
  int _pontos = 0;
  int _vidas = 3;
  int _combo = 0;
  int _maiorCombo = 0;
  int _itens = 0;
  int _recorde = 14250; // provisório
  bool _novoRecorde = false;

  int get pontos => _pontos;
  int get vidas => _vidas;
  int get combo => _combo;
  int get maiorCombo => _maiorCombo;
  int get itensReciclados => _itens;
  int get recorde => _recorde;
  bool get novoRecorde => _novoRecorde;
  int get multiplicador => 1 + _combo ~/ 5;
  int get nivel => 1 + _pontos ~/ 100;
  double get progressoNivel => (_pontos % 100) / 100;
  bool get fimDeJogo => _vidas == 0;
  List<Conquista> get conquistas => const [];

  void registrarAcerto() {
    if (fimDeJogo) return;
    _pontos += 10 * multiplicador;
    _combo++;
    _itens++;
    if (_combo > _maiorCombo) _maiorCombo = _combo;
    notifyListeners();
  }

  void registrarErro() => _perderVida(); // lixeira errada

  void registrarItemPerdido() => _perderVida(); // item chegou ao chão

  void _perderVida() {
    if (fimDeJogo) return;
    _vidas--;
    _combo = 0;
    if (fimDeJogo && _pontos > _recorde) {
      _recorde = _pontos;
      _novoRecorde = true;
    }
    notifyListeners();
  }

  void reiniciar() {
    _pontos = 0;
    _vidas = 3;
    _combo = 0;
    _maiorCombo = 0;
    _itens = 0;
    _novoRecorde = false;
    notifyListeners();
  }
}