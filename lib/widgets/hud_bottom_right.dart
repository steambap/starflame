import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:starflame/styles.dart';
import 'package:starflame/scifi_game.dart';

class HudBottomRight extends StatelessWidget {
  const HudBottomRight(this.game, {super.key});

  static const id = 'hud_bottom_right';

  final ScifiGame game;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Align(
        alignment: .bottomRight,
        child: Row(
          mainAxisAlignment: .end,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                if (game.watchMode) {
                  return;
                }
                game.cycle.endTurn();
              },
              style: AppTheme.primaryButton,
              icon: const Icon(Symbols.hourglass_bottom_rounded),
              label: const Text('Next Turn'),
            ),
          ],
        ),
      ),
    );
  }
}
