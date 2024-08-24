import "package:flame/components.dart";
import "package:flame/events.dart";

import "theme.dart" show dialogBackground;

class DialogBackground extends RectangleComponent
    with TapCallbacks, DragCallbacks {
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
}
