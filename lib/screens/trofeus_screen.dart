import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/conquista.dart';
import '../services/pontuacao_service.dart';
import '../theme/cores.dart';
import '../widgets/barra_progresso.dart';
import '../widgets/botao_tatil.dart';
import '../widgets/cartao_papel.dart';

/// Galeria de troféus: todas as conquistas do jogo, lidas do service.
class TrofeusScreen extends StatelessWidget {
  const TrofeusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lista = context.watch<PontuacaoService>().conquistas;
    final feitas = lista.where((c) => c.desbloqueada).length;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('TROFÉUS',
                  textAlign: TextAlign.center,
                  style: Tema.titulo(tamanho: 36)),
              const SizedBox(height: 4),
              Text('$feitas de ${lista.length} conquistados',
                  textAlign: TextAlign.center,
                  style: Tema.texto(tamanho: 14)),
              const SizedBox(height: 12),
              BarraProgresso(
                valor: lista.isEmpty ? 0 : feitas / lista.length,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: lista.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (_, i) => _LinhaConquista(lista[i]),
                ),
              ),
              const SizedBox(height: 12),
              BotaoTatil(
                texto: 'VOLTAR',
                cor: Cores.superficie,
                altura: 54,
                tamanhoFonte: 20,
                aoPressionar: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinhaConquista extends StatelessWidget {
  const _LinhaConquista(this.conquista);

  final Conquista conquista;

  @override
  Widget build(BuildContext context) {
    final feita = conquista.desbloqueada;
    return Opacity(
      opacity: feita ? 1 : 0.6,
      child: CartaoPapel(
        cor: feita ? Cores.lixeiraVidro : Cores.superficie,
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Text(feita ? '🏆' : '🔒', style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(conquista.titulo, style: Tema.titulo(tamanho: 18)),
                  const SizedBox(height: 2),
                  Text(conquista.descricao, style: Tema.texto(tamanho: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}