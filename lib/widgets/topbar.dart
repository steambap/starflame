import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:watch_it/watch_it.dart';

import 'main_menu.dart';

import 'package:starflame/scifi_game.dart';
import 'package:starflame/styles.dart';
import 'package:starflame/fmt.dart';
import 'package:starflame/hud_state.dart';

class Topbar extends StatelessWidget with WatchItMixin {
  const Topbar(this.game, {super.key});

  static const id = 'topbar';

  final ScifiGame game;

  @override
  Widget build(BuildContext context) {
    watchValue((HudState hudState) => hudState.playerInfoVersion);
    final playerState = game.g.players[game.g.humanPlayerIdx];
    final income = game.cycle.playerIncome(game.g.humanPlayerIdx);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () {
              game.overlays.remove(id);
              game.overlays.addAll([MainMenu.id]);
            },
            label: const Text('Back', style: AppTheme.label16),
            icon: const Icon(
              Symbols.arrow_back_ios_new_rounded,
              color: AppTheme.iconPale,
            ),
          ),
          RichText(
            text: TextSpan(
              style: AppTheme.label14,
              children: [
                const WidgetSpan(
                  alignment: .middle,
                  child: Icon(
                    Symbols.deployed_code_rounded,
                    size: 14,
                    color: AppTheme.iconBlue,
                  ),
                ),
                const WidgetSpan(child: SizedBox(width: 4)),
                TextSpan(text: formatterUnsigned.format(playerState.resources)),
                const WidgetSpan(child: SizedBox(width: 2)),
                TextSpan(
                  text: formatterSigned.format(income),
                  style: AppTheme.label14Gray,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
