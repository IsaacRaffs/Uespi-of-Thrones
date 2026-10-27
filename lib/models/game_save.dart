
class GameSave {
  final int slot;
  final String guildId;
  final DateTime createdAt;
  final DateTime updatedAt;

  final int coins;
  final int books;
  final int bookshelves;
  final int shoes;
  final int health;

  GameSave({
    required this.slot,
    required this.guildId,
    required this.createdAt,
    required this.updatedAt,
    this.coins = 0,
    this.books = 0,
    this.bookshelves = 0,
    this.shoes = 0,
    this.health = 1000,
  });

  Map<String, dynamic> toJson() => {
    'slot': slot,
    'guildId': guildId,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'coins': coins,
    'books': books,
    'bookshelves': bookshelves,
    'shoes': shoes,
    'health': health,
  };

  factory GameSave.fromJson(Map<String, dynamic> json) {
    return GameSave(
      slot: json['slot'] as int,
      guildId: json['guildId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      coins: json['coins'] as int? ?? 0,
      books: json['books'] as int? ?? 0,
      bookshelves: json['bookshelves'] as int? ?? 0,
      shoes: json['shoes'] as int? ?? 0,
      health: json['health'] as int? ?? 1000,
    );
  }
}
