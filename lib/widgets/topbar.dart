import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'main_menu.dart';

import 'package:starflame/scifi_game.dart';
import 'package:starflame/styles.dart';

class Topbar extends StatelessWidget {
  const Topbar(this.game, {super.key});

  static const id = 'topbar';

  final ScifiGame game;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
              onPressed: () {
                game.overlays.remove(id);
                game.overlays.addAll([MainMenu.id]);
              },
              label: const Text('Back', style: AppTheme.label16),
              icon: const Icon(Symbols.arrow_back_ios_new_rounded,
                  color: AppTheme.iconPale)),
          TextButton.icon(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: const Text('Select a playspeed',
                            style: AppTheme.label16Gray),
                        children: [
                          SimpleDialogOption(
                            onPressed: () {
                              game.timeScale = 2;
                              Navigator.of(context).pop();
                            },
                            child: const Text('2x', style: AppTheme.label16),
                          ),
                          SimpleDialogOption(
                            onPressed: () {
                              game.timeScale = 1;
                              Navigator.of(context).pop();
                            },
                            child: const Text('1x (default)', style: AppTheme.label16),
                          ),
                          SimpleDialogOption(
                            onPressed: () {
                              game.timeScale = 0;
                              Navigator.of(context).pop();
                            },
                            child: const Text('Pause', style: AppTheme.label16),
                          ),
                        ],
                      );
                    });
              },
              label: const Text('Playspeed', style: AppTheme.label16),
              icon:
                  const Icon(Symbols.speed_rounded, color: AppTheme.iconPale)),
        ],
      ),
    );
  }
}
