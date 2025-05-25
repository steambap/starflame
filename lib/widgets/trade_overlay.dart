import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:starflame/styles.dart';
import 'package:starflame/scifi_game.dart';
import 'package:starflame/player_state.dart';
import 'package:starflame/resource.dart';
import 'package:starflame/empire.dart';

class TradeOverlay extends StatelessWidget with WatchItMixin {
  const TradeOverlay(this.game, {super.key});

  static const id = 'trade_overlay';

  final ScifiGame game;

  @override
  Widget build(BuildContext context) {
    final playerState =
        watch<PlayerState>(game.controller.getHumanPlayerState());
    final int tradeAmount =
        playerState.empire.tradeRatio == TradeRatio.twoToOne ? 6 : 9;

    return Container(
        color: AppTheme.dialogBackground,
        child: Column(
          children: [
            SizedBox(
              height: AppTheme.navbarMargin,
              child: TextButton.icon(
                  onPressed: () {
                    game.overlays.remove(id);
                  },
                  icon: const Icon(Symbols.cancel_rounded,
                      color: AppTheme.iconPale),
                  label: const Text(
                    'Trade Screen',
                    style: AppTheme.label16,
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      RichText(
                          text: const TextSpan(
                              style: AppTheme.label14,
                              children: [
                            TextSpan(text: 'Buy', style: AppTheme.heading24),
                            TextSpan(text: ' ( cost 12'),
                            WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Icon(Symbols.bolt_rounded,
                                    size: 14, color: AppTheme.iconYellow)),
                            TextSpan(text: ')'),
                          ])),
                      ElevatedButton(
                          onPressed: () {
                            playerState.addResource(Resources(
                                energy: -12, production: tradeAmount));
                          },
                          style: AppTheme.menuButton,
                          child: RichText(
                              text:
                                  TextSpan(style: AppTheme.label16, children: [
                            TextSpan(text: '+$tradeAmount'),
                            const WidgetSpan(child: SizedBox(width: 2)),
                            const WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Icon(Symbols.settings_rounded,
                                    size: 14, color: AppTheme.iconRed)),
                          ]))),
                      ElevatedButton(
                          onPressed: () {
                            playerState.addResource(
                                Resources(energy: -12, politics: tradeAmount));
                          },
                          style: AppTheme.menuButton,
                          child: RichText(
                              text:
                                  TextSpan(style: AppTheme.label16, children: [
                            TextSpan(text: '+$tradeAmount'),
                            const WidgetSpan(child: SizedBox(width: 2)),
                            const WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Icon(Symbols.stars_rounded,
                                    size: 14, color: AppTheme.iconBlue)),
                          ]))),
                    ]),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      RichText(
                          text: TextSpan(style: AppTheme.label14, children: [
                        const TextSpan(text: 'Sell', style: AppTheme.heading24),
                        TextSpan(text: ' ( gain $tradeAmount'),
                        const WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(Symbols.bolt_rounded,
                                size: 14, color: AppTheme.iconYellow)),
                        const TextSpan(text: ')'),
                      ])),
                      ElevatedButton(
                          onPressed: () {
                            playerState.addResource(Resources(
                                energy: tradeAmount, production: -12));
                          },
                          style: AppTheme.menuButton,
                          child: RichText(
                              text: const TextSpan(
                                  style: AppTheme.label16,
                                  children: [
                                TextSpan(text: '-12'),
                                WidgetSpan(child: SizedBox(width: 2)),
                                WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Icon(Symbols.settings_rounded,
                                        size: 14, color: AppTheme.iconRed)),
                              ]))),
                      ElevatedButton(
                          onPressed: () {
                            playerState.addResource(
                                Resources(energy: tradeAmount, politics: -12));
                          },
                          style: AppTheme.menuButton,
                          child: RichText(
                              text: const TextSpan(
                                  style: AppTheme.label16,
                                  children: [
                                TextSpan(text: '-12'),
                                WidgetSpan(child: SizedBox(width: 2)),
                                WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Icon(Symbols.stars_rounded,
                                        size: 14, color: AppTheme.iconBlue)),
                              ]))),
                    ]),
              ],
            ),
          ],
        ));
  }
}
