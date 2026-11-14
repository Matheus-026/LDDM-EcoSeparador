import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/tipo_lixo.dart';

class Cores {
  static const papel = Color(0xFFF4F1DE); // fundo
  static const superficie = Color(0xFFFFFDF7); // cards
  static const contorno = Color(0xFF2B2D42); // bordas e textos
  static const lixeiraPapel = Color(0xFF3A86FF);
  static const lixeiraPlastico = Color(0xFFFF006E);
  static const lixeiraVidro = Color(0xFF06D6A0);
  static const lixeiraMetal = Color(0xFFFFBE0B);
}

class Tema {
  static const double borda = 2.5;
  static const double alturaSombra = 4;

  static ThemeData get tema => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Cores.papel,
        splashFactory: NoSplash.splashFactory,
      );

  static TextStyle titulo({double tamanho = 24, Color cor = Cores.contorno}) =>
      GoogleFonts.fredoka(
          fontSize: tamanho, fontWeight: FontWeight.w700, color: cor);

  static TextStyle texto({double tamanho = 14, Color cor = Cores.contorno}) =>
      GoogleFonts.nunito(
          fontSize: tamanho, fontWeight: FontWeight.w700, color: cor);

  static BoxDecoration decoracao({
    Color cor = Cores.superficie,
    double raio = 18,
    double sombra = alturaSombra,
  }) =>
      BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(raio),
        border: Border.all(color: Cores.contorno, width: borda),
        boxShadow: [
          BoxShadow(
              color: Cores.contorno, offset: Offset(0, sombra), blurRadius: 0),
        ],
      );
}

extension TipoLixoVisual on TipoLixo {
  Color get cor => switch (this) {
        TipoLixo.papel => Cores.lixeiraPapel,
        TipoLixo.plastico => Cores.lixeiraPlastico,
        TipoLixo.vidro => Cores.lixeiraVidro,
        TipoLixo.metal => Cores.lixeiraMetal,
      };

  String get rotulo => switch (this) {
        TipoLixo.papel => 'PAPEL',
        TipoLixo.plastico => 'PLÁSTICO',
        TipoLixo.vidro => 'VIDRO',
        TipoLixo.metal => 'METAL',
      };
}