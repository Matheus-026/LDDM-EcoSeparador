import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/conquista.dart';

class PontuacaoService extends ChangeNotifier {
  static const String _chaveRecorde = 'ecoseparador_recorde';
  static const String _chaveConquistas = 'ecoseparador_conquistas';

  int _pontos = 0;
  int _vidas = 3;
  int _combo = 0;
  int _maiorCombo = 0;
  int _itens = 0;
  int _recorde = 0;
  bool _novoRecorde = false;

  // Catálogo fixo das 4 conquistas do jogo
  static const List<Conquista> _catalogoConquistas = [
    Conquista(
      id: 'primeira_separacao',
      titulo: 'Primeira separação',
      descricao: 'Separou o primeiro item corretamente',
    ),
    Conquista(
      id: 'combo_10',
      titulo: 'Combo de 10',
      descricao: 'Acertou 10 itens seguidos sem errar',
    ),
    Conquista(
      id: 'nivel_3',
      titulo: 'Nível 3',
      descricao: 'Alcançou o nível 3 de velocidade',
    ),
    Conquista(
      id: 'cem_pontos',
      titulo: '100 pontos',
      descricao: 'Somou 100 pontos ou mais em uma partida',
    ),
  ];

  final Set<String> _idsDesbloqueados = {};
  final List<Conquista> _conquistasDaPartida = [];

  // Getters do contrato
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

  /// Todas as conquistas do jogo com o status atualizado (para a Tela Inicial)
  List<Conquista> get conquistas => _catalogoConquistas
      .map((c) => c.copyWith(desbloqueada: _idsDesbloqueados.contains(c.id)))
      .toList(growable: false);

  /// Apenas as conquistas desbloqueadas na partida atual (para o Fim de Jogo)
  List<Conquista> get conquistasDaPartida =>
      List.unmodifiable(_conquistasDaPartida);

  /// Carrega o recorde e as conquistas salvas no aparelho.
  /// Deve ser chamado na inicialização do app / tela de abertura.
  Future<void> carregar() async {
    final prefs = await SharedPreferences.getInstance();
    _recorde = prefs.getInt(_chaveRecorde) ?? 0;

    final salvos = prefs.getStringList(_chaveConquistas) ?? [];
    _idsDesbloqueados
      ..clear()
      ..addAll(salvos);

    notifyListeners();
  }

  void registrarAcerto() {
    if (fimDeJogo) return;

    _pontos += 10 * multiplicador;
    _combo++;
    _itens++;
    if (_combo > _maiorCombo) {
      _maiorCombo = _combo;
    }

    _verificarConquistas();
    notifyListeners();
  }

  void registrarErro() => _perderVida();

  void registrarItemPerdido() => _perderVida();

  void _perderVida() {
    if (fimDeJogo) return;

    _vidas--;
    _combo = 0;

    if (fimDeJogo && _pontos > _recorde) {
      _recorde = _pontos;
      _novoRecorde = true;
      _salvarRecorde();
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
    _conquistasDaPartida.clear();
    notifyListeners();
  }

  void _verificarConquistas() {
    bool houveNovaConquista = false;

    if (_itens >= 1 && _desbloquear('primeira_separacao')) {
      houveNovaConquista = true;
    }
    if (_combo >= 10 && _desbloquear('combo_10')) {
      houveNovaConquista = true;
    }
    if (nivel >= 3 && _desbloquear('nivel_3')) {
      houveNovaConquista = true;
    }
    if (_pontos >= 100 && _desbloquear('cem_pontos')) {
      houveNovaConquista = true;
    }

    if (houveNovaConquista) {
      _salvarConquistas();
    }
  }

  bool _desbloquear(String id) {
    if (_idsDesbloqueados.contains(id)) return false;

    _idsDesbloqueados.add(id);
    final conquista = _catalogoConquistas
        .firstWhere((c) => c.id == id)
        .copyWith(desbloqueada: true);
    _conquistasDaPartida.add(conquista);
    return true;
  }

  Future<void> _salvarRecorde() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_chaveRecorde, _recorde);
  }

  Future<void> _salvarConquistas() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_chaveConquistas, _idsDesbloqueados.toList());
  }
}