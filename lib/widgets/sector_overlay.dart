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
                        child: Stack(
                            fit: StackFit.passthrough,
                            clipBehavior: Clip.none,
                            children: [
                              if (slot.isAdvanced)
                                Positioned(
                                    left: -6,
                                    top: -16,
                                    child: Text('\ue257',
                                        style: _isDisabled(slot)
                                            ? AppTheme.iconSlotDisabled
                                            : AppTheme.iconSlot)),
                              ElevatedButton(
                                  onPressed: _isDisabled(slot)
                                      ? null
                                      : () {
                                          _askForWorker(
                                              planet, slot, slot.isOccupied);
                                        },
                                  style: _getStyle(slot),
                                  child: Text(
                                    slot.isOccupied
                                        ? slotOutput(planet, slot.type)
                                            .toString()
                                        : "+",
                                    style: AppTheme.label16,
                                  )),
                            ]),
                      )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(left: 8),
                  child: Image.asset(
                    imageName(planet.type),
                    width: imgWidth,
                    height: imgWidth,
                  ),
                )
              ],
            ),
          ],
        ));
  }

  ButtonStyle _getStyle(WorkerSlot slot) {
    final isDisabled = _isDisabled(slot);
    Color slotColor = switch (slot.type) {
      WorkerType.support => AppTheme.supportSlot,
      WorkerType.economy => AppTheme.economySlot,
      WorkerType.mining => AppTheme.miningSlot,
      WorkerType.lab => AppTheme.labSlot,
    };
    Color? disabledSlotColor;
    if (slot.isOccupied) {
      disabledSlotColor = slotColor.withOpacity(0.5);
    } else {
      slotColor = AppTheme.unoccupiedSlot;
    }

    final borderColor =
        isDisabled ? AppTheme.slotBorderDisabled : AppTheme.slotBorder;
    return ElevatedButton.styleFrom(
      backgroundColor: slotColor,
      disabledBackgroundColor: disabledSlotColor,
      padding: const EdgeInsets.all(0),
      elevation: isDisabled ? 0 : 1,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: borderColor, width: 1)),
    );
  }

  void _onPlaceWorker(WorkerSlot slot, WorkerType type) {
    final playerNumber = widget.game.controller.getHumanPlayerNumber();
    widget.game.resourceController
        .placeWorker(playerNumber, sector, slot, type);
  }

  void _onSwitchWorker(WorkerSlot slot, WorkerType type) {
    final playerNumber = widget.game.controller.getHumanPlayerNumber();
    widget.game.resourceController
        .switchWorker(playerNumber, sector, slot, type);
  }

  bool _isDisabled(WorkerSlot slot) {
    final playerNumber = widget.game.controller.getHumanPlayerNumber();
    return slot.isOccupied
        ? !widget.game.resourceController.canSwitchWorker(playerNumber)
        : !widget.game.resourceController.canPlaceWorker(playerNumber);
  }

  bool _isCurrentWorker(WorkerSlot slot, bool isSwitch, WorkerType type) {
    if (isSwitch) {
      return slot.type == type;
    }

    return false;
  }

  Future<void> _askForWorker(
      Planet planet, WorkerSlot slot, bool isSwitch) async {
    final prompt = isSwitch
        ? 'Switch to a different worker type'
        : 'Please select a worker type';
    final result = await showDialog<WorkerType>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            titlePadding: const EdgeInsets.all(0),
            title: Container(
                color: AppTheme.dialogTitleBg,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                child: Text(prompt, style: AppTheme.label16)),
            children: WorkerType.values
                .where((type) => !_isCurrentWorker(slot, isSwitch, type))
                .map((type) => SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context, type);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(type.name, style: AppTheme.label16Gray),
                          Row(
                            children: [
                              Text("+${slotOutput(planet, type).toString()}",
                                  style: AppTheme.label16),
                              const SizedBox(width: 4),
                              workerIcon(type),
                            ],
                          )
                        ],
                      ),
                    ))
                .toList(),
          );
        });

    if (result != null) {
      isSwitch ? _onSwitchWorker(slot, result) : _onPlaceWorker(slot, result);
    }
  }

  static String imageName(PlanetType type) {
    final img = switch (type) {
      PlanetType.terran => "terran.png",
      PlanetType.desert => "desert.png",
      PlanetType.iron => "iron.png",
      PlanetType.ice => "ice.png",
      PlanetType.gas => "gas.png",
      _ => "gas.png",
    };
    return 'assets/images/$img';
  }

  static Text workerIcon(WorkerType type) {
    return switch (type) {
      WorkerType.support => const Text(
          "\ue467",
          style: AppTheme.icon16purple,
        ),
      WorkerType.economy => const Text(
          "\ue0bc",
          style: AppTheme.icon16yellow,
        ),
      WorkerType.mining => const Text(
          "\ue1b1",
          style: AppTheme.icon16red,
        ),
      WorkerType.lab => const Text(
          "\ue0db",
          style: AppTheme.icon16blue,
        ),
    };
  }
}
