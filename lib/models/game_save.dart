class GameSave {
  final int slot;
  final String guildId;

  final DateTime createdAt;
  DateTime updatedAt;

  int level;
  int experience;

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

  GameSave({
    required this.slot,
    required this.guildId,
    required this.createdAt,
    required this.updatedAt,
    this.level = 1,
    this.experience = 0,
    this.literatura = 1,
    this.exatas = 1,
    this.natureza = 1,
    this.humanas = 1,
    this.coins = 0,
    this.books = 0,
    this.bookshelves = 0,
    this.shoes = 0,
    this.health = 1000,
    List<String>? defeatedGuildIds,
  }) : defeatedGuildIds = defeatedGuildIds ?? [];

  Map<String, dynamic> toJson() {
    return {
      'slot': slot,
      'guildId': guildId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'level': level,
      'experience': experience,
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
    };
  }

  factory GameSave.fromJson(Map<String, dynamic> json) {
    return GameSave(
      slot: json['slot'] as int,
      guildId: json['guildId'] as String,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      level: json['level'] as int? ?? 1,
      experience: json['experience'] as int? ?? 0,
      literatura: json['literatura'] as int? ?? 1,
      exatas: json['exatas'] as int? ?? 1,
      natureza: json['natureza'] as int? ?? 1,
      humanas: json['humanas'] as int? ?? 1,
      coins: json['coins'] as int? ?? 0,
      books: json['books'] as int? ?? 0,
      bookshelves: json['bookshelves'] as int? ?? 0,
      shoes: json['shoes'] as int? ?? 0,
      health: json['health'] as int? ?? 1000,
      defeatedGuildIds: List<String>.from(json['defeatedGuildIds'] ?? []),
    );
  }
}
