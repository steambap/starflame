import "package:flame/components.dart";
import "package:flame/events.dart";
import 'package:flutter/services.dart';

import "styles.dart" show dialogBackground;

class DialogBackground extends RectangleComponent
    with TapCallbacks, DragCallbacks, KeyboardHandler {
  void Function()? onClick;
  DialogBackground(
      {this.onClick, super.position, super.size, super.children, super.anchor})
      : super(
          paint: dialogBackground,
        );

  @override
  void onTapUp(TapUpEvent event) {
    onClick?.call();
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.escape)) {
      onClick?.call();
    }
    return true;
  }
}
