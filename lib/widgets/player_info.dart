import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:starflame/styles.dart';
import 'package:starflame/scifi_game.dart';
import 'package:starflame/player_state.dart';
import 'package:starflame/fmt.dart';

class PlayerInfoBar extends StatelessWidget with WatchItMixin {
  const PlayerInfoBar(this.game, {super.key});

  static const id = 'player_info_bar';

  final ScifiGame game;

  @override
  Widget build(BuildContext context) {
    final playerState =
        watch<PlayerState>(game.controller.getHumanPlayerState());

    return Align(
      alignment: Alignment.topRight,
      child: _bar(playerState),
    );
  }

  Widget _bar(PlayerState playerState) {
    final income = game.resourceController.humanPlayerIncome();

    return Container(
      transform: Matrix4.translationValues(1, -1, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: const ShapeDecoration(
        color: AppTheme.panelBackground,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12)),
          side: BorderSide(color: AppTheme.panelBorder),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          RichText(
              text: TextSpan(style: AppTheme.label14, children: [
            const WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Icon(Symbols.bolt_rounded,
                    size: 14, color: AppTheme.iconYellow)),
            const WidgetSpan(child: SizedBox(width: 4)),
            TextSpan(text: formatterUnsigned.format(playerState.energy)),
            const WidgetSpan(child: SizedBox(width: 2)),
            TextSpan(
                text: formatterSigned.format(income.energy),
                style: AppTheme.label14Gray),
          ])),
          RichText(
              text: TextSpan(style: AppTheme.label14, children: [
            const WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Icon(Symbols.settings_rounded,
                    size: 14, color: AppTheme.iconRed)),
            const WidgetSpan(child: SizedBox(width: 4)),
            TextSpan(
                text: formatterUnsigned.format(playerState.production)),
            const WidgetSpan(child: SizedBox(width: 2)),
            TextSpan(
                text: formatterSigned.format(income.production),
                style: AppTheme.label14Gray),
            const WidgetSpan(child: SizedBox(width: 2)),
            TextSpan(
                text: "/ ${formatterUnsigned.format(playerState.productionLimit)}"),
          ])),
          RichText(
              text: TextSpan(style: AppTheme.label14, children: [
            const WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Icon(Symbols.stars_rounded,
                    size: 14, color: AppTheme.iconBlue)),
            const WidgetSpan(child: SizedBox(width: 4)),
            TextSpan(text: formatterUnsigned.format(playerState.politics)),
            const WidgetSpan(child: SizedBox(width: 2)),
            TextSpan(
                text: formatterSigned.format(income.politics),
                style: AppTheme.label14Gray),
          ])),
        ],
      ),
    );
  }
}
