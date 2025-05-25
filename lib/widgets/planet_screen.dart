import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'player_info.dart';
import 'package:starflame/scifi_game.dart';
import 'package:starflame/planet.dart';
import 'package:starflame/sim_props.dart';
import 'package:starflame/styles.dart';
import 'package:starflame/fmt.dart';
import 'package:starflame/hud_state.dart';

class PlanetScreen extends StatelessWidget with WatchItMixin {
  const PlanetScreen(this.game, {super.key});

  static const id = 'planet_screen';

  final ScifiGame game;

  @override
  Widget build(BuildContext context) {
    final planet = watchValue((HudState x) => x.planet);

    return Positioned(
      bottom: 8,
      left: 8,
      child: planet == null ? const SizedBox.shrink() : _renderPlanet(planet),
    );
  }

  Widget _renderPlanet(Planet planet) {
    final isPlayerPlanet =
        planet.playerNumber == game.controller.getHumanPlayerNumber();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: IconButton.outlined(
                onPressed: isPlayerPlanet
                    ? () {
                        game.overlays.remove(PlayerInfoBar.id);
                        game.overlays.add(PlayerInfoBar.id);
                      }
                    : null,
                style: AppTheme.iconButton,
                icon: const Icon(Symbols.planet_rounded)),
          )
        ]),
        Container(
          width: AppTheme.navbarWidth,
          decoration: BoxDecoration(
              border: Border.all(
            color: AppTheme.panelBorder,
          )),
          child: _renderPlanetInfo(planet),
        )
      ],
    );
  }

  Widget _renderPlanetInfo(Planet planet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: AppTheme.navbarWidth,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          color: AppTheme.panelBorder,
          child: Text(planet.displayName, style: AppTheme.label12),
        ),
        Padding(
          padding: const EdgeInsets.all(4),
          child: RichText(
              text: TextSpan(style: AppTheme.label12, children: [
            if (planet.getProp(SimProps.production) != 0)
              const WidgetSpan(
                  child: Icon(Symbols.settings_rounded,
                      size: 16, color: AppTheme.iconRed)),
            if (planet.getProp(SimProps.production) != 0)
              TextSpan(
                  text:
                      " ${formatterSigned.format(planet.getProp(SimProps.production))} "),
            if (planet.getProp(SimProps.energy) != 0)
              const WidgetSpan(
                  child: Icon(Symbols.bolt_rounded,
                      size: 16, color: AppTheme.iconYellow)),
            if (planet.getProp(SimProps.energy) != 0)
              TextSpan(
                  text:
                      " ${formatterSigned.format(planet.getProp(SimProps.energy))} "),
            if (planet.getProp(SimProps.politics) != 0)
              const WidgetSpan(
                  child: Icon(Symbols.stars_rounded,
                      size: 16, color: AppTheme.iconBlue)),
            if (planet.getProp(SimProps.politics) != 0)
              TextSpan(
                  text:
                      " ${formatterSigned.format(planet.getProp(SimProps.politics))} "),
          ])),
        ),
      ],
    );
  }
}
