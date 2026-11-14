import 'package:flutter/material.dart';

import '../theme/cores.dart';

class CartaoPapel extends StatelessWidget {
  const CartaoPapel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.cor = Cores.superficie,
    this.raio = 18,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color cor;
  final double raio;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: Tema.decoracao(cor: cor, raio: raio),
      child: child,
    );
  }
}