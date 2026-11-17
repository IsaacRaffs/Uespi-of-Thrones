class GameSave {
  final int slot;
  final String guildId;

  final DateTime createdAt;
  DateTime updatedAt;

  int level;
  int experience;
  int clickXp;
  int xpPerClick;
  int hints;
  int guildKnowledge;

  int literatura;
  int exatas;
  int natureza;
  int humanas;

  int coins;
  int books;
  int bookshelves;
  int shoes;
  int health;

  List<String> defeatedGuildIds;

  /// IDs das guildas cujos livros foram comprados.
  /// Mantém a aquisição persistida por partida.
  List<String> ownedBookGuildIds;

  /// Conquista permanente recebida ao dominar todas as guildas inimigas.
  bool hasGoldenDiploma;

  // Guarda os IDs das perguntas cujas dicas já foram liberadas.
  // A chave é o ID da guilda.
  Map<String, List<String>> hintedQuestions;

  GameSave({
    required this.slot,
    required this.guildId,
    required this.createdAt,
    required this.updatedAt,
    this.level = 1,
    this.experience = 0,
    this.clickXp = 1,
    int? xpPerClick,
    this.hints = 0,
    this.guildKnowledge = 0,
    this.literatura = 50,
    this.exatas = 50,
    this.natureza = 50,
    this.humanas = 50,
    this.coins = 0,
    this.books = 0,
    this.bookshelves = 0,
    this.shoes = 0,
    this.health = 1000,
    List<String>? defeatedGuildIds,
    List<String>? ownedBookGuildIds,
    this.hasGoldenDiploma = false,
    Map<String, List<String>>? hintedQuestions,
  }) : defeatedGuildIds = defeatedGuildIds ?? [],
       ownedBookGuildIds = ownedBookGuildIds ?? [],
       hintedQuestions = hintedQuestions ?? {},
       xpPerClick = xpPerClick ?? clickXp;

  Map<String, dynamic> toJson() {
    return {
      'slot': slot,
      'guildId': guildId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'level': level,
      'experience': experience,
      'clickXp': clickXp,
      'xpPerClick': xpPerClick,
      'hints': hints,
      'guildKnowledge': guildKnowledge,
      'literatura': literatura,
      'exatas': exatas,
      'natureza': natureza,
      'humanas': humanas,
      'coins': coins,
      'books': books,
      'bookshelves': bookshelves,
      'shoes': shoes,
      'health': health,
      'defeatedGuildIds': defeatedGuildIds,
      'ownedBookGuildIds': ownedBookGuildIds,
      'hasGoldenDiploma': hasGoldenDiploma,
      'hintedQuestions': hintedQuestions,
    };
  }

  factory GameSave.fromJson(Map<String, dynamic> json) {
    // Migração dos saves antigos: os atributos anteriores
    // tinham escala de 1 a 7. Multiplicamos por 10.
    int readAttribute(String key) {
      final value = (json[key] as num?)?.toInt() ?? 50;

      if (value <= 7) {
        return (value * 10).clamp(10, 70).toInt();
      }

      return value.clamp(0, 100).toInt();
    }

    final rawHints = json['hintedQuestions'] as Map<String, dynamic>? ?? {};

    return GameSave(
      slot: (json['slot'] as num).toInt(),
      guildId: json['guildId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      level: (json['level'] as num?)?.toInt() ?? 1,
      experience: (json['experience'] as num?)?.toInt() ?? 0,
      clickXp: (json['clickXp'] as num?)?.toInt() ??
          (json['xpPerClick'] as num?)?.toInt() ?? 1,
      xpPerClick: (json['xpPerClick'] as num?)?.toInt() ??
          (json['clickXp'] as num?)?.toInt() ?? 1,
      hints: (json['hints'] as num?)?.toInt() ?? 0,
      guildKnowledge: (json['guildKnowledge'] as num?)?.toInt() ?? 0,
      literatura: readAttribute('literatura'),
      exatas: readAttribute('exatas'),
      natureza: readAttribute('natureza'),
      humanas: readAttribute('humanas'),
      coins: (json['coins'] as num?)?.toInt() ?? 0,
      books: (json['books'] as num?)?.toInt() ?? 0,
      bookshelves: (json['bookshelves'] as num?)?.toInt() ?? 0,
      shoes: (json['shoes'] as num?)?.toInt() ?? 0,
      health: (json['health'] as num?)?.toInt() ?? 1000,
      defeatedGuildIds: List<String>.from(json['defeatedGuildIds'] ?? []),
      ownedBookGuildIds: List<String>.from(json['ownedBookGuildIds'] ?? []),
      hasGoldenDiploma: json['hasGoldenDiploma'] as bool? ?? false,
      hintedQuestions: rawHints.map(
        (key, value) => MapEntry(key, List<String>.from(value as List)),
      ),
    );
  }
}
