import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:starflame/scifi_game.dart';
import 'package:starflame/sector.dart';
import 'package:starflame/planet.dart';
import 'package:starflame/styles.dart';

class SectorOverlay extends StatefulWidget {
  const SectorOverlay(this.game, {super.key});

  static const id = 'sector_overlay';

  final ScifiGame game;

  @override
  State<SectorOverlay> createState() => _SectorOverlayState();
}

class _SectorOverlayState extends State<SectorOverlay> {
  late Sector sector;

  @override
  void initState() {
    sector = widget.game.hudState.sector.value!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double imgWidth = size.width > 1024 ? 144 : 100;
    return Container(
      color: AppTheme.dialogBackground,
      child: Column(
        children: [
          const SizedBox(
            height: navbarHeight,
          ),
          Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {
                    widget.game.overlays.remove(SectorOverlay.id);
                  },
                  child: const Text(
                    'x',
                    style: AppTheme.label16,
                  ))),
          ChangeNotifierProvider<Sector>.value(
            value: sector,
            child: Consumer<Sector>(
              builder: (context, value, child) => Expanded(
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final planet in sector.planets)
                        _buildPlanet(planet, imgWidth),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildPlanet(Planet planet, double imgWidth) {
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    for (final slot in planet.workerSlots)
                      Container(
                        width: 36,
                        height: 36,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: (slot.isOccupied)
                            ? _renderSlotOutput(planet, slot)
                            : _renderButton(planet, slot),
                      )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    children: [
                      Image.asset(
                        imageName(planet.type),
                        width: imgWidth,
                        height: imgWidth,
                      ),
                      const SizedBox(height: 36,)
                    ],
                  ),
                )
              ],
            ),
          ],
        ));
  }

  Widget _renderSlotOutput(Planet planet, WorkerSlot slot) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: getSlotColor(slot.type).withAlpha(128),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: getSlotColor(slot.type), width: 1),
      ),
      child: Center(
        child: Text(
          Sector.output.toString(),
          style: AppTheme.label16,
        ),
      ),
    );
  }

  Widget _renderButton(Planet planet, WorkerSlot slot) {
    return ElevatedButton(
        onPressed: _isDisabled(planet)
            ? null
            : () {
                _onPlaceWorker(planet, slot.type);
              },
        style: _getStyle(planet, slot),
        child: Text(
          "+",
          style: _isDisabled(planet) ? AppTheme.label16Gray : AppTheme.label16,
        ));
  }

  ButtonStyle _getStyle(Planet planet, WorkerSlot slot) {
    final isDisabled = _isDisabled(planet);
    Color slotColor = getSlotColor(slot.type).withAlpha(128);
    Color borderColor = getSlotColor(slot.type);
    if (isDisabled) {
      borderColor = AppTheme.disabledSlotBorder;
    }

    return ElevatedButton.styleFrom(
      backgroundColor: slotColor,
      disabledBackgroundColor: AppTheme.disabledSlot,
      padding: const EdgeInsets.all(0),
      elevation: isDisabled ? 0 : 1,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: borderColor, width: 1)),
    );
  }

  void _onPlaceWorker(Planet planet, WorkerType type) {
    final playerNumber = widget.game.controller.getHumanPlayerNumber();
    widget.game.resourceController
        .placeWorker(playerNumber, sector, planet, type);
  }

  bool _isDisabled(Planet planet) {
    final playerState = widget.game.controller.getHumanPlayerState();
    final canColonize = sector.canColonizePlanet(planet, playerState);
    return !canColonize ||
        !widget.game.resourceController
            .canPlaceWorker(playerState.playerNumber);
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

  static Color getSlotColor(WorkerType type) {
    return switch (type) {
      WorkerType.economy => AppTheme.economySlot,
      WorkerType.mining => AppTheme.miningSlot,
      WorkerType.lab => AppTheme.labSlot,
    };
  }
}
