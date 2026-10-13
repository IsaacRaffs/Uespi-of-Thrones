import '../models/guild.dart';

class RewardService {
  void giveDailyReward(Guild guild) {
    guild.coins += 100;
    guild.books += 2;
    guild.bookshelves += 1;
    guild.shoes += 1;
  }
}