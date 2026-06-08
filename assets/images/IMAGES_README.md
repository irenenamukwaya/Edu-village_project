# Image Assets Setup Guide

## Directory Structure

The images should be organized in the following structure:

```
assets/images/
├── activities/
├── objects/
├── math/
└── ui/
```

## Required Images

### Activities Images (assets/images/activities/)
These images show people performing different activities:
- sweeping.png
- reading.png
- writing.png
- sleeping.png
- eating.png
- brushing_teeth.png
- dancing.png
- washing_hands.png
- playing.png
- bathing.png

### Objects Images (assets/images/objects/)
These images show common objects:
- ball.png
- cup.png
- book.png
- cat.png
- apple.png
- chair.png
- tree.png
- shoe.png
- sun.png
- flower.png

### Math Images (assets/images/math/)
For the math game:
- number_1.png through number_20.png (optional)

### UI Images (assets/images/ui/)
- background.png (optional)
- logo.png (optional)

## Image Specifications

### Recommended Settings:
- **Format**: PNG (transparent background) or JPG
- **Resolution**: 512x512px (minimum), 1024x1024px (recommended)
- **Size**: 50-200KB per image
- **Color Space**: RGB or RGBA
- **DPI**: 72 DPI (for web) or 96 DPI (for Android)

## How to Add Images

### Option 1: Using AI Image Generators
- [OpenAI DALL-E](https://openai.com/dall-e-3)
- [Midjourney](https://midjourney.com)
- [Stable Diffusion](https://huggingface.co/spaces/stabilityai/stable-diffusion)

### Option 2: Using Free Image Resources
- [Unsplash](https://unsplash.com)
- [Pexels](https://www.pexels.com)
- [Pixabay](https://pixabay.com)
- [FreePik](https://www.freepik.com)
- [Flaticon](https://www.flaticon.com)

### Option 3: Create Custom Images
- Use Canva
- Use Figma
- Draw with Procreate (iPad)
- Use Adobe Creative Suite

## Tips for Kids Learning App

1. **Use bright, cheerful colors** - Kids are attracted to vibrant colors
2. **Simple, clear designs** - Avoid complex details
3. **Cartoon style** - Preferred for children's apps
4. **High contrast** - Makes images easier to see
5. **Large, recognizable subjects** - Clear and obvious what the object/activity is
6. **Safe for children** - Avoid scary or violent imagery

## Image Compression

To optimize images for mobile:

### Using ImageOptim (macOS):
1. Download ImageOptim
2. Drag and drop images to compress
3. Replace original files

### Using TinyPNG:
1. Go to https://tinypng.com
2. Upload images
3. Download compressed versions

### Using Command Line (ImageMagick):
```bash
mogrify -quality 85 -strip *.png
```

## Notes

- Images are optional - the app uses placeholder icons if images are missing
- Update `pubspec.yaml` if adding new image directories
- Run `flutter clean` after adding new images
- Use appropriate naming conventions (lowercase, no spaces)

## After Adding Images

1. Place images in the appropriate `assets/images/` subdirectories
2. Run `flutter pub get`
3. Run `flutter clean`
4. Run `flutter run` to test

The app is fully functional with or without images - they enhance the user experience but aren't required.
