import 'package:flutter/material.dart';

import '../models/conquista.dart';
import '../theme/cores.dart';
import '../widgets/botao_tatil.dart';
import '../widgets/cartao_papel.dart';

class FimScreen extends StatelessWidget {
  const FimScreen({
    super.key,
    required this.pontos,
    required this.maiorCombo,
    required this.nivel,
    required this.itens,
    required this.novoRecorde,
    required this.aoJogarNovamente,
    required this.aoMenu,
    this.conquista,
  });

  final int pontos;
  final int maiorCombo;
  final int nivel;
  final int itens;
  final bool novoRecorde;
  final Conquista? conquista;
  final VoidCallback aoJogarNovamente;
  final VoidCallback aoMenu;

  String _milhar(int n) => n.toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (_) => '.',
      );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Cores.contorno.withValues(alpha: 0.6),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: CartaoPapel(
            raio: 22,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('FIM DE JOGO', style: Tema.titulo(tamanho: 36)),
                if (novoRecorde) ...[
                  const SizedBox(height: 10),
                  Transform.rotate(
                    angle: -0.05,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: Tema.decoracao(
                          cor: Cores.lixeiraMetal, raio: 10, sombra: 3),
                      child: Text('NOVO RECORDE!',
                          style: Tema.titulo(tamanho: 16)),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        child: _Metrica('Pontuação final', _milhar(pontos))),
                    const SizedBox(width: 12),
                    Expanded(child: _Metrica('Maior combo', 'x$maiorCombo')),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _Metrica('Nível atingido', '$nivel')),
                    const SizedBox(width: 12),
                    Expanded(child: _Metrica('Itens reciclados', '$itens')),
                  ],
                ),
                if (conquista != null) ...[
                  const SizedBox(height: 14),
                  _BannerConquista(conquista!),
                ],
                const SizedBox(height: 18),
                BotaoTatil(
                  texto: 'JOGAR NOVAMENTE',
                  altura: 68,
                  tamanhoFonte: 26,
                  aoPressionar: aoJogarNovamente,
                ),
                const SizedBox(height: 6),
                BotaoTatil(
                  texto: 'MENU',
                  cor: Cores.superficie,
                  altura: 54,
                  tamanhoFonte: 20,
                  aoPressionar: aoMenu,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Metrica extends StatelessWidget {
  const _Metrica(this.rotulo, this.valor);

  final String rotulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: Tema.decoracao(cor: Cores.papel, raio: 14, sombra: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(rotulo, style: Tema.texto(tamanho: 12)),
          Text(valor, style: Tema.titulo(tamanho: 30)),
        ],
      ),
    );
  }
}

class _BannerConquista extends StatelessWidget {
  const _BannerConquista(this.conquista);

  final Conquista conquista;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: Tema.decoracao(cor: Cores.lixeiraVidro, raio: 14),
      child: Row(
        children: [
          const Text('⚡', style: TextStyle(fontSize: 30)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(conquista.titulo, style: Tema.titulo(tamanho: 16)),
                Text(conquista.descricao, style: Tema.texto(tamanho: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}