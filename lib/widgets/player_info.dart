import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:starflame/styles.dart';
import 'package:starflame/scifi_game.dart';
import 'package:starflame/player_state.dart';
import 'package:starflame/data/lucide_icon.dart';
import 'package:starflame/fmt.dart';

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
            RichText(
                text: TextSpan(style: AppTheme.label12, children: [
              const WidgetSpan(
                  child: Icon(LucideIcon.circleUserRound,
                      size: 14, color: AppTheme.iconPurple)),
              const WidgetSpan(child: SizedBox(width: 4)),
              TextSpan(
                  text: formatterUnsigned.format(playerState.support)),
              TextSpan(
                  text: formatterSigned.format(income.support),
                  style: AppTheme.label12Gray),
              const WidgetSpan(child: SizedBox(width: 4)),
              const WidgetSpan(
                  child: Icon(LucideIcon.wrench,
                      size: 14, color: AppTheme.iconRed)),
              const WidgetSpan(child: SizedBox(width: 4)),
              TextSpan(
                  text: formatterUnsigned.format(playerState.production)),
              TextSpan(
                  text: formatterSigned.format(income.production),
                  style: AppTheme.label12Gray),
              const WidgetSpan(child: SizedBox(width: 4)),
              const WidgetSpan(
                  child: Icon(LucideIcon.euro,
                      size: 14, color: AppTheme.iconYellow)),
              const WidgetSpan(child: SizedBox(width: 4)),
              TextSpan(
                  text: formatterUnsigned.format(playerState.credit)),
              TextSpan(
                  text: formatterSigned.format(income.credit),
                  style: AppTheme.label12Gray),
              const WidgetSpan(child: SizedBox(width: 4)),
              const WidgetSpan(
                  child: Icon(LucideIcon.flaskRoundBottom,
                      size: 14, color: AppTheme.iconBlue)),
              const WidgetSpan(child: SizedBox(width: 4)),
              TextSpan(
                  text: formatterUnsigned.format(playerState.science)),
              TextSpan(
                  text: formatterSigned.format(income.science),
                  style: AppTheme.label12Gray),
            ])),
          ],
        ),
        // Right
        RichText(
          text: TextSpan(
            style: AppTheme.label12,
            children: [
              TextSpan(
                text: "Next Action Cost: ${playerState.nextActionCost} ",
              ),
              const WidgetSpan(
                  child: Icon(LucideIcon.circleUserRound,
                      size: 14, color: AppTheme.iconPurple)),
            ],
          ),
        ),
      ],
    );
  }
}
