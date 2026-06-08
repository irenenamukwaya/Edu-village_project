# EduVillage - Quick Start Guide

## ⚡ Get Started in 3 Steps

### Step 1: Install Dependencies
```bash
cd eduvillage
flutter pub get
```

### Step 2: Run the App
```bash
flutter run
```

### Step 3: Play and Learn!
The app will launch with the splash screen and navigation to the home screen.

---

## 🎮 What You'll See

1. **Splash Screen** - EduVillage logo with animation
2. **Home Screen** - 4 game options
3. **Game Screens** - Educational mini-games
4. **Reward Screen** - Results and coins earned

---

## 💰 Coin System

- Start with: **100 coins**
- Per correct answer: **+5 coins**
- Per completed round: **+20 coins**
- Coins are **saved permanently** on your device

---

## 🎯 The 4 Games

### 1. Activity Recognition 🎬
**Guess what people are doing**
- Sweeping, reading, writing, sleeping, eating...
- 10 questions per round
- See images and choose the right activity

### 2. Object Recognition 🎯
**Identify common objects**
- Ball, cup, book, cat, apple, tree...
- 10 questions per round
- Multiple choice selection

### 3. Word Pronunciation 🔊
**Learn to say new words**
- Ball, cat, apple, sun, flower...
- Press speaker button to hear
- Listen to example sentences
- All 10 words = automatic completion

### 4. Math & Counting 🧮
**Choose your learning mode:**
- **Number Learning**: Learn numbers 1-20
- **Counting**: Count objects and select number
- **Arithmetic**: Addition, subtraction, multiplication, division

---

## 🖼️ Adding Images (Optional)

### Activities Images
Place in `assets/images/activities/`:
- sweeping.png, reading.png, writing.png, eating.png, sleeping.png
- bathing.png, dancing.png, playing.png, brushing_teeth.png,washing_hands.png

### Objects Images
Place in `assets/images/objects/`:
- ball.png, cup.png, book.png, cat.png, apple.png
- chair.png, tree.png, shoe.png, sun.png, flower.png

### Getting Images
1. **Free sites**: Unsplash, Pexels, Pixabay, FreePik
2. **AI Tools**: DALL-E, Midjourney, Stable Diffusion
3. **Design Tools**: Canva, Figma

---

## 🔊 Adding Sounds (Optional)

Place in `assets/sounds/`:
- **correct.mp3** - Success sound
- **wrong.mp3** - Error sound
- **coin.mp3** - Coin sound

### Getting Sounds
1. **Free sites**: Freesound.org, Zapsplat, Pixabay Sounds
2. **Conversion**: Use FFmpeg to convert to MP3

---

## 🔧 Troubleshooting

### App won't run
```bash
flutter clean
flutter pub get
flutter run
```

### Can't see images
- Images are optional (gray placeholders appear otherwise)
- Check folder paths are correct
- Run `flutter clean` after adding images

### TTS not working
- iOS: Use physical device (TTS doesn't work on simulator)
- Android: Should work on most devices
- Check device settings > accessibility > TTS

### Sounds not playing
- Sounds are optional
- Check device volume is not muted
- Verify files are in `assets/sounds/`

---

## 📊 Game Stats

| Game | Questions | Time | Coins |
|------|-----------|------|-------|
| Activity | 10 | ~3-5 min | 70 |
| Objects | 10 | ~3-5 min | 70 |
| Words | 10 | ~5-7 min | 70 |
| Math | 10 | ~4-6 min | 70 |

---

## 🎓 Age Recommendation

**4-8 years old**
- Simple questions
- Visual learning
- Audio feedback
- Rewarding system

---

## 💡 Tips for Parents

✅ **Do:**
- Let child take their time
- Celebrate correct answers
- Use as supplement to real learning
- Play together and discuss

❌ **Don't:**
- Force children to play
- Use as punishment
- Let play unsupervised for hours
- Focus only on coins

---

## 🚀 Advanced Features

### Customize Settings
Edit `lib/utils/constants.dart`:
```dart
// Change coin rewards
static const int coinsPerCorrectAnswer = 5;
static const int coinsPerRoundCompletion = 20;

// Change colors
static const Color primaryColor = Color(0xFF6C63FF);

// Change questions per game
static const int totalQuestionsPerGame = 10;
```

### Add New Questions
Edit JSON files in `assets/data/`:
- `activities.json` - Activity game questions
- `objects.json` - Object game questions
- `words.json` - Word game lessons

---

## 📱 Device Requirements

### Android
- Minimum Android 5.0 (API 21)
- 100 MB free storage
- RAM: 2GB+ (recommended)

### iOS
- Minimum iOS 11.0
- 100 MB free storage
- RAM: 2GB+ (recommended)

---

## 🌐 Offline App

✅ **No internet required**
✅ **No ads**
✅ **No tracking**
✅ **No personal data collected**
✅ **100% private**

---

## 📈 Build for Release

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

---

## 📚 Full Documentation

For detailed information, see:
- `README_EDUVILLAGE.md` - Complete guide
- `IMPLEMENTATION_SUMMARY.md` - Development details
- `assets/sounds/SOUNDS_README.md` - Sound setup
- `assets/images/IMAGES_README.md` - Image setup

---

## ✨ Key Features Summary

✅ 4 educational mini-games
✅ Play offline, no internet needed
✅ Persistent coin rewards
✅ Text-to-speech pronunciation
✅ Sound effects
✅ Colorful, child-friendly UI
✅ 40+ built-in questions
✅ Progress tracking
✅ Instant feedback
✅ 100% safe for children

---

## 🎯 Next Steps

1. ✅ Run the app with `flutter run`
2. ✅ Test all 4 games
3. ✅ Add images if desired
4. ✅ Add sounds if desired
5. ✅ Customize colors and rewards
6. ✅ Build APK for Android or IPA for iOS
7. ✅ Submit to Play Store or App Store

---

## 🎉 Enjoy!

**EduVillage is ready to inspire young learners!**

For questions or issues, refer to the detailed documentation files.

Happy Learning! 🚀📚✨
