import '../models/game_save.dart';

class ProgressionService {
  static int xpRequired(int level) {
    return 10 + (level - 1) * 5;
  }

  static bool canLevelUp(GameSave save) {
    return save.experience >= xpRequired(save.level);
  }

  static void addExperience(GameSave save, {int? amount}) {
    save.experience += amount ?? save.xpPerClick;
  }

  static bool hasAvailableAttribute(GameSave save) {
    return save.literatura < 100 ||
        save.exatas < 100 ||
        save.natureza < 100 ||
        save.humanas < 100;
  }

  static bool applySpecialization(GameSave save, String specialization) {
    if (!canLevelUp(save)) return false;

    switch (specialization) {
      case 'literatura':
        if (save.literatura >= 100) return false;
        save.literatura++;
        break;

      case 'exatas':
        if (save.exatas >= 100) return false;
        save.exatas++;
        break;

      case 'natureza':
        if (save.natureza >= 100) return false;
        save.natureza++;
        break;

      case 'humanas':
        if (save.humanas >= 100) return false;
        save.humanas++;
        break;

      case 'xp':
        save.xpPerClick++;
        break;

      case 'hints':
        save.hints++;
        break;

      case 'knowledge':
        if (save.guildKnowledge >= 100) return false;

        save.guildKnowledge = (save.guildKnowledge + 5).clamp(0, 100);
        break;

      default:
        return false;
    }

    save.experience -= xpRequired(save.level);
    save.level++;

    return true;
  }
}
