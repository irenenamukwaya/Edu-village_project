import 'package:flutter/material.dart';
import 'package:eduvillage/services/coin_service.dart';

/// Provider for managing coin state
// Tracks coin balance and persists it locally.
class CoinProvider extends ChangeNotifier {
  final CoinService _coinService = CoinService();
  int _coins = 100;
  bool _isLoading = true;
  bool _mathChallengeUnlocked = false;

  int get coins => _coins;
  bool get isLoading => _isLoading;
  bool get mathChallengeUnlocked => _mathChallengeUnlocked;

  /// Initialize the provider
  Future<void> initialize() async {
    await _coinService.initialize();
    _coins = await _coinService.getCoins();
    _mathChallengeUnlocked = await _coinService.isMathChallengeUnlocked();
    _isLoading = false;
    notifyListeners();
  }

  /// Add coins
  Future<void> addCoins(int amount) async {
    await _coinService.addCoins(amount);
    _coins = await _coinService.getCoins();
    notifyListeners();
  }

  /// Deduct coins
  Future<void> deductCoins(int amount) async {
    await _coinService.deductCoins(amount);
    _coins = await _coinService.getCoins();
    notifyListeners();
  }

  /// Reset coins
  Future<void> resetCoins() async {
    await _coinService.resetCoins();
    _coins = await _coinService.getCoins();
    notifyListeners();
  }

  /// Refresh coin balance
  Future<void> refreshCoins() async {
    _coins = await _coinService.getCoins();
    _mathChallengeUnlocked = await _coinService.isMathChallengeUnlocked();
    notifyListeners();
  }

  /// Check if player has enough coins
  Future<bool> hasEnoughCoins(int requiredAmount) async {
    return await _coinService.hasEnoughCoins(requiredAmount);
  }

  /// Unlock the level 2 math challenge if the child has enough coins.
  Future<bool> unlockMathChallenge(int unlockCost) async {
    final didUnlock = await _coinService.unlockMathChallenge(unlockCost);
    _coins = await _coinService.getCoins();
    _mathChallengeUnlocked = await _coinService.isMathChallengeUnlocked();
    notifyListeners();
    return didUnlock;
  }
}
