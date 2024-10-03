import 'package:flame/components.dart';
import 'package:starfury/styles.dart';

import 'advanced_button.dart';

class TabButton extends AdvancedButton {
  late final RectangleComponent underline;
  TabButton({
    super.onReleased,
    super.defaultLabel,
    super.hoverLabel,
    super.size,
    super.position,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority,
  });

  bool _selected = false;
  bool get selected => _selected;
  set selected(bool value) {
    _selected = value;
    updateRender();
  }

  void updateRender() {
    underline.removeFromParent();
    if (_selected) {
      add(underline);
    }
  }

  @override
  Future<void> onLoad() {
    final Vector2 borderBottomPos = Vector2(0, size.y - 2);

    underline = RectangleComponent(
        position: borderBottomPos, size: Vector2(size.x, 2), paint: tabHover);
    defaultSkin = PositionComponent();

    return super.onLoad();
  }
}
