import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eduvillage/providers/coin_provider.dart';
import 'package:eduvillage/widgets/coin_display.dart';
import 'package:eduvillage/widgets/music_settings_button.dart';
import 'package:eduvillage/utils/constants.dart';

/// Home Screen
// Shows the home hub and refreshes state when returning.
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh coins when returning to home screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoinProvider>().refreshCoins();
    });
  }

  @override
  Widget build(BuildContext context) {
    final coinProvider = context.watch<CoinProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome to',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            AppConstants.appName,
                            style: AppConstants.titleStyle,
                          ),
                        ],
                      ),
                    ),
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CoinDisplay(fontSize: 20),
                        SizedBox(width: 6),
                        MusicSettingsButton(),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Game selection title
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Choose a Game',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Games Grid
                _buildGameCard(
                  context,
                  emoji: '🎬',
                  title: 'Activity\nRecognition',
                  description: 'Guess what people are doing!',
                  color: const Color(0xFFFF6B6B),
                  onTap: () => Navigator.pushNamed(context, '/activity-game'),
                ),
                const SizedBox(height: 16),
                _buildGameCard(
                  context,
                  emoji: '🎯',
                  title: 'Object\nRecognition',
                  description: 'Identify objects around you!',
                  color: const Color(0xFF4ECDC4),
                  onTap: () => Navigator.pushNamed(context, '/object-game'),
                ),
                const SizedBox(height: 16),
                _buildGameCard(
                  context,
                  emoji: '🔊',
                  title: 'Word\nPronunciation',
                  description: 'Learn to pronounce new words!',
                  color: const Color(0xFFFFE66D),
                  onTap: () => Navigator.pushNamed(context, '/word-game'),
                ),
                const SizedBox(height: 16),
                _buildGameCard(
                  context,
                  emoji: '🧮',
                  title: 'Math &\nCounting',
                  description: coinProvider.mathChallengeUnlocked
                      ? 'Learn numbers and math! Level 2 is unlocked.'
                      : 'Learn numbers and math! Earn coins to unlock Level 2.',
                  color: const Color(0xFF95E1D3),
                  onTap: () => Navigator.pushNamed(context, '/math-game'),
                ),
                const SizedBox(height: 40),

                // Footer
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppConstants.primaryColor.withOpacity(0.14),
                        AppConstants.primaryColor.withOpacity(0.06),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: AppConstants.primaryColor.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: AppConstants.primaryColor,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          coinProvider.mathChallengeUnlocked
                              ? 'Great work. Your coins unlocked the Level 2 math challenge.'
                              : 'Earn coins by answering questions correctly and unlock Level 2 math fun.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
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

  Widget _buildGameCard(
    BuildContext context, {
    required String emoji,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.white, Color(0xFFFBFDFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Emoji
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 48)),
              ),
            ),
            const SizedBox(width: 20),
            // Title and description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Arrow
            Icon(Icons.arrow_forward_ios, color: color, size: 24),
          ],
        ),
      ),
    );
  }
}
