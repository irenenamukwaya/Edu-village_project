import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eduvillage/models/object_model.dart';
import 'package:eduvillage/services/question_service.dart';
import 'package:eduvillage/providers/game_provider.dart';
import 'package:eduvillage/providers/coin_provider.dart';
import 'package:eduvillage/widgets/game_button.dart';
import 'package:eduvillage/widgets/option_button.dart';
import 'package:eduvillage/widgets/question_card.dart';
import 'package:eduvillage/widgets/coin_display.dart';
import 'package:eduvillage/widgets/music_settings_button.dart';
import 'package:eduvillage/widgets/interactive_picture_card.dart';
import 'package:eduvillage/utils/constants.dart';
import 'package:eduvillage/screens/reward/reward_screen.dart';

/// Object Recognition Game Screen
class ObjectGameScreen extends StatefulWidget {
  const ObjectGameScreen({Key? key}) : super(key: key);

  @override
  State<ObjectGameScreen> createState() => _ObjectGameScreenState();
}

class _ObjectGameScreenState extends State<ObjectGameScreen> {
  late List<ObjectQuestion> questions = [];
  late List<String> currentOptions = [];
  bool isLoading = true;
  String? selectedAnswer;
  bool isAnswered = false;
  int currentIndex = 0;
  int correctAnswers = 0;
  int coinsEarned = 0;
  bool lastAnswerCorrect = false;
  String? feedbackMessage;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final allQuestions = await QuestionService.loadObjectQuestions();
    final gameQuestions = QuestionService.getRandomQuestions(
      allQuestions,
      AppConstants.totalQuestionsPerGame,
    );

    setState(() {
      questions = gameQuestions;
      currentOptions = gameQuestions.isEmpty
          ? []
          : QuestionService.shuffleOptions(gameQuestions.first.options);
      isLoading = false;
    });

    if (mounted) {
      context.read<GameProvider>().startGame();
    }
  }

  Future<void> _onAnswerSelected(String answer) async {
    if (isAnswered) return;

    final currentQuestion = questions[currentIndex];
    final isCorrect =
        answer.toLowerCase() == currentQuestion.correctAnswer.toLowerCase();
    final gameProvider = context.read<GameProvider>();
    final coinProvider = context.read<CoinProvider>();

    setState(() {
      selectedAnswer = answer;
      isAnswered = true;
      lastAnswerCorrect = isCorrect;
      feedbackMessage = isCorrect
          ? 'Nice one! You found the object.'
          : 'That was not it. Try again and study the picture.';
    });

    if (isCorrect) {
      correctAnswers++;
      coinsEarned += AppConstants.coinsPerCorrectAnswer;
      await gameProvider.playCorrectSound();
      await coinProvider.addCoins(AppConstants.coinsPerCorrectAnswer);
    } else {
      await gameProvider.playWrongSound();
    }
  }

  void _retryQuestion() {
    setState(() {
      selectedAnswer = null;
      isAnswered = false;
      lastAnswerCorrect = false;
      feedbackMessage = null;
    });
  }

  Future<void> _onNextQuestion() async {
    if (!isAnswered || !lastAnswerCorrect || questions.isEmpty) return;

    final coinProvider = context.read<CoinProvider>();
    final gameProvider = context.read<GameProvider>();

    if (currentIndex + 1 >= questions.length) {
      coinsEarned += AppConstants.coinsPerRoundCompletion;
      await coinProvider.addCoins(AppConstants.coinsPerRoundCompletion);
      await gameProvider.playCoinSound();

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => RewardScreen(
              gameType: GameType.object,
              correctAnswers: correctAnswers,
              totalQuestions: questions.length,
              coinsEarned: coinsEarned,
            ),
          ),
        );
      }
    } else {
      final nextIndex = currentIndex + 1;
      setState(() {
        currentIndex = nextIndex;
        selectedAnswer = null;
        isAnswered = false;
        lastAnswerCorrect = false;
        feedbackMessage = null;
        currentOptions = QuestionService.shuffleOptions(
          questions[nextIndex].options,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || questions.isEmpty) {
      return Scaffold(
        backgroundColor: AppConstants.backgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final currentQuestion = questions[currentIndex];
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          MusicSettingsButton(),
          Padding(padding: EdgeInsets.all(16.0), child: CoinDisplay()),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Question Card with Image
              QuestionCard(
                question: 'What is this object?',
                currentQuestion: currentIndex + 1,
                totalQuestions: questions.length,
                imageWidget: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InteractivePictureCard(
                    assetPath: currentQuestion.imagePath,
                    caption: 'Look closely and name the object.',
                    fallbackEmoji: '🧩',
                    accentColor: const Color(0xFF4ECDC4),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              if (feedbackMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: lastAnswerCorrect
                        ? AppConstants.successColor.withOpacity(0.12)
                        : AppConstants.warningColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: lastAnswerCorrect
                          ? AppConstants.successColor.withOpacity(0.3)
                          : AppConstants.warningColor.withOpacity(0.35),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        lastAnswerCorrect ? Icons.celebration : Icons.refresh,
                        color: lastAnswerCorrect
                            ? AppConstants.successColor
                            : const Color(0xFF9A6700),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          feedbackMessage!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Options
              Text(
                'Choose the correct answer:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 16),

              ...currentOptions.map((option) {
                final isSelected = selectedAnswer == option;
                final isCorrect = option == currentQuestion.correctAnswer;

                return OptionButton(
                  label: option,
                  isSelected: isSelected,
                  isCorrect: isCorrect,
                  isAnswered: isAnswered,
                  onPressed: () => _onAnswerSelected(option),
                );
              }),

              const SizedBox(height: 30),

              // Next Button
              if (isAnswered && lastAnswerCorrect)
                GameButton(
                  label: currentIndex + 1 >= questions.length
                      ? 'See Results'
                      : 'Next Question',
                  onPressed: _onNextQuestion,
                  height: 60,
                  fontSize: 18,
                )
              else if (isAnswered)
                GameButton(
                  label: 'Try Again',
                  onPressed: _retryQuestion,
                  backgroundColor: AppConstants.warningColor,
                  textColor: Colors.black87,
                  height: 60,
                  fontSize: 18,
                )
              else
                GameButton(
                  label: 'Select an answer',
                  onPressed: () {},
                  height: 60,
                  fontSize: 18,
                  isEnabled: false,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
