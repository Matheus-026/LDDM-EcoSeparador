import 'package:ecoseparador/game/eco_game.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Dificuldade do EcoGame', () {
    test('velocidade de queda = 80 + 15 x (nível - 1)', () {
      expect(EcoGame.velocidadeDeQueda(1), 80);
      expect(EcoGame.velocidadeDeQueda(2), 95);
      expect(EcoGame.velocidadeDeQueda(5), 140);
    });

    test('intervalo entre itens diminui com o nível', () {
      expect(EcoGame.intervaloDeSorteio(1), closeTo(2.0, 1e-9));
      expect(EcoGame.intervaloDeSorteio(3), closeTo(1.8, 1e-9));
      expect(
        EcoGame.intervaloDeSorteio(4),
        lessThan(EcoGame.intervaloDeSorteio(3)),
      );
    });

    test('intervalo nunca fica menor que o piso de 0,9 s', () {
      expect(EcoGame.intervaloDeSorteio(12), closeTo(0.9, 1e-9));
      expect(EcoGame.intervaloDeSorteio(100), closeTo(0.9, 1e-9));
    });
  });
}
