import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eduvillage/providers/game_provider.dart';

// Opens the music and volume settings panel.
class MusicSettingsButton extends StatelessWidget {
  const MusicSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings, color: Colors.black87),
      tooltip: 'Music settings',
      onPressed: () => _openMusicSettings(context),
    );
  }

  Future<void> _openMusicSettings(BuildContext context) async {
    final gameProvider = context.read<GameProvider>();
    double localVolume = gameProvider.musicVolume;
    bool localMuted = gameProvider.isMusicMuted;

    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Music Settings',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'These controls only affect background music. Word pronunciation stays available.',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Mute background music'),
                    value: localMuted,
                    onChanged: (value) {
                      setModalState(() => localMuted = value);
                      gameProvider.setMusicMuted(value);
                    },
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Music volume: ${(localVolume * 100).round()}%',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Slider(
                    value: localVolume,
                    min: 0,
                    max: 1,
                    divisions: 20,
                    onChanged: (value) {
                      setModalState(() {
                        localVolume = value;
                        if (value > 0 && localMuted) {
                          localMuted = false;
                        }
                      });
                      gameProvider.setMusicVolume(value);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
