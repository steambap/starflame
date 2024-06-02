import "package:flame/components.dart";
import "package:flame/events.dart";

import "theme.dart" show dialogBackground;

class DialogBackground extends RectangleComponent
    with TapCallbacks, DragCallbacks {
  DialogBackground({super.position, super.size, super.children, super.anchor})
      : super(
          paint: dialogBackground,
        );
}
