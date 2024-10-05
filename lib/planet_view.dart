// Planet view for sector overlay
import "dart:async";
import 'dart:ui' show Canvas, Paint;

import "package:flame/components.dart";

import "planet.dart";
import "styles.dart";
import "scifi_game.dart";
import "worker_select_dialog.dart";
import "components/advanced_button.dart";

class SlotCircle extends CircleComponent {
  final WorkerSlot slot;
  late final double innerRadius;
  late final Paint piePaints;

  SlotCircle(
    this.slot, {
    required double radius,
    super.position,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority,
    super.paint,
    super.paintLayers,
    super.key,
  }) : super(radius: radius) {
    innerRadius = radius - 3;

    if (slot.isOccupied) {
      piePaints = getPaintForType(slot.type);
    } else {
      piePaints = unoccupiedSlot;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(center.toOffset(), innerRadius, piePaints);
  }

  static Paint getPaintForType(WorkerType type) {
    return switch (type) {
      WorkerType.support => supportSlot,
      WorkerType.mining => miningSlot,
      WorkerType.economy => economySlot,
      WorkerType.lab => labSlot
    };
  }
}

class PlanetView extends PositionComponent with HasGameRef<ScifiGame> {
  final Planet planet;
  late final SpriteComponent _planetSprite;
  late final TextComponent _planetName;
  final List<AdvancedButton> _buttons = [];

  /// Callback for what should happen when player takes a slot.
  final void Function(WorkerSlot slot, WorkerType type) _onPlaceWorker;
  final void Function(WorkerSlot slot, WorkerType type) _onSwitchWorker;

  PlanetView(this.planet, this._onPlaceWorker, this._onSwitchWorker);

  @override
  FutureOr<void> onLoad() {
    final imageName = switch (planet.type) {
      PlanetType.terran => "terran.png",
      PlanetType.desert => "desert.png",
      PlanetType.iron => "iron.png",
      PlanetType.ice => "ice.png",
      PlanetType.gas => "gas.png",
      _ => "gas.png",
    };
    final planetImage = game.images.fromCache(imageName);
    _planetSprite = SpriteComponent(sprite: Sprite(planetImage));
    _planetName = TextComponent(
      text: planet.name,
      position: Vector2(0, 156),
      textRenderer: label12,
      anchor: Anchor.centerLeft,
    );

    addAll([
      _planetSprite,
      _planetName,
    ]);
    updateSlotRender();
    return super.onLoad();
  }

  void updateSlotRender() {
    // Remove previous slot buttons
    for (final b in _buttons) {
      b.removeFromParent();
    }
    _buttons.clear();

    for (int i = 0; i < planet.workerSlots.length; i++) {
      final slot = planet.workerSlots[i];
      final button = slot.isOccupied
          ? AdvancedButton(
              size: circleIconSize,
              defaultLabel: TextComponent(
                  text: slotOutput(planet, slot.type).toString(),
                  textRenderer: label16),
              defaultSkin: SlotCircle(slot,
                  radius: circleIconSize.x / 2, paint: iconButtonBorder),
              hoverSkin: SlotCircle(slot,
                  radius: circleIconSize.x / 2, paint: iconButtonBorderHover),
              onReleased: () async {
                final selectedType = await game.router.pushAndWait(
                  WorkerSelectDialog(
                      text: "Select worker type for ${planet.name}"),
                );

                _onSwitchWorker(slot, selectedType);
              },
            )
          : AdvancedButton(
              size: circleIconSize,
              defaultLabel:
                  TextComponent(text: "\ue141", textRenderer: icon16pale),
              disabledLabel:
                  TextComponent(text: "\ue10f", textRenderer: icon16pale),
              defaultSkin: SlotCircle(slot,
                  radius: circleIconSize.x / 2, paint: iconButtonBorder),
              hoverSkin: SlotCircle(slot,
                  radius: circleIconSize.x / 2, paint: iconButtonBorderHover),
              disabledSkin: CircleComponent(
                  radius: circleIconSize.x / 2,
                  paintLayers: shipBtnDisabledSkin),
              onReleased: () async {
                final selectedType = await game.router.pushAndWait(
                  WorkerSelectDialog(
                      text: "Select worker type for ${planet.name}"),
                );

                _onPlaceWorker(slot, selectedType);
              },
            );
      button.position = Vector2(i * (circleIconSize.x + 8), 168);
      button.isDisabled = !game.resourceController
          .canPlaceWorker(game.controller.getHumanPlayerNumber());
      _buttons.add(button);
    }

    addAll(_buttons);
  }
}
