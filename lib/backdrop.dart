import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import 'scifi_game.dart';

class Backdrop extends RectangleComponent with HasGameReference<ScifiGame> {
  late final FragmentShader _shader;
  // last camera position we sent to the GPU
  final Vector2 _lastCamPos = Vector2.zero();

  Backdrop() : super();

  @override
  FutureOr<void> onLoad() async {
    size = game.size;

    final program = await FragmentProgram.fromAsset('shaders/backdrop.frag');
    _shader = program.fragmentShader();
    _shader.setFloat(0, size.x);
    _shader.setFloat(1, size.y);
    _shader.setFloat(2, 0);
    _shader.setFloat(3, 0);
    paint = Paint()..shader = _shader;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    final cam = game.camera.viewfinder.position;
    if (cam != _lastCamPos) {
      _lastCamPos.setFrom(cam);
      _shader.setFloat(2, _lastCamPos.x);
      _shader.setFloat(3, _lastCamPos.y);
    }

    super.update(dt);
  }

  @override
  void onGameResize(Vector2 size) {
    this.size = size;
    if (isMounted) {
      _shader.setFloat(0, size.x);
      _shader.setFloat(1, size.y);
    }

    super.onGameResize(size);
  }
}
