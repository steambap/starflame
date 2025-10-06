import 'package:flutter/material.dart';

import 'package:starflame/scifi_game.dart';
import 'package:starflame/styles.dart';

class MainMenu extends StatelessWidget {
  const MainMenu(this.game, {super.key});

  static const id = 'main_menu';
  static const List<String> initialOverlays = [id];

  final ScifiGame game;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.dialogBackground,
      child: Center(
        child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  const Text('Starflame', style: AppTheme.heading24),
                  const SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: () {
                        game.overlays.remove(id);
                        game.startTestGame();
                      },
                      style: AppTheme.menuButton,
                      child: const Text(
                        'New Game',
                        style: AppTheme.label16,
                      )),
                  ElevatedButton(
                      onPressed: () {
                        _aboutDialog(context);
                      },
                      style: AppTheme.menuButton,
                      child: const Text(
                        'About',
                        style: AppTheme.label16,
                      )),
                ],
              ),
            )),
      ),
    );
  }

  void _aboutDialog(BuildContext context) {
    return showAboutDialog(
        context: context,
        applicationName: 'Starflame',
        applicationVersion: '0.0.1',
        applicationLegalese: '\u{a9} 2024 - present Weilin Shi',
        children: [
          const SizedBox(height: 24),
          RichText(
              text: const TextSpan(
            children: <TextSpan>[
              TextSpan(
                text:
                    "Starflame is a space strategy game built with Flutter and Flame. "
                    "\n",
              ),
              TextSpan(
                style: AppTheme.label14Gray,
                text: 'https://github.com/steambap/starflame',
              ),
            ],
          ))
        ]);
  }
}
