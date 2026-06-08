import 'package:flutter/material.dart';

/// Static picture card for showing learning assets.
class InteractivePictureCard extends StatelessWidget {
  final String? assetPath;
  final String caption;
  final String fallbackEmoji;
  final Color accentColor;
  final double height;
  final BoxFit fit;
  final Widget? footer;

  const InteractivePictureCard({
    Key? key,
    required this.caption,
    this.assetPath,
    this.fallbackEmoji = '✨',
    this.accentColor = const Color(0xFF6C63FF),
    this.height = 220,
    this.fit = BoxFit.cover,
    this.footer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [accentColor.withOpacity(0.16), Colors.white],
        ),
        border: Border.all(color: accentColor.withOpacity(0.25), width: 2),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.18),
            blurRadius: 24,
            spreadRadius: 3,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, accentColor.withOpacity(0.12)],
                ),
              ),
              child: assetPath == null
                  ? _FallbackPicture(emoji: fallbackEmoji)
                  : Image.asset(
                      assetPath!,
                      fit: fit,
                      errorBuilder: (context, error, stackTrace) =>
                          _FallbackPicture(emoji: fallbackEmoji),
                    ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      caption,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  if (footer != null) ...[const SizedBox(height: 10), footer!],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FallbackPicture extends StatelessWidget {
  final String emoji;

  const _FallbackPicture({required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(emoji, style: const TextStyle(fontSize: 96)));
  }
}
