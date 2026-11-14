import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/cores.dart';
import '../widgets/barra_progresso.dart';
import 'inicio_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _duracao = Duration(milliseconds: 1500);

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    try {
      // Espera as fontes baixarem e o tempo mínimo do logo, ao mesmo tempo.
      await Future.wait([
        GoogleFonts.pendingFonts([
          GoogleFonts.fredoka(fontWeight: FontWeight.w700),
          GoogleFonts.nunito(fontWeight: FontWeight.w700),
        ]),
        Future<void>.delayed(_duracao),
      ]);
    } catch (_) {
      // Sem internet: segue com a fonte padrão.
    }
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const InicioScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.6, end: 1),
              duration: const Duration(milliseconds: 700),
              curve: Curves.elasticOut,
              builder: (_, escala, filho) =>
                  Transform.scale(scale: escala, child: filho),
              child: Image.asset('assets/icon/icon.png', width: 320),
            ),
            Text('ECO SEPARADOR', style: Tema.titulo(tamanho: 28)),
            const SizedBox(height: 28),
            SizedBox(
              width: 220,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: _duracao,
                builder: (_, valor, _) => BarraProgresso(valor: valor),
              ),
            ),
            const SizedBox(height: 12),
            Text('Carregando...', style: Tema.texto(tamanho: 14)),
          ],
        ),
      ),
    );
  }
}