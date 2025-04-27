import 'package:flutter/material.dart';

import 'main_menu.dart';
import 'log_dialog.dart';
import 'package:starflame/scifi_game.dart';
import 'package:starflame/styles.dart';
import 'package:starflame/hud_state.dart';

class InGameMenu extends StatelessWidget {
  const InGameMenu(this.game, {super.key});

  static const id = 'in_game_menu';
  final ScifiGame game;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.dialogBackground,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      _rowTitle('Others: '),
                      ElevatedButton(
                          onPressed: () {
                            showLogDialog(game, context);
                          },
                          style: AppTheme.menuButton,
                          child: const Text('Logs')),
                      ElevatedButton(
                          onPressed: () {
                            game.mapGrid.debugRemoveFog();
                          },
                          style: AppTheme.menuButton,
                          child: const Text('Reveal Map')),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        game.overlays.remove(id);
                      },
                      style: AppTheme.menuButton,
                      child: const Text('Continue'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        game.getIt<HudState>().deselectAll();
                        game.controller.reset();
                        game.overlays.remove(id);
                        game.overlays.add(MainMenu.id);
                      },
                      style: AppTheme.menuButton,
                      child: const Text('Main Menu'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      game.overlays.remove(id);
                      game.controller.playerEndTurn();
                    },
                    style: AppTheme.menuButton,
                    child: const Text('Next Turn')),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _rowTitle(String title) {
    return SizedBox(
      width: 160,
      child: Text(
        title,
        style: AppTheme.label12,
      ),
    );
  }
}
