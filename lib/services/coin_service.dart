import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing coins and rewards
class CoinService {
  static const String _coinsKey = 'eduvillage_coins';
  static const String _mathChallengeUnlockedKey =
      'eduvillage_math_challenge_unlocked';
  static const int _initialCoins = 100;

  late SharedPreferences _prefs;

  /// Initialize the service
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Get current coin balance
  Future<int> getCoins() async {
    return _prefs.getInt(_coinsKey) ?? _initialCoins;
  }

  /// Add coins
  Future<void> addCoins(int amount) async {
    final currentCoins = await getCoins();
    await _prefs.setInt(_coinsKey, currentCoins + amount);
  }

  /// Deduct coins
  Future<void> deductCoins(int amount) async {
    final currentCoins = await getCoins();
    final newAmount = (currentCoins - amount).clamp(0, 999999);
    await _prefs.setInt(_coinsKey, newAmount);
  }

  /// Reset coins to initial amount
  Future<void> resetCoins() async {
    await _prefs.setInt(_coinsKey, _initialCoins);
  }

  /// Set coins to specific amount
  Future<void> setCoins(int amount) async {
    await _prefs.setInt(_coinsKey, amount);
  }

  /// Check if player has enough coins
  Future<bool> hasEnoughCoins(int requiredAmount) async {
    final currentCoins = await getCoins();
    return currentCoins >= requiredAmount;
  }

  /// Whether the level 2 math challenge is unlocked.
  Future<bool> isMathChallengeUnlocked() async {
    return _prefs.getBool(_mathChallengeUnlockedKey) ?? false;
  }

  /// Spend coins to unlock the level 2 math challenge.
  Future<bool> unlockMathChallenge(int unlockCost) async {
    if (await isMathChallengeUnlocked()) {
      return true;
    }

    final currentCoins = await getCoins();
    if (currentCoins < unlockCost) {
      return false;
    }

    await _prefs.setInt(_coinsKey, currentCoins - unlockCost);
    await _prefs.setBool(_mathChallengeUnlockedKey, true);
    return true;
  }
}
