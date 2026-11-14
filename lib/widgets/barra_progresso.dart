import 'package:flutter/material.dart';

import '../theme/cores.dart';

class BarraProgresso extends StatelessWidget {
  const BarraProgresso({
    super.key,
    required this.valor,
    this.cor = Cores.lixeiraVidro,
    this.altura = 16,
  });

  final double valor; // de 0.0 a 1.0
  final Color cor;
  final double altura;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: altura,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Cores.papel,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: Cores.contorno, width: Tema.borda),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: valor.clamp(0.0, 1.0),
          child: Container(color: cor),
        ),
      ),
    );
  }
}