import 'package:flutter/material.dart';

import '../theme/cores.dart';

class BotaoTatil extends StatefulWidget {
  const BotaoTatil({
    super.key,
    required this.texto,
    required this.aoPressionar,
    this.cor = Cores.lixeiraVidro,
    this.altura = 72,
    this.tamanhoFonte = 28,
  });

  final String texto;
  final VoidCallback aoPressionar;
  final Color cor;
  final double altura;
  final double tamanhoFonte;

  @override
  State<BotaoTatil> createState() => _BotaoTatilState();
}

class _BotaoTatilState extends State<BotaoTatil> {
  static const double _sombra = 6;
  static const double _descida = 4;
  bool _pressionado = false;

  @override
  Widget build(BuildContext context) {
    final desce = _pressionado ? _descida : 0.0;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressionado = true),
      onTapUp: (_) {
        setState(() => _pressionado = false);
        widget.aoPressionar();
      },
      onTapCancel: () => setState(() => _pressionado = false),
      child: Padding(
        padding: const EdgeInsets.only(bottom: _sombra),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          height: widget.altura,
          alignment: Alignment.center,
          transform: Matrix4.translationValues(0, desce, 0),
          decoration: Tema.decoracao(
            cor: widget.cor,
            raio: 20,
            sombra: _sombra - desce,
          ),
          child: Text(
            widget.texto,
            style: Tema.titulo(tamanho: widget.tamanhoFonte),
          ),
        ),
      ),
    );
  }
}