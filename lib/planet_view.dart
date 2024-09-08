// Planet view for sector overlay
import "dart:async";
import "dart:math";
import 'dart:ui' show Canvas, Paint, Rect;

import "package:flame/components.dart";

import "planet.dart";
import "styles.dart";
import "scifi_game.dart";
import "worker_select_dialog.dart";
import "components/advanced_button.dart";

class SlotCircle extends CircleComponent {
  final WorkerSlot slot;
  late final double innerRadius;
  late final bool isMultiSlot;
  late final List<Paint> piePaints;

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
    isMultiSlot = slot.allowedTypes.length == 2;
    if (slot.isOccupied) {
      piePaints = [getPaintForType(slot.type)];
    } else if (slot.allowedTypes.length == 3) {
      piePaints = [anySlot];
    } else if (isMultiSlot) {
      piePaints = slot.allowedTypes.map((t) => getPaintForType(t)).toList();
    } else {
      piePaints = [getPaintForType(slot.type)];
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (isMultiSlot) {
      for (final p in piePaints) {
        canvas.drawArc(
            Rect.fromCenter(
                center: center.toOffset(), width: width, height: height),
            pi / 2,
            pi,
            true,
            p);
      }
    } else {
      canvas.drawCircle(center.toOffset(), innerRadius, piePaints.first);
    }
  }

  static Paint getPaintForType(WorkerType type) {
    switch (type) {
      case WorkerType.mining:
        return miningSlot;
      case WorkerType.economy:
        return economySlot;
      case WorkerType.lab:
        return labSlot;
    }
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
      PlanetType.temperate => "economy.png",
      PlanetType.hot => "mining.png",
      PlanetType.cold => "lab.png",
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
                  text: WorkerSlot.output.toString(), textRenderer: label16),
              defaultSkin: SlotCircle(slot,
                  radius: circleIconSize.x / 2, paint: iconButtonBorder),
              hoverSkin: SlotCircle(slot,
                  radius: circleIconSize.x / 2, paint: iconButtonBorderHover),
              onReleased: () async {
                if (slot.allowedTypes.length > 1)  {
                  final selectedType = await game.router.pushAndWait(
                    WorkerSelectDialog(slot.allowedTypes),
                  );

                  _onSwitchWorker(slot, selectedType);
                }
              },
            )
          : AdvancedButton(
              size: circleIconSize,
              defaultLabel:
                  TextComponent(text: "\u454c", textRenderer: icon16pale),
              disabledLabel:
                  TextComponent(text: "\u47ca", textRenderer: icon16pale),
              defaultSkin: SlotCircle(slot,
                  radius: circleIconSize.x / 2, paint: iconButtonBorder),
              hoverSkin: SlotCircle(slot,
                  radius: circleIconSize.x / 2, paint: iconButtonBorderHover),
              disabledSkin: CircleComponent(
                  radius: circleIconSize.x / 2,
                  paintLayers: shipBtnDisabledSkin),
              onReleased: () async {
                if (slot.allowedTypes.length == 1) {
                  _onPlaceWorker(slot, slot.allowedTypes.first);
                } else {
                  final selectedType = await game.router.pushAndWait(
                    WorkerSelectDialog(slot.allowedTypes),
                  );

                  _onPlaceWorker(slot, selectedType);
                }
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
