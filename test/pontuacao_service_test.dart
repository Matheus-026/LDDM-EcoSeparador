import 'package:ecoseparador/services/pontuacao_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late PontuacaoService service;

  setUp(() async {
    // Limpa o mock do SharedPreferences antes de cada teste
    SharedPreferences.setMockInitialValues({});
    service = PontuacaoService();
    await service.carregar();
  });

  group('Estado inicial e carregamento', () {
    test('deve iniciar com valores padrão zerados e 3 vidas', () {
      expect(service.pontos, 0);
      expect(service.vidas, 3);
      expect(service.nivel, 1);
      expect(service.combo, 0);
      expect(service.multiplicador, 1);
      expect(service.recorde, 0);
      expect(service.fimDeJogo, isFalse);
      expect(service.conquistas.every((c) => !c.desbloqueada), isTrue);
    });

    test('deve carregar recorde e conquistas previamente salvos', () async {
      SharedPreferences.setMockInitialValues({
        'ecoseparador_recorde': 550,
        'ecoseparador_conquistas': ['primeira_separacao', 'cem_pontos'],
      });

      final novoService = PontuacaoService();
      await novoService.carregar();

      expect(novoService.recorde, 550);
      expect(
        novoService.conquistas
            .firstWhere((c) => c.id == 'primeira_separacao')
            .desbloqueada,
        isTrue,
      );
      expect(
        novoService.conquistas
            .firstWhere((c) => c.id == 'cem_pontos')
            .desbloqueada,
        isTrue,
      );
      expect(
        novoService.conquistas
            .firstWhere((c) => c.id == 'combo_10')
            .desbloqueada,
        isFalse,
      );
    });
  });

  group('Regras de pontuação, combo, multiplicador e nível', () {
    test('deve calcular multiplicador e pontos progressivos por combo', () {
      // Acertos 1 a 5 (combo 0..4 antes do incremento -> multiplicador x1 = 10 pts cada)
      for (int i = 0; i < 5; i++) {
        service.registrarAcerto();
      }
      expect(service.combo, 5);
      expect(service.pontos, 50);
      expect(service.multiplicador, 2); // 1 + 5 ~/ 5 = 2

      // 6º acerto vale 10 * 2 = 20 pts
      service.registrarAcerto();
      expect(service.combo, 6);
      expect(service.pontos, 70);
      expect(service.maiorCombo, 6);
    });

    test('deve subir de nível a cada 100 pontos', () {
      expect(service.nivel, 1);

      // 8 acertos seguidos = 50 + (3 * 20) = 110 pontos -> Nível 2
      for (int i = 0; i < 8; i++) {
        service.registrarAcerto();
      }
      expect(service.pontos, 110);
      expect(service.nivel, 2);
      expect(service.progressoNivel, closeTo(0.10, 0.001));
    });
  });

  group('Vidas, erros e fim de jogo', () {
    test('erro e item perdido devem tirar 1 vida e zerar o combo', () {
      service.registrarAcerto();
      service.registrarAcerto();
      expect(service.combo, 2);
      expect(service.vidas, 3);

      service.registrarErro();
      expect(service.vidas, 2);
      expect(service.combo, 0);
      expect(service.maiorCombo, 2);

      service.registrarItemPerdido();
      expect(service.vidas, 1);

      service.registrarErro();
      expect(service.vidas, 0);
      expect(service.fimDeJogo, isTrue);
    });

    test('não deve registrar pontos ou erros após fim de jogo', () {
      service.registrarErro();
      service.registrarErro();
      service.registrarErro();
      expect(service.fimDeJogo, isTrue);

      service.registrarAcerto();
      expect(service.pontos, 0);
      expect(service.itensReciclados, 0);
    });
  });

  group('Recorde e reinício', () {
    test('deve atualizar e persistir novo recorde ao fim do jogo', () async {
      service.registrarAcerto(); // 10 pts
      service.registrarAcerto(); // 20 pts

      // Perde as 3 vidas
      service.registrarErro();
      service.registrarErro();
      service.registrarErro();

      expect(service.novoRecorde, isTrue);
      expect(service.recorde, 20);

      // Simula fechar e reabrir o app
      final outraInstancia = PontuacaoService();
      await outraInstancia.carregar();
      expect(outraInstancia.recorde, 20);
    });

    test('reiniciar deve zerar partida mas manter recorde e conquistas totais',
        () {
      service.registrarAcerto(); // Desbloqueia 'primeira_separacao'
      service.registrarErro();
      service.registrarErro();
      service.registrarErro();

      expect(service.recorde, 10);
      expect(service.conquistasDaPartida.length, 1);

      service.reiniciar();

      expect(service.pontos, 0);
      expect(service.vidas, 3);
      expect(service.combo, 0);
      expect(service.maiorCombo, 0);
      expect(service.itensReciclados, 0);
      expect(service.novoRecorde, isFalse);
      expect(service.conquistasDaPartida, isEmpty);
      expect(service.recorde, 10); // Recorde mantido
      expect(
        service.conquistas
            .firstWhere((c) => c.id == 'primeira_separacao')
            .desbloqueada,
        isTrue,
      );
    });
  });

  group('Conquistas', () {
    test('deve desbloquear todas as 4 conquistas conforme regras', () {
      // 1º acerto -> Primeira separação
      service.registrarAcerto();
      expect(
        service.conquistasDaPartida.any((c) => c.id == 'primeira_separacao'),
        isTrue,
      );

      // Chegar a 10 acertos seguidos -> 100 pontos (no 8º) e Combo de 10 (no 10º)
      for (int i = 0; i < 9; i++) {
        service.registrarAcerto();
      }
      expect(service.combo, 10);
      expect(service.pontos, 150);
      expect(
        service.conquistasDaPartida.any((c) => c.id == 'cem_pontos'),
        isTrue,
      );
      expect(
        service.conquistasDaPartida.any((c) => c.id == 'combo_10'),
        isTrue,
      );

      // Mais 2 acertos (combo 10 e 11 -> multiplicador x3 -> +30 pts cada = 210 pts) -> Nível 3
      service.registrarAcerto();
      service.registrarAcerto();
      expect(service.nivel, 3);
      expect(
        service.conquistasDaPartida.any((c) => c.id == 'nivel_3'),
        isTrue,
      );
      expect(service.conquistasDaPartida.length, 4);
    });
  });
}