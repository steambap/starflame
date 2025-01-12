import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import 'scifi_game.dart';

class Backdrop extends RectangleComponent with HasGameRef<ScifiGame> {
  late final FragmentShader _shader;

  Backdrop() : super();

  @override
  FutureOr<void> onLoad() async {
    size = game.size;

    final program = await FragmentProgram.fromAsset('shaders/backdrop.frag');
    _shader = program.fragmentShader();
    _shader.setFloat(0, size.x);
    _shader.setFloat(1, size.y);
    paint = Paint()..shader = _shader;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _shader.setFloat(2, game.camera.viewfinder.position.x);
    _shader.setFloat(3, game.camera.viewfinder.position.y);
    super.update(dt);
  }

  @override
  void onGameResize(Vector2 size) {
    size = game.size;

    super.onGameResize(size);
  }
}
