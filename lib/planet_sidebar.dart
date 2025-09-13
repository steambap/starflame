import 'dart:math' as math;
import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'circular_progress.dart';
import 'styles.dart';
import 'scifi_game.dart';

class PlanetSidebar extends PositionComponent with HasGameReference<ScifiGame> {
  final double radius;
  final TextComponent _shipCount = TextComponent(
    text: '',
    anchor: Anchor.center,
    textRenderer: FlameTheme.heading24,
  );
  final CircularProgressBar _productionProgressBar = CircularProgressBar(
    radius: 20,
  );
  final CircleComponent _productionCircle = CircleComponent(
    radius: 24,
    paintLayers: FlameTheme.planetSidebarProdCircle,
    anchor: Anchor.center,
  );
  final CircleComponent _stateCircle = CircleComponent(
    radius: 24,
    paintLayers: FlameTheme.planetSidebarStateCircle,
    anchor: Anchor.center,
  );
  late final SpriteComponent _defendSprite;
  late final SpriteComponent _moveSprite;
  late final Rect rect;
  late final Offset _centerOffset;

  bool _isDefending = true;

  PlanetSidebar(this.radius, {super.position, super.priority, super.anchor})
      : super(size: Vector2.all(radius * 2));

  String get shipCount => _shipCount.text;

  set shipCount(String count) {
    if (_shipCount.text == count) {
      return;
    }
    _shipCount.text = count;
  }

  set productionProgress(double progress) {
    _productionProgressBar.progress = progress;
  }

  set isDefending(bool value) {
    if (value == _isDefending) {
      return;
    }
    _isDefending = value;
    _defendSprite.removeFromParent();
    _moveSprite.removeFromParent();
    if (value) {
      add(_defendSprite);
    } else {
      add(_moveSprite);
    }
  }

  void setPaint(Paint paint) {
    _stateCircle.paintLayers = [paint, FlameTheme.planetSidebarStateCircle[1]];
  }

  @override
  FutureOr<void> onLoad() {
    rect = Rect.fromLTWH(0, 0, radius * 2, radius * 2);
    _centerOffset = (size / 2).toOffset();
    _defendSprite = SpriteComponent(
      sprite: Sprite(game.images.fromCache('shield.png')),
      anchor: Anchor.center,
    );
    _moveSprite = SpriteComponent(
      sprite: Sprite(game.images.fromCache('move.png')),
      anchor: Anchor.center,
    );

    const prodAngle = math.pi * 4 / 3;
    final prodIcoPos = size / 2 +
        Vector2(radius * math.cos(prodAngle), radius * math.sin(prodAngle));
    _shipCount.position = prodIcoPos;
    _productionProgressBar.position = prodIcoPos;
    _productionCircle.position = prodIcoPos;

    const stateAngle = math.pi * 9 / 8;
    final stateIcoPos = size / 2 +
        Vector2(radius * math.cos(stateAngle), radius * math.sin(stateAngle));
    _stateCircle.position = stateIcoPos;
    _defendSprite.position = stateIcoPos;
    _moveSprite.position = stateIcoPos;

    addAll([
      _productionCircle,
      _shipCount,
      _productionProgressBar,
      _stateCircle,
      _defendSprite
    ]);
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawArc(rect, math.pi, math.pi / 2, false, FlameTheme.planetSidebar);
    canvas.drawLine(_centerOffset, _centerOffset - Offset(radius, 0),
        FlameTheme.planetSidebar);
    canvas.drawLine(_centerOffset, _centerOffset - Offset(0, radius),
        FlameTheme.planetSidebar);

    super.render(canvas);
  }
}
