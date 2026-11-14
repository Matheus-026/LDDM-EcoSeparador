import 'dart:math' as math;
import 'jogo_screen.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/tipo_lixo.dart';
import '../theme/cores.dart';
import '../widgets/barra_progresso.dart';
import '../widgets/botao_tatil.dart';
import '../widgets/cartao_papel.dart';
import '../services/pontuacao_service.dart';
import '../utils/formato.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const _Topo(),
              const Expanded(child: Center(child: _Logo())),
              BotaoTatil(
                texto: 'JOGAR',
                altura: 92,
                tamanhoFonte: 44,
                aoPressionar: () {
                  context.read<PontuacaoService>().reiniciar();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const JogoScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              const _RodapeConquista(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Topo extends StatelessWidget {
  const _Topo();

  @override
  Widget build(BuildContext context) {
    final recorde = context.watch<PontuacaoService>().recorde;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CartaoPapel(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text('🏆 ${milhar(recorde)} pts',
              style: Tema.titulo(tamanho: 18)),
        ),
        const Row(
          children: [
            _IconeCartao('🔊'),
            SizedBox(width: 8),
            _IconeCartao('⚙️'),
          ],
        ),
      ],
    );
  }
}

class _IconeCartao extends StatelessWidget {
  const _IconeCartao(this.emoji);

  final String emoji;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 46,
      child: CartaoPapel(
        padding: EdgeInsets.zero,
        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _TextoContornado('ECO', 78, Cores.lixeiraVidro),
        SizedBox(height: 4),
        _TextoContornado('SEPARADOR', 46, Cores.superficie),
        SizedBox(height: 36),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _MiniLixeira(TipoLixo.papel, -0.10),
            SizedBox(width: 16),
            _MiniLixeira(TipoLixo.plastico, 0.07),
            SizedBox(width: 16),
            _MiniLixeira(TipoLixo.vidro, -0.05),
            SizedBox(width: 16),
            _MiniLixeira(TipoLixo.metal, 0.10),
          ],
        ),
      ],
    );
  }
}

/// Texto com contorno e sombra dura, feito empilhando 3 textos.
class _TextoContornado extends StatelessWidget {
  const _TextoContornado(this.texto, this.tamanho, this.cor);

  final String texto;
  final double tamanho;
  final Color cor;

  TextStyle _estilo({Color? cor, Paint? contorno}) => GoogleFonts.fredoka(
    fontSize: tamanho,
    fontWeight: FontWeight.w700,
    letterSpacing: 2,
    color: cor,
    foreground: contorno,
  );

  Paint _traco() => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 7
    ..strokeJoin = StrokeJoin.round
    ..color = Cores.contorno;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform.translate(
          offset: const Offset(0, 5),
          child: Text(texto, style: _estilo(contorno: _traco())),
        ),
        Text(texto, style: _estilo(contorno: _traco())),
        Text(texto, style: _estilo(cor: cor)),
      ],
    );
  }
}

class _MiniLixeira extends StatelessWidget {
  const _MiniLixeira(this.tipo, this.giro);

  final TipoLixo tipo;
  final double giro;

  Widget _olho() => Container(
    width: 8,
    height: 10,
    decoration: const BoxDecoration(
      color: Cores.contorno,
      shape: BoxShape.circle,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: giro,
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: SizedBox(
          width: 64,
          height: 76,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(decoration: Tema.decoracao(cor: tipo.cor, raio: 12)),
              Positioned(
                left: -5,
                right: -5,
                top: -12,
                height: 14,
                child: Container(
                  decoration: Tema.decoracao(cor: tipo.cor, raio: 6, sombra: 0),
                ),
              ),
              Positioned(left: 16, top: 26, child: _olho()),
              Positioned(right: 16, top: 26, child: _olho()),
              Positioned(
                left: 22,
                top: 42,
                child: CustomPaint(
                  size: const Size(20, 10),
                  painter: _SorrisoPainter(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SorrisoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final tinta = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..color = Cores.contorno;
    canvas.drawArc(
      Rect.fromLTWH(0, -size.height, size.width, size.height * 2),
      0,
      math.pi,
      false,
      tinta,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RodapeConquista extends StatelessWidget {
  const _RodapeConquista();

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CartaoPapel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Mestre do Vidro', style: Tema.titulo(tamanho: 14)),
                      Text('42/50', style: Tema.titulo(tamanho: 14)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const BarraProgresso(valor: 0.84),
                  const SizedBox(height: 8),
                  Text(
                    'Faltam 8 vidros para o troféu',
                    style: Tema.texto(tamanho: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 84,
            child: CartaoPapel(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🏅', style: TextStyle(fontSize: 26)),
                  Text('Troféus', style: Tema.titulo(tamanho: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
