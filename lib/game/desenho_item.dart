import 'package:flutter/material.dart';

import '../models/tipo_lixo.dart';
import '../theme/cores.dart';

/// Desenha o ícone do item com formas (sem emoji), centrado em [c].
/// [raio] é o raio do círculo do item. O ícone ocupa uns 13 x 13 "unidades",
/// onde 1 unidade = raio / 10, então escala sozinho com o tamanho do item.
void desenharItem(Canvas canvas, TipoLixo tipo, Offset c, double raio) {
  final u = raio / 10;

  final traco = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = u * 0.7
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..color = Cores.contorno;

  RRect forma(double x0, double y0, double x1, double y1, [double curva = 1]) =>
      RRect.fromLTRBR(c.dx + x0 * u, c.dy + y0 * u, c.dx + x1 * u,
          c.dy + y1 * u, Radius.circular(curva * u));

  void peca(RRect f, Color preenchimento) {
    canvas.drawRRect(f, Paint()..color = preenchimento);
    canvas.drawRRect(f, traco);
  }

  void linha(double x0, double y0, double x1, double y1) => canvas.drawLine(
        Offset(c.dx + x0 * u, c.dy + y0 * u),
        Offset(c.dx + x1 * u, c.dy + y1 * u),
        traco,
      );

  switch (tipo) {
    case TipoLixo.papel: // jornal
      peca(forma(-5, -6, 5, 6), Cores.superficie);
      peca(forma(-3.5, -4.5, 3.5, -2.5, 0.3), Cores.lixeiraPapel);
      linha(-3.5, 0, 3.5, 0);
      linha(-3.5, 2, 3.5, 2);
      linha(-3.5, 4, 0.5, 4);
    case TipoLixo.plastico: // garrafa PET
      peca(forma(-3.5, -2.5, 3.5, 6.5, 1.8), Cores.superficie); // corpo
      peca(forma(-1.5, -5, 1.5, -2, 0.5), Cores.superficie); // pescoço
      peca(forma(-1.8, -6.8, 1.8, -5, 0.5), Cores.lixeiraPlastico); // tampa
      peca(forma(-3.5, 0.5, 3.5, 3.5, 0.2), Cores.lixeiraPlastico); // rótulo
    case TipoLixo.vidro: // garrafa de vidro
      peca(forma(-3.5, -2, 3.5, 6.5, 1.8), Cores.lixeiraVidro); // corpo
      peca(forma(-1.4, -6.8, 1.4, -1.5, 0.6), Cores.lixeiraVidro); // gargalo
      linha(-1.8, 1, -1.8, 4); // brilho
    case TipoLixo.metal: // lata
      peca(forma(-4, -5, 4, 6, 1.2), Cores.lixeiraMetal); // corpo
      peca(forma(-4, -6.2, 4, -3.8, 1.2), Cores.superficie); // tampa
      linha(-4, 0, 4, 0);
      linha(-4, 2.5, 4, 2.5);
  }
}