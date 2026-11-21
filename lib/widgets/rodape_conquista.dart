import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/trofeus_screen.dart';
import '../services/pontuacao_service.dart';
import '../theme/cores.dart';
import 'barra_progresso.dart';
import 'cartao_papel.dart';

/// Rodapé do Início: próxima conquista a desbloquear + botão da galeria.
class RodapeConquista extends StatelessWidget {
  const RodapeConquista({super.key});

  @override
  Widget build(BuildContext context) {
    final lista = context.watch<PontuacaoService>().conquistas;
    final feitas = lista.where((c) => c.desbloqueada).length;
    final proxima = lista.where((c) => !c.desbloqueada).firstOrNull;

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
                  Text(
                    proxima == null ? 'Troféus' : 'Próxima conquista',
                    style: Tema.texto(tamanho: 11),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          proxima?.titulo ?? 'Todas conquistadas!',
                          overflow: TextOverflow.ellipsis,
                          style: Tema.titulo(tamanho: 14),
                        ),
                      ),
                      Text('$feitas/${lista.length}',
                          style: Tema.titulo(tamanho: 14)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  BarraProgresso(
                    valor: lista.isEmpty ? 0 : feitas / lista.length,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    proxima?.descricao ?? 'Você completou todos os troféus',
                    style: Tema.texto(tamanho: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const TrofeusScreen()),
            ),
            child: SizedBox(
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
          ),
        ],
      ),
    );
  }
}