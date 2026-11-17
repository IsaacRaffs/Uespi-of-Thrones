# 🏰 UESPI of Thrones

**UESPI of Thrones** é um RPG medieval desenvolvido em Flutter e Dart, inspirado no universo de fantasia medieval e integrado à geografia real de Teresina, Piauí.

O jogo transforma os cursos da Universidade Estadual do Piauí (UESPI) em guildas, permitindo que o jogador explore o mapa, evolua sua própria guilda, adquira conhecimentos acadêmicos e enfrente desafios relacionados às diferentes áreas do conhecimento.

---

## 🎮 Sobre o projeto

A proposta é unir entretenimento, exploração geográfica e aprendizagem em uma experiência gamificada.

Cada curso representa uma guilda com identidade visual, características e desafios próprios. O jogador escolhe sua guilda inicial e começa sua jornada para conquistar o reino.

## ✨ Funcionalidades

### 🛡️ Sistema de guildas
- Escolha de uma guilda inicial.
- Representação dos cursos da UESPI.
- Atributos relacionados às áreas do conhecimento.
- Sistema de evolução e níveis.
- Melhorias da guilda por meio de cliques.

### 🗺️ Mapa interativo
- Mapa baseado na geografia real de Teresina.
- Integração com OpenStreetMap.
- Localização das guildas no mapa.
- Marcadores personalizados com temática medieval.
- Identidade visual inspirada em mapas antigos e pergaminhos.

### ⚔️ Sistema de batalhas
- Desafios contra guildas adversárias.
- Perguntas relacionadas ao curso de cada guilda.
- Três questões por batalha.
- Necessidade de acertar pelo menos duas questões para vencer.
- Sistema de tempo para responder.
- Recompensas por vitórias.

### 📚 Biblioteca Real
- Compra de livros utilizando moedas do jogo.
- Livros associados às guildas.
- Desbloqueio de conteúdos acadêmicos e questões.
- Sistema de aquisição permanente dos livros.

### 📈 Progressão
- Sistema de experiência (XP).
- Evolução de níveis.
- Recompensas em moedas.
- Sistema de melhorias e desenvolvimento da guilda.

### 💾 Sistema de salvamento
- Suporte para até três slots de salvamento.
- Continuação de partidas anteriores.
- Persistência do progresso do jogador.

### 🎵 Sistema de áudio
- Música do menu principal.
- Música durante a exploração.
- Música durante as batalhas.
- Efeitos sonoros de interação.
- Efeito sonoro especial para obtenção de experiência.

---

## 🏰 Guildas disponíveis

O jogo possui 15 guildas, representando cursos da UESPI:

| Guilda | Área relacionada |
|---|---|
| Psicologia | Humanas |
| Engenharia Civil | Exatas |
| Engenharia Elétrica | Exatas |
| Zootecnia | Natureza |
| História | Humanas |
| Medicina | Natureza |
| Física | Exatas |
| Educação Física | Natureza |
| Computação | Exatas |
| Química | Natureza |
| Letras | Literatura |
| Biologia | Natureza |
| Direito | Humanas |
| Jornalismo | Humanas |
| Turismo | Humanas |

## 🧰 Tecnologias utilizadas

- **Dart:** linguagem de programação.
- **Flutter:** framework de desenvolvimento multiplataforma.
- **OpenStreetMap:** dados geográficos utilizados no mapa.
- **flutter_map:** integração e renderização do mapa.
- **Git:** controle de versão.

## 🚀 Como executar o projeto

### Pré-requisitos

- Flutter SDK instalado.
- Dart SDK.
- Git.
- Ambiente de desenvolvimento compatível com Flutter.

### Instalação

Clone o repositório:

```bash
git clone URL_DO_REPOSITORIO
```

Entre na pasta do projeto:

```bash
cd uespi_of_thrones
```

Instale as dependências:

```bash
flutter pub get
```

Execute o aplicativo:

```bash
flutter run
```

Para executar a versão Linux:

```bash
flutter run -d linux
```

### Gerar APK

Para gerar o aplicativo Android:

```bash
flutter build apk --release
```

O APK será gerado em:

```text
build/app/outputs/flutter-apk/app-release.apk
```

---

## 🎨 Identidade visual

O projeto utiliza uma identidade visual medieval, com elementos como:

- Pergaminhos e mapas antigos.
- Brasões e bandeiras.
- Castelos e símbolos de guildas.
- Tipografia inspirada na estética medieval.
- Paleta de cores baseada em tons de dourado, marrom e sépia.

## 🎯 Objetivo

O objetivo do UESPI of Thrones é desenvolver uma experiência de RPG que conecte o ambiente universitário ao universo dos jogos, incentivando a exploração, a evolução do jogador e o contato com conhecimentos acadêmicos.

---

**UESPI of Thrones — Conquiste conhecimento. Evolua sua guilda. Domine o reino.**