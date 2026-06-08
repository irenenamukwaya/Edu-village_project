# Sound Files Setup Guide

## Required Sound Files

The following sound effects are used in the EduVillage application. These files should be placed in the `assets/sounds/` directory.

### Sound Files to Add:

1. **correct.mp3** - Played when the user answers correctly
   - Recommended: Cheerful, positive sound (650ms - 1.5s duration)
   - Format: MP3
   
2. **wrong.mp3** - Played when the user answers incorrectly
   - Recommended: Gentle error sound (500ms - 1.2s duration)
   - Format: MP3
   
3. **coin.mp3** - Played when coins are earned
   - Recommended: Coin/bell chime sound (300ms - 800ms duration)
   - Format: MP3

## How to Add Sound Files

### Option 1: Using Free Online Resources
Download sound effects from:
- [Freesound.org](https://freesound.org)
- [Zapsplat](https://www.zapsplat.com)
- [Pixabay Sounds](https://pixabay.com/sounds)
- [Pexels Sounds](https://www.pexels.com/sound)

### Option 2: Using FFmpeg to Convert

If you have audio files in other formats, convert them to MP3:
```bash
ffmpeg -i input_audio.wav -codec:a libmp3lame -q:a 4 correct.mp3
```

### Option 3: Create Simple Sounds

You can use tools like:
- Audacity (free, open-source)
- Online tone generators
- GarageBand (macOS)

## Notes

- The app will continue to run without sound files (sounds will simply not play)
- All sounds are optional and the game is fully playable without them
- The app uses the `audioplayers` package for audio playback
- Maximum recommended file size: 500KB per sound file

## After Adding Files

1. Place the `.mp3` files in the `assets/sounds/` directory
2. The `pubspec.yaml` already includes the assets configuration
3. Run `flutter pub get` to update dependencies
4. Sound effects will automatically play during gameplay
