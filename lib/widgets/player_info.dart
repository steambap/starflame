import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:starflame/styles.dart';
import 'package:starflame/scifi_game.dart';
import 'package:starflame/player_state.dart';
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
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 2),
        width: AppTheme.navbarWidth,
        height: AppTheme.navbarHeight,
        decoration: BoxDecoration(
            color: AppTheme.panelBackground,
            border: Border.all(color: AppTheme.panelBorder)),
        child: Consumer<PlayerState>(
          builder: (context, value, child) => _bar(),
        ),
      ),
    );
  }

  Widget _bar() {
    final playerState = game.controller.getHumanPlayerState();
    final income = game.resourceController.humanPlayerIncome();
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: RichText(
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
                ])),
              ),
              Expanded(
                child: RichText(
                    text: TextSpan(style: AppTheme.label14, children: [
                  const WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(Symbols.copyright_rounded,
                          size: 14, color: AppTheme.iconYellow)),
                  const WidgetSpan(child: SizedBox(width: 4)),
                  TextSpan(text: formatterUnsigned.format(playerState.credit)),
                  const WidgetSpan(child: SizedBox(width: 2)),
                  TextSpan(
                      text: formatterSigned.format(income.credit),
                      style: AppTheme.label14Gray),
                ])),
              ),
              Expanded(
                child: RichText(
                    text: TextSpan(style: AppTheme.label14, children: [
                  const WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(Symbols.experiment_rounded,
                          size: 14, color: AppTheme.iconBlue)),
                  const WidgetSpan(child: SizedBox(width: 4)),
                  TextSpan(text: formatterUnsigned.format(playerState.science)),
                  const WidgetSpan(child: SizedBox(width: 2)),
                  TextSpan(
                      text: formatterSigned.format(income.science),
                      style: AppTheme.label14Gray),
                ])),
              ),
            ],
          ),
        ),
        // Bottom
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppTheme.panelBorder),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                    text: TextSpan(style: AppTheme.label14, children: [
                  const WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(Symbols.account_circle_rounded,
                          size: 14, color: AppTheme.iconPurple)),
                  const WidgetSpan(child: SizedBox(width: 4)),
                  TextSpan(text: formatterUnsigned.format(playerState.support)),
                  const WidgetSpan(child: SizedBox(width: 2)),
                  TextSpan(
                      text: formatterSigned.format(income.support),
                      style: AppTheme.label14Gray),
                ])),
                RichText(
                  text: TextSpan(
                    style: AppTheme.label12,
                    children: [
                      TextSpan(
                        text:
                            "Next Action Cost: ${playerState.nextActionCost} ",
                      ),
                      const WidgetSpan(
                          child: Icon(Symbols.account_circle_rounded,
                              size: 14, color: AppTheme.iconPurple)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
