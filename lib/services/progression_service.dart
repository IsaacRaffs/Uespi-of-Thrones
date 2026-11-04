import '../models/game_save.dart';

class ProgressionService {
  static int xpRequired(int level) {
    return 10 + ((level - 1) * 5);
  }

  static bool canLevelUp(GameSave save) {
    return save.experience >= xpRequired(save.level);
  }

  static void addExperience(GameSave save, {int amount = 1}) {
    if (amount <= 0) return;

    save.experience += amount;
  }

  static bool upgradeAttribute(GameSave save, String attribute) {
    if (!canLevelUp(save)) return false;

    switch (attribute) {
      case 'literatura':
        if (save.literatura >= 7) return false;
        save.literatura++;
        break;

      case 'exatas':
        if (save.exatas >= 7) return false;
        save.exatas++;
        break;

      case 'natureza':
        if (save.natureza >= 7) return false;
        save.natureza++;
        break;

      case 'humanas':
        if (save.humanas >= 7) return false;
        save.humanas++;
        break;

      default:
        return false;
    }

    save.experience -= xpRequired(save.level);
    save.level++;

    return true;
  }
}
