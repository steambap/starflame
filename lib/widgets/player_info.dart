import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:starflame/styles.dart';
import 'package:starflame/scifi_game.dart';
import 'package:starflame/player_state.dart';

class PlayerInfoBar extends StatelessWidget {
  const PlayerInfoBar(this.game, {super.key});

  static const id = 'player_info_bar';

  final ScifiGame game;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PlayerState>.value(
      value: game.controller.getHumanPlayerState(),
      child: Container(
        height: AppTheme.navbarHeight,
        decoration: const BoxDecoration(
            color: AppTheme.panelBackground,
            border: Border(bottom: BorderSide(color: AppTheme.panelBorder))),
        child: Consumer<PlayerState>(
          builder: (context, value, child) => _bar(),
        ),
      ),
    );
  }

  Widget _bar() {
    final playerState = game.controller.getHumanPlayerState();
    final income = game.resourceController.humanPlayerIncome();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left
        Row(
          children: [
            const SizedBox(width: 4),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: playerState.color,
                border: Border.all(
                  color: AppTheme.panelBorder,
                  width: 1,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              "\ue467",
              style: AppTheme.icon16purple,
            ),
            const SizedBox(width: 4),
            Text(
              "${playerState.support}",
              style: AppTheme.label12,
            ),
            Text(
              "+${income.support}",
              style: AppTheme.label12Gray,
            ),
            const SizedBox(width: 4),
            const Text(
              "\ue1b1",
              style: AppTheme.icon16red,
            ),
            const SizedBox(width: 4),
            Text(
              "${playerState.production}",
              style: AppTheme.label12,
            ),
            Text(
              "+${income.production}",
              style: AppTheme.label12Gray,
            ),
            const SizedBox(width: 4),
            const Text(
              "\ue0bc",
              style: AppTheme.icon16yellow,
            ),
            const SizedBox(width: 4),
            Text(
              "${playerState.credit}",
              style: AppTheme.label12,
            ),
            Text(
              "+${income.credit}",
              style: AppTheme.label12Gray,
            ),
            const SizedBox(width: 4),
            const Text(
              "\ue0db",
              style: AppTheme.icon16blue,
            ),
            const SizedBox(width: 4),
            Text(
              "${playerState.science}",
              style: AppTheme.label12,
            ),
            Text(
              "+${income.science}",
              style: AppTheme.label12Gray,
            ),
          ],
        ),
        // Right
        Row(
          children: [
            Text(
              "Next Action Cost: ${playerState.nextActionCost}",
              style: AppTheme.label12,
            ),
            const SizedBox(width: 4),
            const Text(
              "\ue467",
              style: AppTheme.icon16purple,
            ),
            const SizedBox(width: 4),
          ],
        ),
      ],
    );
  }
}
