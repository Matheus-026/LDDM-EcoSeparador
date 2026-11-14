import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/inicio_screen.dart';
import 'services/pontuacao_service.dart';
import 'theme/cores.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PontuacaoService(),
      child: const EcoApp(),
    ),
  );
}

class EcoApp extends StatelessWidget {
  const EcoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoSeparador',
      debugShowCheckedModeBanner: false,
      theme: Tema.tema,
      home: const InicioScreen(),
    );
  }
}