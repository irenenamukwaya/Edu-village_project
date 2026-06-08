# EduVillage - Educational Kids Learning Game

A comprehensive, production-ready Flutter mobile application designed to teach children aged 4-8 through engaging mini-games. The app features activity recognition, object identification, word pronunciation, and math learning with a reward-based coin system.

## 📱 Features

### 1. **Activity Recognition Game** 🎬
- Display images of daily activities
- Choose correct activity name from 4 options
- Examples: sweeping, reading, writing, sleeping, eating

### 2. **Object Recognition Game** 🎯
- Identify common objects through images
- Multiple choice selection
- Examples: ball, cup, book, cat, apple, tree

### 3. **Word Pronunciation Game** 🔊
- Learn new vocabulary words
- Text-to-speech pronunciation
- Example sentences using the word
- Interactive speaker button

### 4. **Math and Counting Game** 🧮
- **Mode 1**: Number Learning (Numbers 1-20)
- **Mode 2**: Counting (Count objects and select number)
- **Mode 3**: Arithmetic (Addition, Subtraction, Multiplication, Division)

### 5. **Coin Reward System** 💰
- Earn 5 coins per correct answer
- Earn 20 bonus coins per completed round
- Persistent storage using SharedPreferences
- Display coin balance on all screens

## 🏗️ Project Architecture

```
lib/
├── main.dart                    # App entry point
├── app/
│   ├── app.dart                 # Main app widget
│   ├── routes.dart              # Route configuration
│   └── theme.dart               # Theme and styling
├── screens/
│   ├── splash/
│   │   └── splash_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   ├── activity_game/
│   │   └── activity_game_screen.dart
│   ├── object_game/
│   │   └── object_game_screen.dart
│   ├── word_game/
│   │   └── word_game_screen.dart
│   ├── math_game/
│   │   └── math_game_screen.dart
│   └── reward/
│       └── reward_screen.dart
├── models/
│   ├── activity_model.dart
│   ├── object_model.dart
│   ├── word_model.dart
│   └── math_model.dart
├── services/
│   ├── coin_service.dart
│   ├── audio_service.dart
│   ├── tts_service.dart
│   └── question_service.dart
├── providers/
│   ├── coin_provider.dart
│   └── game_provider.dart
├── widgets/
│   ├── game_button.dart
│   ├── option_button.dart
│   ├── coin_display.dart
│   └── question_card.dart
├── utils/
│   ├── constants.dart
│   └── helpers.dart
└── assets/
    ├── data/
    │   ├── activities.json
    │   ├── objects.json
    │   └── words.json
    ├── images/
    └── sounds/
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (version 3.10.7 or higher)
- Dart SDK (included with Flutter)
- Android Studio or Xcode for mobile testing
- A mobile device or emulator

### Installation

1. **Clone or extract the project**
```bash
cd eduvillage
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

### For iOS (macOS)
```bash
cd ios
pod install
cd ..
flutter run
```

## 📦 Dependencies

```yaml
dependencies:
  flutter_tts: ^0.15.0           # Text-to-Speech
  audioplayers: ^5.2.0           # Audio playback
  shared_preferences: ^2.2.2     # Local data persistence
  provider: ^6.1.0               # State management
  google_fonts: ^6.1.0           # Custom fonts
```

## 🎮 How to Use

### Home Screen
- View coin balance
- Select a game to play
- Each game button shows description

### Playing a Game

1. **Activity/Object Games**
   - Read the question
   - View the image
   - Tap the correct answer
   - Get instant feedback
   - Earn coins for correct answers

2. **Word Pronunciation Game**
   - Read the word
   - Tap speaker button to hear pronunciation
   - Listen to example sentence
   - Learn through audio feedback

3. **Math Game**
   - Choose a learning mode
   - Answer questions
   - See results with accuracy percentage
   - Earn coins for completion

### Rewards Screen
- View game results
- See accuracy percentage
- Check coins earned
- Option to play again or return home

## 🎨 UI/UX Features

### Child-Friendly Design
- ✨ Bright, vibrant colors
- 🎨 Colorful gradient backgrounds
- 🔘 Large, easy-to-tap buttons
- 📱 Simple, uncluttered layouts
- ✅ Clear visual feedback

### Accessibility
- Large font sizes
- High contrast colors
- Simple iconography
- Minimal text
- Intuitive navigation

## 📊 Game Data

### Question Format
All game questions are stored in JSON files (`assets/data/`):

**Activities**
```json
{
  "id": "1",
  "image": "assets/images/activities/sweeping.png",
  "answer": "Sweeping",
  "options": ["Playing", "Sweeping", "Sleeping", "Eating"],
  "description": "A person is sweeping the floor"
}
```

**Objects**
```json
{
  "id": "1",
  "image": "assets/images/objects/ball.png",
  "answer": "Ball",
  "options": ["Ball", "Cup", "Dog", "Book"],
  "pronunciation": "Ball"
}
```

**Words**
```json
{
  "id": "1",
  "word": "Ball",
  "pronunciation": "Ball",
  "sentence": "The ball is round and fun to play with.",
  "sentencePronunciation": "The ball is round and fun to play with",
  "image": "assets/images/objects/ball.png"
}
```

## 🔧 Adding Custom Content

### Adding New Activities
1. Edit `assets/data/activities.json`
2. Add new entry with image, answer, and options
3. Add corresponding image to `assets/images/activities/`
4. Restart app

### Adding New Objects
1. Edit `assets/data/objects.json`
2. Add object definition
3. Add image to `assets/images/objects/`
4. Restart app

### Customizing Game Settings
Edit `lib/utils/constants.dart`:
```dart
static const int coinsPerCorrectAnswer = 5;      // Coins per correct answer
static const int coinsPerRoundCompletion = 20;   // Coins per round
static const int totalQuestionsPerGame = 10;     // Questions per game
```

## 🔊 Setting Up Sound Effects

The app expects three sound files in `assets/sounds/`:
- `correct.mp3` - Played on correct answer
- `wrong.mp3` - Played on wrong answer
- `coin.mp3` - Played when earning coins

See `assets/sounds/SOUNDS_README.md` for detailed instructions.

## 🖼️ Setting Up Images

Place images in their respective folders:
- `assets/images/activities/` - Activity images
- `assets/images/objects/` - Object images
- `assets/images/math/` - Math game images (optional)

See `assets/images/IMAGES_README.md` for detailed requirements.

## 🔐 Data Persistence

### Coin Balance
- Stored locally using `shared_preferences`
- Persists across app sessions
- Initial balance: 100 coins

### Game Progress
- Not stored (games reset on each play)
- Statistics can be added by extending the code

## 🧪 Testing

### Run Tests
```bash
flutter test
```

### Test on Device
```bash
# Android
flutter run -d <device-id>

# iOS
flutter run -d <device-id>
```

### Build APK (Android)
```bash
flutter build apk --release
flutter build apk --split-per-abi
```

### Build iOS App
```bash
flutter build ios --release
```

## 📱 Supported Platforms

- ✅ Android (API 21+)
- ✅ iOS (11.0+)
- ✅ Web (optional)
- ✅ Linux, macOS, Windows (with additional setup)

## 🐛 Troubleshooting

### Sound not playing
- Check if sound files are in `assets/sounds/`
- Verify device volume is not muted
- Check `assets/sounds/SOUNDS_README.md`

### Images not showing
- Ensure images are in correct directories
- Run `flutter clean` and `flutter pub get`
- Check spelling of image paths

### TTS not working
- iOS: Requires physical device for TTS
- Android: May need language pack installed
- Web: Browser must support Web Speech API

### Coins not saving
- Verify `shared_preferences` permission
- Check app storage permissions
- Clear app cache/data and restart

## 📈 Future Enhancements

- [ ] User profiles and progress tracking
- [ ] Leaderboard system
- [ ] More games and question sets
- [ ] Multiplayer mode
- [ ] Certificates/achievements
- [ ] Parent dashboard
- [ ] Offline mode
- [ ] Multiple languages

## 📄 License

This project is provided as-is for educational purposes.

## 👨‍💼 Developer Information

**Project**: EduVillage Educational Game
**Version**: 1.0.0
**Flutter Version**: 3.10.7+
**Dart Version**: Compatible with Flutter 3.10.7+

## 📞 Support

For issues or questions:
1. Check the README files in `assets/` directories
2. Review the code comments
3. Check Flutter documentation
4. Verify all dependencies are correctly installed

## 🎓 Educational Value

EduVillage is designed to:
- ✅ Improve vocabulary for 4-8 year olds
- ✅ Teach activity and object recognition
- ✅ Introduce basic phonetics and pronunciation
- ✅ Teach counting and basic arithmetic
- ✅ Encourage learning through positive reinforcement
- ✅ Build confidence through rewarding system
- ✅ Develop cognitive and motor skills

---

**Ready to learn? Let's play! 🎉**
