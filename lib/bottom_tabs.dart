import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'scifi_game.dart';
import 'draggable_action_sprite.dart';

enum Tab {
  command,
  build,
  fleet,
}

class HudBottomTabs extends PositionComponent with HasGameRef<ScifiGame> {
  late final SpriteButtonComponent _commandTab;
  late final SpriteButtonComponent _buildTab;
  late final SpriteButtonComponent _fleetTab;
  late final DraggableActionSprite _colonizeAction;
  Tab currentTab = Tab.command;

  HudBottomTabs() : super(anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() {
    position = Vector2(game.size.x / 2, game.size.y);

    final spriteCommand = Sprite(game.images.fromCache("powerupBlue.png"));
    final spriteBuild = Sprite(game.images.fromCache("powerupBlue_bolt.png"));
    final spriteFleet = Sprite(game.images.fromCache("powerupBlue_shield.png"));
    _commandTab = SpriteButtonComponent(
        anchor: Anchor.center,
        position: Vector2(-spriteBuild.originalSize.x, -20),
        button: spriteCommand,
        onPressed: () {
          currentTab = Tab.command;
        });
    _buildTab = SpriteButtonComponent(
        anchor: Anchor.center,
        position: Vector2(0, -20),
        button: spriteBuild,
        onPressed: () {
          currentTab = Tab.build;
        });
    _fleetTab = SpriteButtonComponent(
        anchor: Anchor.center,
        position: Vector2(spriteBuild.originalSize.x, -20),
        button: spriteFleet,
        onPressed: () {
          currentTab = Tab.fleet;
        });

    _colonizeAction = DraggableActionSprite(position: Vector2(0, -60), arrowOffset: position.inverted());
    addAll([_commandTab, _buildTab, _fleetTab, _colonizeAction]);
  }
}
