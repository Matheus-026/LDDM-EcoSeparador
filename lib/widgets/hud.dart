import 'package:flutter/material.dart';

import '../theme/cores.dart';
import 'barra_progresso.dart';

class Hud extends StatelessWidget {
  const Hud({
    super.key,
    required this.vidas,
    required this.nivel,
    required this.progressoNivel,
    required this.pontos,
    required this.combo,
  });

  final int vidas;
  final int nivel;
  final double progressoNivel; // de 0.0 a 1.0
  final int pontos;
  final int combo;

  String _milhar(int n) => n.toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (_) => '.',
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: Cores.superficie,
        border: Border(
          bottom: BorderSide(color: Cores.contorno, width: Tema.borda),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Row(
              children: [
                for (var i = 0; i < 3; i++) _Coracao(cheio: i < vidas),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Nível $nivel', style: Tema.titulo(tamanho: 14)),
                const SizedBox(height: 4),
                BarraProgresso(valor: progressoNivel),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 120,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(_milhar(pontos), style: Tema.titulo(tamanho: 28)),
                if (combo > 1) ...[
                  const SizedBox(height: 6),
                  _Combo(combo),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Coracao extends StatelessWidget {
  const _Coracao({required this.cheio});

  final bool cheio;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 28,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.favorite, size: 28, color: Cores.contorno),
          Icon(
            Icons.favorite,
            size: 20,
            color: cheio ? Cores.lixeiraPlastico : Cores.papel,
          ),
        ],
      ),
    );
  }
}

class _Combo extends StatelessWidget {
  const _Combo(this.combo);

  final int combo;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.1,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: Tema.decoracao(
          cor: Cores.lixeiraMetal,
          raio: 10,
          sombra: 3,
        ),
        child: Text('COMBO x$combo 🔥', style: Tema.titulo(tamanho: 13)),
      ),
    );
  }
}