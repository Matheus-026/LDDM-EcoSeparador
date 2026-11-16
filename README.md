# EcoSeparador ♻️

Jogo em Flutter com Flame: itens de lixo caem e você arrasta cada um para a lixeira certa.

Projeto do Workshop Técnico (Tema 4: Gamificação e engajamento com Flame) de Laboratório de Desenvolvimento para Dispositivos Móveis, PUC Minas, prof. Cristiano Rodrigues.

<!-- Quando tiverem os prints, descomente:
<p align="center">
  <img src="docs/telas/menu.png" width="200">
  <img src="docs/telas/jogo.png" width="200">
  <img src="docs/telas/fim.png" width="200">
</p>
-->

## Equipe

| Integrante | Frente |
|---|---|
| `<nome>` | Jogo em Flame |
| `<nome>` | Regras e dados |
| `<nome>` | Telas Flutter |
| `<nome>` | Lixeiras e feedback visual |
| `<nome>` | Repositório, README e apresentação |

## O que demonstra

- **Engajamento:** pontos, combo, vidas, níveis, conquistas e recorde.
- **Flame:** game loop, componentes e gestos de arrastar (`DragCallbacks`).
- **Escolha de ferramenta:** só a partida usa Flame. Menu e fim de jogo são widgets Flutter.

## Como jogar

Arraste cada item para a lixeira da cor certa antes de ele chegar ao chão.

| Lixeira | Cor |
|---|---|
| Papel | Azul |
| Plástico | Vermelho |
| Vidro | Verde |
| Metal | Amarelo |

Cores da coleta seletiva (Resolução CONAMA 275/2001).

## Regras

| Mecanismo | Regra | Inspiração |
|---|---|---|
| Pontos | Acerto = 10 × multiplicador | Fliperama |
| Combo | +1 no multiplicador a cada 5 acertos seguidos; erro zera | Sequência do Duolingo |
| Vidas | 3. Erro ou item no chão tira 1 | Jogos casuais |
| Nível | Sobe a cada 100 pontos e acelera a queda | XP do Strava e do Habitica |
| Conquistas | 4 troféus (primeira separação, combo 10, nível 3, 100 pontos) | Badges |
| Recorde | Maior pontuação, salva no aparelho | Placar de fliperama |

Sem vidas pagas, sem punição por ficar sem jogar e sem notificações de culpa.

## Executar

Requisitos: Flutter estável e um emulador Android ou celular com depuração USB.

```bash
git clone https://github.com/<usuario>/LDDM-EcoSeparador.git
cd LDDM-EcoSeparador
flutter pub get
flutter run
```

Testes das regras: `flutter test`

Versões usadas: Flutter 3.44.8, Dart 3.12.2, Flame `<preencher>`.

## Estrutura

```
lib/
├── main.dart
├── theme/       # cores e estilos
├── models/      # TipoLixo, Conquista
├── services/    # PontuacaoService (regras, sem Flame)
├── screens/     # início, jogo e fim de jogo
├── widgets/     # HUD
└── game/        # Flame: eco_game, item_lixo, lixeira
```

As regras ficam em `PontuacaoService`. O jogo só avisa acertos e erros, e a interface só lê o estado.

## Flame em 4 linhas

- `update(dt)` muda o estado e `render` desenha.
- `ItemLixo` e `Lixeira` são componentes.
- O arrasto usa `DragCallbacks`. `TapDetector` e `PanDetector` são a forma antiga, depreciada.
- Quando não usar: formulários, listas e telas de texto ficam melhores em widgets.


Slides: `<link>` · Protótipo das telas: `docs/prototipo/`
