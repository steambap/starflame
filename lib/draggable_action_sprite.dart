import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'scifi_game.dart';
import 'line_component.dart';
import 'cell.dart';

class DraggableActionSprite extends SpriteComponent
    with HasGameRef<ScifiGame>, DragCallbacks {
  static final Paint strokePaint = Paint()
    ..color = const Color(0xfffb8f58)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

  Vector2 arrowOffset;
  Cell? lastCell;
  final LineComponent arrow =
      LineComponent(Vector2.zero(), anchor: Anchor.center);

  DraggableActionSprite({super.position, required this.arrowOffset})
      : super(anchor: Anchor.center, priority: 1);

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache("powerupBlue_star.png"));

    arrow.paint = strokePaint;
    arrow.position += size / 2;
    add(arrow);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    priority = 100;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!isDragged) {
      return;
    }

    final localPosition = game.camera.globalToLocal(event.canvasPosition);
    lastCell = game.mapGrid.cellAtPosition(localPosition);
    if (lastCell == null) {
      arrow.reset();
    } else {
      arrow.to = arrowOffset +
          position.inverted() +
          game.camera.localToGlobal(lastCell!.position);
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    priority = 1;
    arrow.reset();

    lastCell?.planet
        ?.colonize(game.gameStateController.currentPlayerState().playerNumber);
  }
}
