import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eduvillage/models/word_model.dart';
import 'package:eduvillage/services/question_service.dart';
import 'package:eduvillage/providers/game_provider.dart';
import 'package:eduvillage/providers/coin_provider.dart';
import 'package:eduvillage/widgets/game_button.dart';
import 'package:eduvillage/widgets/coin_display.dart';
import 'package:eduvillage/widgets/music_settings_button.dart';
import 'package:eduvillage/utils/constants.dart';
import 'package:eduvillage/screens/reward/reward_screen.dart';

/// Word Pronunciation Game Screen
class WordGameScreen extends StatefulWidget {
  const WordGameScreen({Key? key}) : super(key: key);

  @override
  State<WordGameScreen> createState() => _WordGameScreenState();
}

class _WordGameScreenState extends State<WordGameScreen> {
  late GameProvider _gameProvider;
  late List<WordQuestion> questions = [];
  bool isLoading = true;
  bool isSpeaking = false;
  int currentIndex = 0;
  bool wordPronounced = false;
  bool sentencePronounced = false;

  @override
  void initState() {
    super.initState();
    _gameProvider = context.read<GameProvider>();
    _gameProvider.stopBackgroundMusic();
    _loadQuestions();
  }

  void _exitWordGame() {
    _gameProvider.playMainBackgroundMusic();
    Navigator.pop(context);
  }

  Future<void> _loadQuestions() async {
    final allQuestions = await QuestionService.loadWordQuestions();
    final gameQuestions = QuestionService.getRandomQuestions(
      allQuestions,
      AppConstants.totalQuestionsPerGame,
    );

    setState(() {
      questions = gameQuestions;
      isLoading = false;
    });

    if (mounted) {
      _gameProvider.startGame();
    }
  }

  Future<void> _pronounceWord() async {
    setState(() => isSpeaking = true);

    await _gameProvider.speak(questions[currentIndex].word);

    setState(() {
      isSpeaking = false;
      wordPronounced = true;
    });
  }

  Future<void> _pronounceSentence() async {
    setState(() => isSpeaking = true);

    await _gameProvider.speak(questions[currentIndex].sentence);

    setState(() {
      isSpeaking = false;
      sentencePronounced = true;
    });
  }

  Future<void> _onNext() async {
    final coinProvider = context.read<CoinProvider>();

    // Award coins for listening and learning
    await coinProvider.addCoins(AppConstants.coinsPerCorrectAnswer);
    await _gameProvider.playCoinSound();

    currentIndex++;

    if (currentIndex >= AppConstants.totalQuestionsPerGame) {
      await coinProvider.addCoins(AppConstants.coinsPerRoundCompletion);

      final totalCoins =
          AppConstants.coinsPerCorrectAnswer *
              AppConstants.totalQuestionsPerGame +
          AppConstants.coinsPerRoundCompletion;

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => RewardScreen(
              gameType: GameType.word,
              correctAnswers: AppConstants.totalQuestionsPerGame,
              totalQuestions: AppConstants.totalQuestionsPerGame,
              coinsEarned: totalCoins,
            ),
          ),
        );
      }
    } else {
      setState(() {
        wordPronounced = false;
        sentencePronounced = false;
      });
    }
  }

  @override
  void dispose() {
    _gameProvider.stopSpeaking();
    _gameProvider.playMainBackgroundMusic();
    super.dispose();
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
          onPressed: _exitWordGame,
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
              // Progress
              Center(
                child: Text(
                  'Question ${currentIndex + 1} of ${AppConstants.totalQuestionsPerGame}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Word Card
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
                      // Word
                      Text(
                        currentQuestion.word,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),

                      // Pronounce Word Button
                      GameButton(
                        label: isSpeaking ? 'Speaking...' : '🔊 Hear the Word',
                        onPressed: _pronounceWord,
                        backgroundColor: AppConstants.primaryColor,
                        height: 60,
                        fontSize: 16,
                        isEnabled: !isSpeaking,
                      ),

                      if (wordPronounced) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppConstants.successColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppConstants.successColor.withOpacity(0.3),
                            ),
                          ),
                          child: const Text(
                            '✓ Great! You heard the word!',
                            style: TextStyle(
                              color: AppConstants.successColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Sentence Card
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        'Example Sentence',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        currentQuestion.sentence,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      // Pronounce Sentence Button
                      GameButton(
                        label: isSpeaking ? 'Speaking...' : '🔊 Hear Sentence',
                        onPressed: _pronounceSentence,
                        backgroundColor: const Color(0xFF4ECDC4),
                        height: 55,
                        fontSize: 16,
                        isEnabled: !isSpeaking,
                      ),

                      if (sentencePronounced) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppConstants.successColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppConstants.successColor.withOpacity(0.3),
                            ),
                          ),
                          child: const Text(
                            '✓ Great! You heard the sentence!',
                            style: TextStyle(
                              color: AppConstants.successColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Next Button
              if (wordPronounced && sentencePronounced)
                GameButton(
                  label: currentIndex + 1 >= AppConstants.totalQuestionsPerGame
                      ? 'See Results'
                      : 'Next Word',
                  onPressed: _onNext,
                  height: 60,
                  fontSize: 18,
                )
              else
                GameButton(
                  label: 'Listen to both',
                  onPressed: () {},
                  height: 60,
                  fontSize: 18,
                  isEnabled: false,
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
