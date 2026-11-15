import '../models/game_save.dart';
import '../data/course_questions.dart';

class HintService {
  static List<String> availableHints(GameSave save, String guildId) {
    final questions = courseQuestions[guildId] ?? [];

    final used = save.hintedQuestions[guildId] ?? [];

    return questions
        .where((q) => !used.contains(q.id))
        .map((q) => q.id)
        .toList();
  }

  static CourseQuestion? giveHint(GameSave save, String guildId) {
    final questions = courseQuestions[guildId] ?? [];

    final used = save.hintedQuestions[guildId] ?? [];

    final question = questions.cast<CourseQuestion?>().firstWhere(
      (q) => q != null && !used.contains(q.id),
      orElse: () => null,
    );

    if (question == null) return null;

    save.hintedQuestions.putIfAbsent(guildId, () => []);

    save.hintedQuestions[guildId]!.add(question.id);

    return question;
  }

  static bool allHintsUsed(GameSave save, String guildId) {
    return availableHints(save, guildId).isEmpty;
  }
}
