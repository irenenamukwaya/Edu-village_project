import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eduvillage/utils/constants.dart';
import 'package:eduvillage/utils/helpers.dart';
import 'package:eduvillage/providers/coin_provider.dart';
import 'package:eduvillage/widgets/game_button.dart';

/// Reward/Results Screen
// Presents the reward animation after a successful round.
class RewardScreen extends StatefulWidget {
  final GameType gameType;
  final int correctAnswers;
  final int totalQuestions;
  final int coinsEarned;

  const RewardScreen({
    Key? key,
    required this.gameType,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.coinsEarned,
  }) : super(key: key);

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _unlockChallengeLevel() async {
    final coinProvider = context.read<CoinProvider>();
    final didUnlock = await coinProvider.unlockMathChallenge(
      AppConstants.mathChallengeUnlockCost,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          didUnlock
              ? 'Level 2 Challenge unlocked. Head to Math and Counting to play it.'
              : 'You need ${AppConstants.mathChallengeUnlockCost} coins to unlock Level 2 Challenge.',
        ),
      ),
    );
  }

  String _getGameTitle() {
    switch (widget.gameType) {
      case GameType.activity:
        return 'Activity Game';
      case GameType.object:
        return 'Object Game';
      case GameType.word:
        return 'Word Game';
      case GameType.math:
        return 'Math Game';
    }
  }

  @override
  Widget build(BuildContext context) {
    final percentage = ((widget.correctAnswers / widget.totalQuestions) * 100)
        .toInt();
    final praiseMessage = AppHelpers.getPraiseMessage(
      widget.correctAnswers,
      widget.totalQuestions,
    );
    final emoji = AppHelpers.getEmojiByPercentage(percentage);

    return Scaffold(
      backgroundColor: AppConstants.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // Celebration animation
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.symmetric(horizontal: 100),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 60),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Title and praise
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        praiseMessage,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _getGameTitle(),
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Results Card
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: [
                          // Correct Answers
                          Text(
                            'Your Score',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: AppConstants.successColor
                                          .withOpacity(0.15),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppConstants.successColor
                                            .withOpacity(0.3),
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.correctAnswers.toString(),
                                        style: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: AppConstants.successColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Correct',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.grey[400]!,
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$percentage%',
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Score',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          // Divider
                          Container(height: 1, color: Colors.grey[300]),

                          const SizedBox(height: 30),

                          // Coins Earned
                          Text(
                            'Coins Earned',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.monetization_on,
                                color: Colors.amber,
                                size: 40,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '+${widget.coinsEarned}',
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                Consumer<CoinProvider>(
                  builder: (context, coinProvider, _) {
                    if (coinProvider.mathChallengeUnlocked) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: const Text(
                            'Level 2 Challenge is unlocked. Your child can now play the math adventure mode.',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    final hasEnoughCoins =
                        coinProvider.coins >=
                        AppConstants.mathChallengeUnlockCost;

                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(22),
                          child: Column(
                            children: [
                              const Text(
                                'Spend Coins on Something Fun',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Unlock the Level 2 math challenge for ${AppConstants.mathChallengeUnlockCost} coins.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              GameButton(
                                label: hasEnoughCoins
                                    ? 'Unlock Level 2'
                                    : 'Need ${AppConstants.mathChallengeUnlockCost - coinProvider.coins} more coins',
                                onPressed: hasEnoughCoins
                                    ? _unlockChallengeLevel
                                    : () {},
                                height: 56,
                                fontSize: 16,
                                backgroundColor: hasEnoughCoins
                                    ? const Color(0xFFFFE66D)
                                    : Colors.grey,
                                textColor: Colors.black87,
                                isEnabled: hasEnoughCoins,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 28),

                // Action Buttons
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GameButton(
                        label: 'Play Again',
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            _getGameRoute(),
                            (route) => route.isFirst,
                          );
                        },
                        backgroundColor: Colors.white,
                        textColor: AppConstants.primaryColor,
                        height: 60,
                        fontSize: 18,
                      ),
                      const SizedBox(height: 16),
                      GameButton(
                        label: 'Back to Home',
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/home',
                            (route) => route.isFirst,
                          );
                        },
                        backgroundColor: Colors.white.withOpacity(0.3),
                        textColor: Colors.white,
                        height: 60,
                        fontSize: 18,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getGameRoute() {
    switch (widget.gameType) {
      case GameType.activity:
        return '/activity-game';
      case GameType.object:
        return '/object-game';
      case GameType.word:
        return '/word-game';
      case GameType.math:
        return '/math-game';
    }
  }
}
