import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/effects.dart';
import "package:flutter/foundation.dart";
import 'package:flutter/services.dart';

import 'scifi_game.dart';
import 'planet.dart';
import "styles.dart";

class ScifiWorld extends World
    with HasGameReference<ScifiGame>, KeyboardHandler, DragCallbacks {
  final double moveSpeed = 64;
  Vector2 direction = Vector2.zero();
  bool isGameStarted = false;
  bool _isDragPlanet = false;
  Planet? _dragPlanet;
  Vector2 _dragEndPoint = Vector2.zero();

  @mustCallSuper
  @override
  void update(double dt) {
    final Vector2 velocity = direction * moveSpeed;

    game.camera.moveBy(velocity);
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (!isGameStarted) {
      return false;
    }

    // if (keysPressed
    //     .containsAll([LogicalKeyboardKey.shiftLeft, LogicalKeyboardKey.keyV])) {
    //   game.controller.debugWinGame();
    // }
    direction = Vector2.zero();
    direction.x += (keysPressed.contains(LogicalKeyboardKey.keyA) ||
            keysPressed.contains(LogicalKeyboardKey.arrowLeft))
        ? -1
        : 0;
    direction.x += (keysPressed.contains(LogicalKeyboardKey.keyD) ||
            keysPressed.contains(LogicalKeyboardKey.arrowRight))
        ? 1
        : 0;

    direction.y += (keysPressed.contains(LogicalKeyboardKey.keyW) ||
            keysPressed.contains(LogicalKeyboardKey.arrowUp))
        ? -1
        : 0;
    direction.y += (keysPressed.contains(LogicalKeyboardKey.keyS) ||
            keysPressed.contains(LogicalKeyboardKey.arrowDown))
        ? 1
        : 0;

    return true;
  }

  @override
  void onDragStart(DragStartEvent event) {
    final cmps = game.componentsAtPoint(event.canvasPosition);
    for (final cmp in cmps) {
      if (cmp is Planet) {
        _dragPlanet = cmp;
        cmp.select();
        _isDragPlanet = true;
        break;
      }
    }

    super.onDragStart(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (_isDragPlanet && _dragPlanet != null) {
      _handleDragPlanetEnd();
    }
    _isDragPlanet = false;
    _dragPlanet?.deselect();
    _dragPlanet = null;
    super.onDragEnd(event);
  }

  void _handleDragPlanetEnd() {
    final p = _dragPlanet!;
    final cmps = game.componentsAtPoint(_dragEndPoint);
    for (final cmp in cmps) {
      if (cmp is Planet && game.mapGrid.isPlanetConnected(p, cmp)) {
        p.rallyPoint = cmp;
        break;
      }
      if (cmp == p) {
        p.rallyPoint = null;
        break;
      }
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (_isDragPlanet) {
      _dragEndPoint = event.canvasEndPosition;
      return;
    }
    game.camera.moveBy(-event.localDelta);
  }

  @override
  void render(Canvas canvas) {
    if (_isDragPlanet && _dragPlanet != null) {
      final pos = _dragPlanet!.position.toOffset();
      final end = game.camera.globalToLocal(_dragEndPoint).toOffset();
      canvas.drawLine(pos, end, FlameTheme.connection);
    }
    super.render(canvas);
  }

  void renderBullet(PositionComponent from, PositionComponent to,
      void Function()? onComplete) {
    final bullet = SpriteComponent.fromImage(
      game.images.fromCache("ships/bullet.png"),
      anchor: Anchor.center,
      scale: Vector2.all(0.5),
    );
    bullet.position = from.position.clone();
    bullet.lookAt(to.position);

    final removeEff = RemoveEffect(delay: 0.1, onComplete: onComplete);
    final moveEff = MoveToEffect(
      to.position,
      EffectController(duration: 0.1),
    );
    bullet.addAll([removeEff, moveEff]);
    add(bullet);
  }

  void renderDamageText(String text, Vector2 position) {
    final textComponent = TextComponent(
        text: text, textRenderer: FlameTheme.textDamage, position: position);

    final removeEff = RemoveEffect(delay: 0.5);
    final moveEff = MoveByEffect(
      Vector2(0, -18),
      EffectController(duration: 0.5),
    );
    textComponent.addAll([removeEff, moveEff]);
    add(textComponent);
  }
}
