import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eduvillage/providers/game_provider.dart';
import 'package:eduvillage/providers/coin_provider.dart';
import 'package:eduvillage/widgets/game_button.dart';
import 'package:eduvillage/widgets/option_button.dart';
import 'package:eduvillage/widgets/coin_display.dart';
import 'package:eduvillage/widgets/music_settings_button.dart';
import 'package:eduvillage/widgets/interactive_picture_card.dart';
import 'package:eduvillage/utils/constants.dart';
import 'package:eduvillage/utils/helpers.dart';
import 'package:eduvillage/models/math_model.dart';
import 'package:eduvillage/screens/reward/reward_screen.dart';

/// Math and Counting Game Screen
// Runs the math learning game loop.
class MathGameScreen extends StatefulWidget {
  const MathGameScreen({Key? key}) : super(key: key);

  @override
  State<MathGameScreen> createState() => _MathGameScreenState();
}

class _MathGameScreenState extends State<MathGameScreen> {
  static const int _numberExercisePassMark = 7;
  static const int _maxNumberAttemptsPerQuestion = 3;

  late GameProvider _gameProvider;
  MathGameMode currentMode = MathGameMode.numberLearning;
  bool numberIdentificationQualified = false;
  bool modeSelected = false;
  int currentIndex = 0;
  String? selectedAnswer;
  bool isAnswered = false;
  bool lastAnswerCorrect = false;
  String? feedbackMessage;
  int correctAnswers = 0;
  int coinsEarned = 0;
  int numberAttemptsForCurrent = 0;

  // Data for each mode
  late List<NumberLearning> numberLearnings = [];
  late List<List<int>> numberIdentificationOptions = [];
  late List<CountingQuestion> countingQuestions = [];
  late List<ArithmeticQuestion> arithmeticQuestions = [];

  @override
  void initState() {
    super.initState();
    _gameProvider = context.read<GameProvider>();
    _initializeMath();
  }

  Future<void> _initializeMath() async {
    context.read<GameProvider>().startGame();

    // Generate number learning data
    numberLearnings = List.generate(
      10,
      (index) => NumberLearning(
        number: index + 1,
        word: AppHelpers.numberToWord(index + 1),
        imagePath: 'assets/images/numbers/${index + 1}.jpg',
      ),
    );

    numberIdentificationOptions = List.generate(
      numberLearnings.length,
      (index) =>
          _buildNumberOptions(index + 1, min: 1, max: 10, optionCount: 3),
    );

    // Generate counting questions
    countingQuestions = List.generate(10, (index) {
      final count = AppHelpers.randomInt(1, 10);
      final options = _buildNumberOptions(count, min: 1, max: 10);

      return CountingQuestion(
        id: 'counting_$index',
        count: count,
        object: 'Ball',
        objectEmoji: '⚽',
        options: options,
      );
    });

    // Generate arithmetic questions
    arithmeticQuestions = List.generate(10, (index) {
      final operation = AppHelpers.getRandomOperation();
      late int first, second;

      switch (operation) {
        case ArithmeticOperation.addition:
          first = AppHelpers.randomInt(1, 10);
          second = AppHelpers.randomInt(1, 10);
          break;
        case ArithmeticOperation.subtraction:
          first = AppHelpers.randomInt(5, 15);
          second = AppHelpers.randomInt(1, first);
          break;
        case ArithmeticOperation.multiplication:
          first = AppHelpers.randomInt(1, 5);
          second = AppHelpers.randomInt(1, 5);
          break;
        case ArithmeticOperation.division:
          second = AppHelpers.randomInt(1, 5);
          first = second * AppHelpers.randomInt(1, 5);
          break;
      }

      final correctAnswer = _calculateAnswer(first, second, operation);
      final options = _buildNumberOptions(
        correctAnswer,
        min: 1,
        max: correctAnswer + 12,
      );

      return ArithmeticQuestion(
        id: 'arithmetic_$index',
        firstNumber: first,
        secondNumber: second,
        operation: operation,
        options: options,
      );
    });
  }

  int _calculateAnswer(int a, int b, ArithmeticOperation op) {
    switch (op) {
      case ArithmeticOperation.addition:
        return a + b;
      case ArithmeticOperation.subtraction:
        return a - b;
      case ArithmeticOperation.multiplication:
        return a * b;
      case ArithmeticOperation.division:
        return (a / b).toInt();
    }
  }

  List<int> _buildNumberOptions(
    int correctAnswer, {
    required int min,
    required int max,
    int optionCount = 4,
  }) {
    final options = <int>{correctAnswer};
    while (options.length < optionCount) {
      options.add(AppHelpers.randomInt(min, max));
    }

    final items = options.toList()..shuffle();
    return items;
  }

  void _selectMode(MathGameMode mode) {
    if (mode == MathGameMode.counting) {
      _gameProvider.playCountingBackgroundMusic();
    } else {
      _gameProvider.playMainBackgroundMusic();
    }

    setState(() {
      if (mode == MathGameMode.numberLearning) {
        numberIdentificationQualified = false;
      }
      currentMode = mode;
      modeSelected = true;
      currentIndex = 0;
      selectedAnswer = null;
      isAnswered = false;
      lastAnswerCorrect = false;
      feedbackMessage = null;
      correctAnswers = 0;
      coinsEarned = 0;
      numberAttemptsForCurrent = 0;
    });
  }

  Future<void> _onNumberIdentificationSelected(int answer) async {
    if (isAnswered) return;

    final isCorrect = answer == numberLearnings[currentIndex].number;

    if (isCorrect) {
      await _gameProvider.playCorrectSound();
      setState(() {
        selectedAnswer = answer.toString();
        isAnswered = true;
        lastAnswerCorrect = true;
        feedbackMessage = 'Excellent. You identified the number correctly.';
        correctAnswers++;
      });
      return;
    }

    await _gameProvider.playWrongSound();

    final nextAttempt = numberAttemptsForCurrent + 1;
    final hasAttemptsLeft = nextAttempt < _maxNumberAttemptsPerQuestion;

    setState(() {
      selectedAnswer = answer.toString();
      numberAttemptsForCurrent = nextAttempt;
      lastAnswerCorrect = false;
      isAnswered = !hasAttemptsLeft;
      feedbackMessage = hasAttemptsLeft
          ? 'That is not correct. Please try again kindly.'
          : 'Nice effort. Let\'s move to the next number.';
    });
  }

  Future<void> _onAnswerSelected(String answer) async {
    if (isAnswered) return;

    final correctAnswer = arithmeticQuestions[currentIndex].getCorrectAnswer();
    final isCorrect = answer == correctAnswer.toString();

    setState(() {
      selectedAnswer = answer;
      isAnswered = true;
      lastAnswerCorrect = isCorrect;
      feedbackMessage = isCorrect
          ? 'Excellent! You solved it.'
          : 'Try again. Count carefully and choose another answer.';
    });

    await _handleAnswerOutcome(isCorrect: isCorrect);
  }

  Future<void> _onCountingAnswerSelected(int answer) async {
    if (isAnswered) return;

    final isCorrect = countingQuestions[currentIndex].isCorrect(answer);

    setState(() {
      selectedAnswer = answer.toString();
      isAnswered = true;
      lastAnswerCorrect = isCorrect;
      feedbackMessage = isCorrect
          ? 'Great counting! You got it right.'
          : 'Not quite. Try again and count each picture one by one.';
    });

    await _handleAnswerOutcome(isCorrect: isCorrect);
  }

  Future<void> _handleAnswerOutcome({required bool isCorrect}) async {
    final gameProvider = context.read<GameProvider>();
    final coinProvider = context.read<CoinProvider>();

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
    final coinProvider = context.read<CoinProvider>();
    final gameProvider = context.read<GameProvider>();

    if (currentMode == MathGameMode.numberLearning) {
      if (!isAnswered) return;

      if (lastAnswerCorrect) {
        coinsEarned += AppConstants.coinsPerCorrectAnswer;
        await coinProvider.addCoins(AppConstants.coinsPerCorrectAnswer);
      }

      currentIndex++;

      if (currentIndex >= AppConstants.totalQuestionsPerGame) {
        final passed = correctAnswers >= _numberExercisePassMark;

        if (passed) {
          numberIdentificationQualified = true;
          coinsEarned += AppConstants.coinsPerRoundCompletion;
          await coinProvider.addCoins(AppConstants.coinsPerRoundCompletion);
          await gameProvider.playCoinSound();

          if (!mounted) return;
          await showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text('Great Job'),
              content: Text(
                'You scored $correctAnswers/${AppConstants.totalQuestionsPerGame}. You can now advance to calculations.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Continue'),
                ),
              ],
            ),
          );

          _selectMode(MathGameMode.arithmetic);
        } else {
          numberIdentificationQualified = false;

          if (!mounted) return;
          await showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text('Let\'s Try Again'),
              content: Text(
                'You scored $correctAnswers/${AppConstants.totalQuestionsPerGame}. You need at least $_numberExercisePassMark to move to calculations, so let\'s redo number identification.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );

          _selectMode(MathGameMode.numberLearning);
        }
        return;
      }

      setState(() {
        selectedAnswer = null;
        isAnswered = false;
        lastAnswerCorrect = false;
        feedbackMessage = null;
        numberAttemptsForCurrent = 0;
      });
      return;
    }

    if (currentMode != MathGameMode.numberLearning &&
        (!isAnswered || !lastAnswerCorrect)) {
      return;
    }

    currentIndex++;

    if (currentIndex >= AppConstants.totalQuestionsPerGame) {
      coinsEarned += AppConstants.coinsPerRoundCompletion;
      await coinProvider.addCoins(AppConstants.coinsPerRoundCompletion);
      await gameProvider.playCoinSound();

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => RewardScreen(
              gameType: GameType.math,
              correctAnswers: correctAnswers,
              totalQuestions: AppConstants.totalQuestionsPerGame,
              coinsEarned: coinsEarned,
            ),
          ),
        );
      }
    } else {
      setState(() {
        selectedAnswer = null;
        isAnswered = false;
        lastAnswerCorrect = false;
        feedbackMessage = null;
      });
    }
  }

  Future<void> _handleModeTap(MathGameMode mode) async {
    if (mode != MathGameMode.arithmetic) {
      _selectMode(mode);
      return;
    }

    if (!numberIdentificationQualified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Complete number identification first to unlock calculations.',
          ),
        ),
      );
      return;
    }

    _selectMode(mode);
  }

  void _returnToModeSelection() {
    _gameProvider.playMainBackgroundMusic();
    setState(() {
      modeSelected = false;
      selectedAnswer = null;
      isAnswered = false;
      lastAnswerCorrect = false;
      feedbackMessage = null;
    });
  }

  void _exitMathGame() {
    _gameProvider.playMainBackgroundMusic();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _gameProvider.playMainBackgroundMusic();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!modeSelected) {
      return _buildModeSelection();
    }

    switch (currentMode) {
      case MathGameMode.numberLearning:
        return _buildNumberLearning();
      case MathGameMode.counting:
        return _buildCounting();
      case MathGameMode.arithmetic:
        return _buildArithmetic();
    }
  }

  Widget _buildModeSelection() {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: _exitMathGame,
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
              const Text(
                'Choose a Math Mode',
                style: AppConstants.headingStyle,
              ),
              const SizedBox(height: 10),
              Text(
                'Learn in different ways!',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 40),
              _buildModeCard(
                emoji: '🔢',
                title: 'Number Learning',
                description:
                    'Identify each number with 3 options and 3 chances',
                color: const Color(0xFFFF6B6B),
                onTap: () => _handleModeTap(MathGameMode.numberLearning),
              ),
              const SizedBox(height: 20),
              _buildModeCard(
                emoji: '🎯',
                title: 'Counting',
                description: 'Count objects and choose the right number',
                color: const Color(0xFF4ECDC4),
                onTap: () => _handleModeTap(MathGameMode.counting),
              ),
              const SizedBox(height: 20),
              _buildModeCard(
                emoji: numberIdentificationQualified ? '🏆' : '🔒',
                title: 'Level 2\nChallenge',
                description: numberIdentificationQualified
                    ? 'Arithmetic adventures are unlocked'
                    : 'Pass Number Learning first to unlock calculations',
                color: const Color(0xFF95E1D3),
                onTap: () => _handleModeTap(MathGameMode.arithmetic),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeCard({
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 40)),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberLearning() {
    final number = numberLearnings[currentIndex];
    final options = numberIdentificationOptions[currentIndex];

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: _returnToModeSelection,
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
              Text(
                'Question ${currentIndex + 1} of ${AppConstants.totalQuestionsPerGame}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 30),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      InteractivePictureCard(
                        assetPath: number.imagePath,
                        caption: 'Meet number ${number.number}',
                        fallbackEmoji: '🔢',
                        accentColor: const Color(0xFFFF6B6B),
                        height: 220,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Learn this Number',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        number.number.toString(),
                        style: const TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        number.word,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        AppHelpers.generateCountVisual(number.number, '⭐'),
                        style: const TextStyle(fontSize: 32),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Pick the correct number',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Attempts: $numberAttemptsForCurrent/$_maxNumberAttemptsPerQuestion',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                  child: Text(
                    feedbackMessage!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              ...options.map((option) {
                final isSelected = selectedAnswer == option.toString();
                final isCorrect = option == number.number;

                return OptionButton(
                  label: option.toString(),
                  isSelected: isSelected,
                  isCorrect: isCorrect,
                  isAnswered: isAnswered,
                  onPressed: () => _onNumberIdentificationSelected(option),
                );
              }),
              const SizedBox(height: 40),
              GameButton(
                label: currentIndex + 1 >= AppConstants.totalQuestionsPerGame
                    ? 'Finish Exercise'
                    : 'Next Number',
                onPressed: _onNextQuestion,
                height: 60,
                fontSize: 18,
                isEnabled: isAnswered,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCounting() {
    final question = countingQuestions[currentIndex];

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: _returnToModeSelection,
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
              Text(
                'Question ${currentIndex + 1} of ${AppConstants.totalQuestionsPerGame}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 30),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      InteractivePictureCard(
                        assetPath:
                            'assets/images/numbers/${question.count}.jpg',
                        caption:
                            'Count each ${question.object.toLowerCase()} and pick the right number.',
                        fallbackEmoji: question.objectEmoji,
                        accentColor: const Color(0xFF4ECDC4),
                        height: 220,
                        fit: BoxFit.contain,
                        footer: Text(
                          AppHelpers.generateCountVisual(
                            question.count,
                            question.objectEmoji,
                          ),
                          style: const TextStyle(fontSize: 32),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'How many?',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Choose the right number:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 16),
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
                  child: Text(
                    feedbackMessage!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              ...question.options.map((option) {
                final isSelected = selectedAnswer == option.toString();
                final isCorrect = option == question.count;

                return OptionButton(
                  label: option.toString(),
                  isSelected: isSelected,
                  isCorrect: isCorrect,
                  isAnswered: isAnswered,
                  onPressed: () => _onCountingAnswerSelected(option),
                );
              }),
              const SizedBox(height: 30),
              if (isAnswered && lastAnswerCorrect)
                GameButton(
                  label: currentIndex + 1 >= AppConstants.totalQuestionsPerGame
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
                  label: 'Select a number',
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

  Widget _buildArithmetic() {
    final question = arithmeticQuestions[currentIndex];
    final symbol = AppHelpers.getOperationSymbol(question.operation);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: _returnToModeSelection,
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
              Text(
                'Question ${currentIndex + 1} of ${AppConstants.totalQuestionsPerGame}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 30),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            question.firstNumber.toString(),
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            symbol,
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            question.secondNumber.toString(),
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        '= ?',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'What is the answer?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 16),
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
                  child: Text(
                    feedbackMessage!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              ...question.options.map((option) {
                final isSelected = selectedAnswer == option.toString();
                final correctAnswer = question.getCorrectAnswer();
                final isCorrect = option == correctAnswer;

                return OptionButton(
                  label: option.toString(),
                  isSelected: isSelected,
                  isCorrect: isCorrect,
                  isAnswered: isAnswered,
                  onPressed: () => _onAnswerSelected(option.toString()),
                );
              }),
              const SizedBox(height: 30),
              if (isAnswered && lastAnswerCorrect)
                GameButton(
                  label: currentIndex + 1 >= AppConstants.totalQuestionsPerGame
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
