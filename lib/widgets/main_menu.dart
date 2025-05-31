import 'package:flutter/material.dart';

import 'player_info.dart';
import 'ship_cmd.dart';
import 'hud_top_left.dart';
import 'hud_bottom_right.dart';
import 'sector_info.dart';
import 'package:starflame/scifi_game.dart';
import 'package:starflame/styles.dart';

class MainMenu extends StatelessWidget {
  const MainMenu(this.game, {super.key});

  static const id = 'main_menu';
  static const initialOverlays = [
    HudTopLeft.id,
    HudBottomRight.id,
    ShipCmd.id,
    SectorInfo.id,
    PlayerInfoBar.id
  ];

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
                        game.overlays.addAll(initialOverlays);
                        game.startTestGame();
                      },
                      style: AppTheme.menuButton,
                      child: const Text(
                        'New Game',
                        style: AppTheme.label16,
                      )),
                  ElevatedButton(
                      onPressed: () {
                        _licenseDialog(context);
                      },
                      style: AppTheme.menuButton,
                      child: const Text(
                        'License',
                        style: AppTheme.label16,
                      )),
                ],
              ),
            )),
      ),
    );
  }

  Future<void> _licenseDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'License',
            style: AppTheme.heading24,
          ),
          shape: const RoundedRectangleBorder(),
          scrollable: true,
          content: const Text(
            """
Flame

MIT License

Copyright (c) 2021 Blue Fire

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
          """,
            style: AppTheme.label12,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text(
                'OK',
                style: AppTheme.label16,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
