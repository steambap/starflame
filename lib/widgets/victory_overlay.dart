import 'package:flutter/material.dart';

import 'main_menu.dart';
import 'package:starflame/styles.dart';
import 'package:starflame/scifi_game.dart';

class VictoryOverlay extends StatelessWidget {
  const VictoryOverlay(this.game, {super.key});

  static const id = 'victory_overlay';

  final ScifiGame game;

  @override
  Widget build(BuildContext context) {
    final playerState = game.controller.getHumanPlayerState();
    final playerName = playerState.empire.displayName;
    return Container(
      color: AppTheme.dialogBackground,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$playerName Victory!!!', style: AppTheme.heading24),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
                onPressed: () {
                  game.hudState.deselectAll();
                  game.controller.reset();
                  game.overlays.remove(id);
                  game.overlays.add(MainMenu.id);
                },
                style: AppTheme.menuButton,
                child: const Text(
                  'Main Menu',
                  style: AppTheme.label16,
                )),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: () {
                  game.overlays.remove(id);
                  game.controller.gameState.isContinue = true;
                },
                style: AppTheme.menuButton,
                child: const Text(
                  'Continue Play',
                  style: AppTheme.label16,
                )),
          ],
        ),
      ),
    );
  }
}
