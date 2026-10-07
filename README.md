# 🏰 UESPI of Thrones

**UESPI of Thrones** é um jogo RPG multiplayer baseado em localização, desenvolvido em **Flutter/Dart**, no qual jogadores participam de guildas distribuídas pelo mapa de **Teresina — PI**.

As guildas controlam pontos do mapa, recebem recompensas diariamente, acumulam recursos e podem atacar outras guildas. Durante uma batalha, unidades representadas por pequenas esferas coloridas percorrem o mapa em tempo real da guilda atacante até a guilda adversária.

O mapa utiliza dados do **OpenStreetMap**.

---

## 🎮 Conceito do jogo

Cada jogador pertence a uma guilda localizada fisicamente em algum ponto de Teresina.

Cada guilda possui:

- 🏰 Uma base no mapa
- 🎨 Uma cor própria
- ❤️ Pontos de vida
- 👥 Membros
- 🪙 Coins
- 📚 Livros
- 🪑 Bancadas de livros
- 👟 Sapatos
- ⚔️ Capacidade de atacar outras guildas

As guildas recebem recursos diariamente e podem utilizar seus recursos para evoluir e participar de batalhas.

---

# 🗺️ Mapa

A principal interface do jogo é um mapa de **Teresina — Piauí**.

Cada guilda aparece como um marcador no mapa.

Exemplo:

```text
                    🏰 Guilda Roxa
                         │
                         │
                    🟣 🟣 🟣
                            ↘
                              🟣
                                🟣

🏰 Guilda Azul ───────────────────── 🏰 Guilda Verde


                       🔴
                    🔴
                 🔴
              ↗

        🏰 Guilda Vermelha
```

O mapa é implementado utilizando:

- OpenStreetMap
- flutter_map
- latlong2

---

# ⚔️ Sistema de batalhas

As guildas podem atacar outras guildas existentes no mapa.

Cada guilda possui uma cor própria.

Por exemplo:

```text
Dragões do Pirajá
Cor: 🔴 Vermelho

Lobos de Teresina
Cor: 🔵 Azul
```

Quando uma batalha começa, pequenas unidades saem da guilda atacante em direção à guilda adversária.

```text
🏰 Guilda Vermelha

🔴
   🔴
      🔴
         🔴
            🔴
               🔴
                  ↓

             🏰 Guilda Azul
```

A posição das unidades é atualizada durante o percurso.

Cada unidade possui um progresso entre:

```text
0.00 → saiu da guilda

0.25 → percorreu 25%

0.50 → percorreu metade do caminho

0.75 → percorreu 75%

1.00 → chegou à guilda adversária
```

Quando uma unidade chega ao destino, ela pode causar dano à guilda inimiga.

Exemplo:

```text
Guilda Azul

❤️ 1000 HP

15 unidades chegam
10 de dano por unidade

15 × 10 = 150

❤️ 850 HP
```

O sistema de combate é inspirado no conceito de unidades avançando em direção à base adversária presente em jogos como Clash Royale, mas com mecânicas, unidades e identidade visual próprias.

---

# 🎁 Recompensas diárias

Cada guilda recebe recompensas diariamente.

Exemplo:

```text
Recompensa diária

🪙 +100 Coins
📚 +2 Livros
🪑 +1 Bancada
👟 +1 Sapato
```

Esses valores podem futuramente depender de fatores como:

- quantidade de membros;
- nível da guilda;
- territórios controlados;
- batalhas vencidas;
- ranking;
- missões;
- eventos especiais.

Em uma versão multiplayer, as recompensas devem ser calculadas pelo servidor para impedir manipulações pelo cliente.

---

# 🏰 Guildas

Uma guilda possui informações como:

```text
Guild
│
├── ID
├── Nome
├── Localização
│   ├── Latitude
│   └── Longitude
│
├── Cor
├── Vida
│
├── Recursos
│   ├── Coins
│   ├── Livros
│   ├── Bancadas
│   └── Sapatos
│
└── Membros
```

Exemplo:

```text
🏰 Dragões do Pirajá

❤️ Vida: 1000

🪙 Coins: 1500
📚 Livros: 32
🪑 Bancadas: 12
👟 Sapatos: 8
```

---

# 📂 Estrutura do projeto

```text
uespi_of_thrones/
│
├── lib/
│   │
│   ├── main.dart
│   │
│   ├── models/
│   │   ├── guild.dart
│   │   ├── guild_item.dart
│   │   └── battle_unit.dart
│   │
│   ├── data/
│   │   └── guild_data.dart
│   │
│   ├── services/
│   │   ├── reward_service.dart
│   │   └── battle_service.dart
│   │
│   ├── screens/
│   │   ├── map_screen.dart
│   │   ├── guild_screen.dart
│   │   └── battle_screen.dart
│   │
│   └── widgets/
│       ├── guild_marker.dart
│       └── battle_ball.dart
│
├── android/
├── ios/
├── web/
│
├── pubspec.yaml
└── README.md
```

---

# 🧱 Arquitetura

O projeto utiliza uma separação simples entre responsabilidades.

### Models

Representam as entidades do jogo.

```text
models/
├── guild.dart
├── guild_item.dart
└── battle_unit.dart
```

### Data

Contém dados utilizados pelo jogo durante o desenvolvimento.

```text
data/
└── guild_data.dart
```

Posteriormente esses dados deverão vir do backend.

### Services

Contêm as regras do jogo.

```text
services/
├── reward_service.dart
└── battle_service.dart
```

Por exemplo:

- iniciar ataques;
- movimentar unidades;
- calcular dano;
- distribuir recompensas.

### Screens

Contêm as telas principais.

```text
screens/
├── map_screen.dart
├── guild_screen.dart
└── battle_screen.dart
```

### Widgets

Componentes visuais reutilizáveis.

```text
widgets/
├── guild_marker.dart
└── battle_ball.dart
```

---

# 🛠️ Tecnologias

### Frontend

- Flutter
- Dart
- Material Design

### Mapas

- OpenStreetMap
- flutter_map
- latlong2

### Futuro backend

Uma arquitetura multiplayer poderá utilizar:

- FastAPI
- PostgreSQL
- WebSocket
- JWT
- Docker

---

# 🌐 Arquitetura multiplayer

A versão completa deverá utilizar um servidor central.

```text
                    ┌────────────────────┐
                    │      Backend       │
                    │                    │
                    │ FastAPI / WebSocket│
                    │     PostgreSQL     │
                    └─────────┬──────────┘
                              │
                         WebSocket
                              │
              ┌───────────────┼───────────────┐
              │               │               │
              ▼               ▼               ▼

          📱 Jogador A    📱 Jogador B    📱 Jogador C
              │               │               │
              └───────────────┼───────────────┘
                              │
                              ▼
                       🗺️ Teresina - PI
```

O backend será responsável por manter o estado oficial do jogo.

Isso inclui:

- usuários;
- guildas;
- membros;
- inventários;
- recursos;
- recompensas;
- batalhas;
- dano;
- ranking;
- territórios;
- histórico de batalhas.

O aplicativo Flutter será responsável principalmente pela interface e pela representação visual dessas informações.

---

# 🔴 Batalhas em tempo real

Para batalhas multiplayer, o servidor poderá utilizar **WebSockets**.

Quando uma guilda iniciar um ataque:

```text
Jogador
   │
   │ atacar
   ▼
Backend
   │
   ├── valida ataque
   ├── cria batalha
   ├── cria unidades
   └── envia evento WebSocket
             │
             ▼
      Jogadores conectados
```

Todos os jogadores que estiverem visualizando aquela região poderão receber o evento.

Exemplo:

```json
{
  "type": "battle_started",
  "attacker": "guild_1",
  "target": "guild_2",
  "units": 15
}
```

O Flutter então poderá representar visualmente as unidades percorrendo o mapa.

---

# 🗃️ Banco de dados

Uma possível estrutura inicial seria:

```text
users
guilds
guild_members
items
guild_inventory
daily_rewards
battles
battle_units
battle_history
```

Relacionamento simplificado:

```text
User
  │
  ▼
GuildMember
  │
  ▼
Guild
  │
  ├──────── GuildInventory
  │
  └──────── Battle
               │
               ▼
           BattleUnit
```

---

# 🚀 Executando o projeto

É necessário possuir o Flutter instalado.

Verifique a instalação:

```bash
flutter doctor
```

Clone o projeto:

```bash
git clone <URL_DO_REPOSITORIO>
```

Entre na pasta:

```bash
cd uespi_of_thrones
```

Instale as dependências:

```bash
flutter pub get
```

Execute:

```bash
flutter run
```

Para executar no navegador:

```bash
flutter run -d chrome
```

---

# 📦 Dependências principais

Exemplo do `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter

  flutter_map: ^8.2.2
  latlong2: ^0.9.1
```

---

# 🗺️ OpenStreetMap

O projeto utiliza o OpenStreetMap como fonte de dados geográficos.

Durante o desenvolvimento, o mapa pode utilizar:

```text
https://tile.openstreetmap.org/{z}/{x}/{y}.png
```

A atribuição aos colaboradores do OpenStreetMap deve permanecer visível na aplicação.

Para uma aplicação em produção com muitos usuários, deverá ser utilizado um serviço de tiles adequado à carga esperada e às políticas do provedor escolhido.

---

# 🔐 Segurança

Em uma versão multiplayer, informações importantes nunca devem ser controladas exclusivamente pelo aplicativo Flutter.

O servidor deverá validar ações como:

```text
❌ Flutter decide:

"Ganhei 10000 coins"


✅ Flutter solicita:

"Quero coletar minha recompensa diária"

        ↓

Servidor verifica

        ↓

Última recompensa:
06/10/2026 08:00

Data atual:
07/10/2026 08:00

        ↓

Recompensa permitida

        ↓

+100 coins
```

A mesma lógica deverá ser aplicada às batalhas.

O servidor deve determinar:

- se o ataque é permitido;
- quantas unidades podem ser enviadas;
- quanto dano foi causado;
- quais recursos foram perdidos;
- quem venceu;
- quais recompensas foram recebidas.

---

# 🎯 Objetivo

O objetivo do **UESPI of Thrones** é combinar elementos de:

- RPG;
- estratégia;
- geolocalização;
- guildas;
- gerenciamento de recursos;
- batalhas multiplayer;
- exploração do mapa real.

O mapa de **Teresina — PI** funciona como o mundo do jogo, transformando diferentes locais da cidade em pontos estratégicos para as guildas.

---

# 📜 Licença

Defina a licença do projeto antes da distribuição pública.

Exemplos:

- MIT
- Apache 2.0
- GPL-3.0

---

# 🏰 UESPI of Thrones

> **Conquiste territórios. Fortaleça sua guilda. Domine Teresina.**