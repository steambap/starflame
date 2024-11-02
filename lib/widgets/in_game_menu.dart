import 'package:flutter/material.dart';

import 'main_menu.dart';
import 'log_dialog.dart';
import '../scifi_game.dart';
import '../styles.dart';
import '../research_overlay.dart';

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
                    children: [
                      _rowTitle('Admin: '),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          game.overlays.remove(id);
                          game.router.pushRoute(ResearchOverlay());
                        },
                        style: AppTheme.menuButton,
                        child: const Text('Research'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _rowTitle('Military: '),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _rowTitle('Others: '),
                      const SizedBox(height: 8),
                      ElevatedButton(
                          onPressed: () {
                            showLogDialog(game, context);
                          },
                          style: AppTheme.menuButton,
                          child: const Text('Logs'))
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
                        game.hudState.deselectAll();
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
