import 'package:flutter/material.dart';

import '../data/book_catalog.dart';
import '../data/course_questions.dart';
import '../data/guild_data.dart';
import '../models/game_save.dart';

class BookLibraryScreen extends StatefulWidget {
  final GameSave save;
  final Future<void> Function() onChanged;

  const BookLibraryScreen({
    super.key,
    required this.save,
    required this.onChanged,
  });

  @override
  State<BookLibraryScreen> createState() => _BookLibraryScreenState();
}

class _BookLibraryScreenState extends State<BookLibraryScreen> {
  static const Color parchment = Color(0xFFF0E2C3);
  static const Color ink = Color(0xFF382719);
  static const Color gold = Color(0xFFC49A45);

  GameSave get save => widget.save;

  bool owns(String guildId) => save.ownedBookGuildIds.contains(guildId);

  Future<void> buyBook(GuildBook book, String guildName) async {
    if (owns(book.guildId)) return;

    if (save.coins < GuildBook.price) {
      final missing = GuildBook.price - save.coins;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Faltam $missing coins para adquirir este tomo.'),
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: parchment,
        title: const Text('Adquirir tomo raro?', style: TextStyle(color: ink)),
        content: Text(
          'Comprar "$guildName" por ${GuildBook.price} coins?\n\n'
          'O livro ficará permanentemente disponível nesta partida.',
          style: const TextStyle(color: ink),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Voltar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF654323),
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Comprar'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    // A operação é atômica no estado da partida: nunca desconta sem registrar.
    if (save.coins < GuildBook.price || owns(book.guildId)) return;
    setState(() {
      save.coins -= GuildBook.price;
      save.ownedBookGuildIds.add(book.guildId);
      save.books = save.ownedBookGuildIds.length;
      save.updatedAt = DateTime.now();
    });
    await widget.onChanged();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('"$guildName" foi adicionado à sua biblioteca!')),
    );
  }

  void openBook(GuildBook book, String guildName) {
    final questions = courseQuestions[book.guildId] ?? const [];

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: parchment,
      builder: (sheetContext) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.82,
        maxChildSize: 0.95,
        builder: (context, scrollController) => ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: ink.withValues(alpha: .35),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Icon(book.icon, size: 48, color: const Color(0xFF79552D)),
            const SizedBox(height: 8),
            Text(
              book.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: ink,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              guildName,
              textAlign: TextAlign.center,
              style: TextStyle(color: ink.withValues(alpha: .75)),
            ),
            const SizedBox(height: 22),
            _sectionTitle('CONHECIMENTO ACADÊMICO'),
            const SizedBox(height: 10),
            ...book.chapters.map(
              (chapter) => Card(
                color: const Color(0xFFE5D2AA),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chapter.title,
                        style: const TextStyle(
                          color: ink,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        chapter.summary,
                        style: TextStyle(color: ink.withValues(alpha: .85)),
                      ),
                      const SizedBox(height: 8),
                      ...chapter.topics.map(
                        (topic) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '◆  ',
                                style: TextStyle(color: Color(0xFF946B32)),
                              ),
                              Expanded(
                                child: Text(
                                  topic,
                                  style: const TextStyle(color: ink),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            _sectionTitle('PERGAMINHOS DE AVALIAÇÃO (${questions.length})'),
            const SizedBox(height: 8),
            if (questions.isEmpty)
              const Text(
                'Ainda não há perguntas cadastradas para esta guilda.',
                style: TextStyle(color: ink),
              )
            else
              ...List.generate(questions.length, (index) {
                final question = questions[index];
                return Card(
                  color: const Color(0xFFE5D2AA),
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 9),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${index + 1}. ${question.question}',
                          style: const TextStyle(
                            color: ink,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...List.generate(question.options.length, (
                          optionIndex,
                        ) {
                          final correct = optionIndex == question.correctIndex;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  correct
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  size: 16,
                                  color: correct
                                      ? Colors.green.shade800
                                      : ink.withValues(alpha: .5),
                                ),
                                const SizedBox(width: 7),
                                Expanded(
                                  child: Text(
                                    question.options[optionIndex],
                                    style: TextStyle(
                                      color: ink,
                                      fontWeight: correct
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              }),
            const SizedBox(height: 12),
            Text(
              'Este tomo revela o conteúdo de estudo e o banco de perguntas atualmente cadastrado para esta guilda.',
              style: TextStyle(color: ink.withValues(alpha: .7), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(
    title,
    style: const TextStyle(
      color: ink,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.1,
      fontSize: 13,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF241A13),
      appBar: AppBar(
        backgroundColor: const Color(0xFF382719),
        foregroundColor: parchment,
        title: const Text('Biblioteca Real'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Row(
                children: [
                  const Icon(Icons.monetization_on, color: gold),
                  const SizedBox(width: 5),
                  Text(
                    '${save.coins} coins',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(14, 14, 14, 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: parchment,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: gold, width: 2),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_stories,
                  size: 38,
                  color: Color(0xFF79552D),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'O saber tem seu preço',
                        style: TextStyle(
                          color: ink,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Cada tomo custa ${GuildBook.price} coins e revela o conhecimento de uma guilda.',
                        style: TextStyle(
                          color: ink.withValues(alpha: .8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TOMOS: ${save.ownedBookGuildIds.length}/${guildBooks.length}',
                  style: const TextStyle(
                    color: parchment,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text('15 guildas', style: TextStyle(color: gold)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(14, 4, 14, 18),
              itemCount: guildBooks.length,
              itemBuilder: (context, index) {
                final book = guildBooks[index];
                final guild = guilds.firstWhere((g) => g.id == book.guildId);
                final purchased = owns(book.guildId);
                return Card(
                  color: const Color(0xFF3B2A1D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: purchased ? gold : const Color(0xFF725538),
                      width: purchased ? 2 : 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          width: 54,
                          height: 68,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6B482A),
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(color: gold),
                          ),
                          child: Icon(book.icon, color: parchment, size: 30),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.title,
                                style: const TextStyle(
                                  color: parchment,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                guild.name,
                                style: const TextStyle(
                                  color: Color(0xFFD2B77F),
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                purchased
                                    ? 'Adquirido • ${book.chapters.length} capítulos'
                                    : '${GuildBook.price} coins',
                                style: TextStyle(
                                  color: purchased ? gold : Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        purchased
                            ? IconButton(
                                tooltip: 'Ler livro',
                                onPressed: () => openBook(book, guild.name),
                                icon: const Icon(
                                  Icons.menu_book,
                                  color: gold,
                                  size: 28,
                                ),
                              )
                            : IconButton(
                                tooltip: 'Comprar livro',
                                onPressed: () => buyBook(book, guild.name),
                                icon: const Icon(
                                  Icons.shopping_bag_outlined,
                                  color: parchment,
                                  size: 26,
                                ),
                              ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
