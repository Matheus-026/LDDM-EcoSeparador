import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game/eco_game.dart';
import '../services/pontuacao_service.dart';
import '../theme/cores.dart';
import '../widgets/botao_tatil.dart';
import '../widgets/hud.dart';
import 'fim_screen.dart';

class JogoScreen extends StatefulWidget {
  const JogoScreen({super.key});

  @override
  State<JogoScreen> createState() => _JogoScreenState();
}

class _JogoScreenState extends State<JogoScreen> {
  late final EcoGame _jogo;

  @override
  void initState() {
    super.initState();
    _jogo = EcoGame(context.read<PontuacaoService>());
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<PontuacaoService>();
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: Column(
              children: [
                Hud(
                  vidas: s.vidas,
                  nivel: s.nivel,
                  progressoNivel: s.progressoNivel,
                  pontos: s.pontos,
                  combo: s.combo,
                ),
                Expanded(child: _Arena(jogo: _jogo)),
              ],
            ),
          ),
          if (s.fimDeJogo)
            FimScreen(
              pontos: s.pontos,
              maiorCombo: s.maiorCombo,
              nivel: s.nivel,
              itens: s.itensReciclados,
              novoRecorde: s.novoRecorde,
              conquista: s.conquistas.where((c) => c.desbloqueada).firstOrNull,
              aoJogarNovamente: s.reiniciar,
              aoMenu: () {
                s.reiniciar();
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
    );
  }
}

class _Arena extends StatelessWidget {
  const _Arena({required this.jogo});

  final EcoGame jogo;

  @override
  Widget build(BuildContext context) {
    final s = context.read<PontuacaoService>();
    return Container(
      margin: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      decoration: Tema.decoracao(cor: Cores.papel, sombra: 0),
      child: Stack(
        children: [
          Positioned.fill(child: GameWidget(game: jogo)),
          // PROVISÓRIO: somem quando o Flame chamar o service.
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Row(
              children: [
                Expanded(
                  child: BotaoTatil(
                    texto: 'ACERTO',
                    altura: 54,
                    tamanhoFonte: 16,
                    aoPressionar: s.registrarAcerto,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BotaoTatil(
                    texto: 'ERRO',
                    cor: Cores.lixeiraPlastico,
                    altura: 54,
                    tamanhoFonte: 16,
                    aoPressionar: s.registrarErro,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}