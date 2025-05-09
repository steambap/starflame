import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:starflame/scifi_game.dart';
import 'package:starflame/sector.dart';
import 'package:starflame/planet.dart';
import 'package:starflame/sim_props.dart';
import 'package:starflame/styles.dart';
import 'package:starflame/widgets/progress_bar.dart';
import 'package:starflame/hud_state.dart';

class SectorOverlay extends StatefulWidget with WatchItStatefulWidgetMixin {
  const SectorOverlay(this.game, {super.key});

  static const id = 'sector_overlay';

  final ScifiGame game;

  @override
  State<SectorOverlay> createState() => _SectorOverlayState();
}

class _SectorOverlayState extends State<SectorOverlay> {
  String selectedProp = '';

  @override
  Widget build(BuildContext context) {
    final sector1 = watchValue((HudState x) => x.sector)!;
    final sector = watch<Sector>(sector1);

    final pWidth =
        MediaQuery.of(context).size.width - AppTheme.navbarWidth - 24;
    final pHeight =
        MediaQuery.of(context).size.height - AppTheme.navbarMargin - 8;
    return Container(
      color: AppTheme.dialogBackground,
      child: Column(
        children: [
          SizedBox(
            height: AppTheme.navbarMargin,
            child: TextButton.icon(
                onPressed: () {
                  widget.game.overlays.remove(SectorOverlay.id);
                },
                icon: const Icon(Symbols.cancel_rounded,
                    color: AppTheme.iconPale),
                label: const Text(
                  'Planet Management',
                  style: AppTheme.label16,
                )),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                width: AppTheme.navbarWidth,
                decoration: BoxDecoration(
                    color: AppTheme.panelBackground,
                    border: Border.all(color: AppTheme.panelBorder)),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        width: AppTheme.navbarWidth,
                        color: AppTheme.panelTitle,
                        child:
                            Text(sector.displayName, style: AppTheme.label16),
                      ),
                      _renderOutputBar(sector, SimProps.production),
                      _renderOutputBar(sector, SimProps.credit),
                      _renderOutputBar(sector, SimProps.science),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Align(
                          alignment: Alignment.center,
                          child: _increaseOutputButton(sector),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: pWidth,
                height: pHeight,
                child: SingleChildScrollView(
                  child: Wrap(
                    children: [
                      for (final planet in sector.planets)
                        _renderPlanet(sector, planet),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _increaseOutputButton(Sector sector) {
    return TextButton(
        onPressed: widget.game.resourceController.canIncreaseOutput(
                widget.game.controller.getHumanPlayerState(),
                sector,
                selectedProp)
            ? () {
                widget.game.resourceController.increaseOutput(
                    widget.game.controller.getHumanPlayerState(),
                    sector,
                    selectedProp);
              }
            : null,
        style: AppTheme.menuButton,
        child: const Text('Increase'));
  }

  Widget _renderOutputBar(Sector sector, String prop) {
    final predict =
        prop == selectedProp ? sector.predictIncreaseOutput(selectedProp) : 0;
    final segments = [
      sector.currentOutput.of(prop),
      predict,
      sector.maxOutput.of(prop) - sector.currentOutput.of(prop) - predict,
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        spacing: 4,
        children: [
          IconButton.outlined(
              onPressed: () {
                setState(() {
                  if (selectedProp == prop) {
                    selectedProp = "";
                  } else {
                    selectedProp = prop;
                  }
                });
              },
              style: AppTheme.iconButtonFilled,
              isSelected: selectedProp == prop,
              icon: getIcon(prop)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "$prop: ${sector.currentOutput.of(prop)} / ${sector.maxOutput.of(prop)}",
                    style: AppTheme.label16),
                ProgressBar(
                  segments: segments,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderPlanet(Sector sector, Planet planet) {
    return Container(
        color: AppTheme.cardColor,
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              planet.name,
              style: AppTheme.label16,
            ),
            Container(
              transform: Matrix4.translationValues(0, -4, 0),
              child: Text(
                planet.type.name,
                style: AppTheme.label12Gray,
              ),
            ),
            Image.asset(
              imageName(planet.type),
              width: 144,
              height: 144,
            ),
            SizedBox(
              width: 144,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: _colonizeButton(sector, planet),
                  ),
                  const Icon(Symbols.rocket_launch_rounded,
                      color: AppTheme.iconPale),
                ],
              ),
            )
          ],
        ));
  }

  Widget _colonizeButton(Sector sector, Planet planet) {
    if (planet.isColonized) {
      return const SizedBox.shrink();
    }

    final playerState = widget.game.controller.getHumanPlayerState();
    return IconButton.outlined(
      onPressed: !widget.game.resourceController
              .canColonizePlanet(playerState, sector, planet)
          ? null
          : () {
              widget.game.resourceController
                  .colonizePlanet(playerState, sector, planet);
            },
      icon: const Icon(Symbols.flag),
      iconSize: 16,
      style: AppTheme.iconButton,
    );
  }

  static String imageName(PlanetType type) {
    final img = switch (type) {
      PlanetType.terran => "terran.png",
      PlanetType.desert => "desert.png",
      PlanetType.iron => "iron.png",
      PlanetType.ice => "ice.png",
      PlanetType.gas => "gas.png",
    };
    return 'assets/images/$img';
  }

  static Icon getIcon(String prop) {
    return switch (prop) {
      SimProps.production => const Icon(Symbols.settings_rounded),
      SimProps.credit => const Icon(Symbols.copyright_rounded),
      SimProps.science => const Icon(Symbols.experiment_rounded),
      _ => const Icon(Symbols.question_mark_rounded),
    };
  }
}
