class GameSave {
  final int slot;
  final String guildId;

  final DateTime createdAt;
  DateTime updatedAt;

  int level;
  int experience;
  int clickXp;

  int literatura;
  int exatas;
  int natureza;
  int humanas;

  int coins;
  int books;
  int health;

  int xpPerClick;
  int hints;
  int guildKnowledge;
  List<String> defeatedGuildIds;

  /// IDs das guildas cujos livros foram comprados.
  /// Mantém a aquisição persistida por partida.
  List<String> ownedBookGuildIds;

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
    this.literatura = 50,
    this.exatas = 50,
    this.natureza = 50,
    this.humanas = 50,
    this.coins = 0,
    this.books = 0,
    this.health = 1000,
    this.xpPerClick = 1,
    this.hints = 0,
    this.guildKnowledge = 0,
    List<String>? defeatedGuildIds,
    List<String>? ownedBookGuildIds,
    Map<String, List<String>>? hintedQuestions,
  }) : defeatedGuildIds = defeatedGuildIds ?? [],
       ownedBookGuildIds = ownedBookGuildIds ?? [],
       hintedQuestions = hintedQuestions ?? {};

  Map<String, dynamic> toJson() {
    return {
      'slot': slot,
      'guildId': guildId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'level': level,
      'experience': experience,
      'clickXp': clickXp,
      'literatura': literatura,
      'exatas': exatas,
      'natureza': natureza,
      'humanas': humanas,
      'coins': coins,
      'books': books,
      'health': health,
      'defeatedGuildIds': defeatedGuildIds,
      'ownedBookGuildIds': ownedBookGuildIds,
      'hintedQuestions': hintedQuestions,
      'xpPerClick': xpPerClick,
      'hints': hints,
      'guildKnowledge': guildKnowledge,
    };
  }

  factory GameSave.fromJson(Map<String, dynamic> json) {
    // Migração dos saves antigos: os atributos anteriores
    // tinham escala de 1 a 7. Multiplicamos por 10.
    int readAttribute(String key) {
      final value = (json[key] as num?)?.toInt() ?? 50;

      if (value <= 7) {
        return (value * 10).clamp(10, 70);
      }

      return value.clamp(0, 100);
    }

    final rawHints = json['hintedQuestions'] as Map<String, dynamic>? ?? {};

    return GameSave(
      slot: (json['slot'] as num).toInt(),
      guildId: json['guildId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      level: (json['level'] as num?)?.toInt() ?? 1,
      experience: (json['experience'] as num?)?.toInt() ?? 0,
      clickXp: (json['clickXp'] as num?)?.toInt() ?? 1,
      literatura: readAttribute('literatura'),
      exatas: readAttribute('exatas'),
      xpPerClick: json['xpPerClick'] as int? ?? 1,
      hints: json['hints'] as int? ?? 0,
      guildKnowledge: json['guildKnowledge'] as int? ?? 0,
      natureza: readAttribute('natureza'),
      humanas: readAttribute('humanas'),
      coins: (json['coins'] as num?)?.toInt() ?? 0,
      books: (json['books'] as num?)?.toInt() ?? 0,
      health: (json['health'] as num?)?.toInt() ?? 1000,
      defeatedGuildIds: List<String>.from(json['defeatedGuildIds'] ?? []),
      ownedBookGuildIds: List<String>.from(json['ownedBookGuildIds'] ?? []),
      hintedQuestions: rawHints.map(
        (key, value) => MapEntry(key, List<String>.from(value as List)),
      ),
    );
  }
}
