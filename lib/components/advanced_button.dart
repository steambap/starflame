import 'package:flame/components.dart';

class AdvancedButton extends AdvancedButtonComponent {
  AdvancedButton({
    PositionComponent? hoverLabel,
    super.onPressed,
    super.onReleased,
    super.onChangeState,
    super.defaultSkin,
    super.downSkin,
    super.hoverSkin,
    super.disabledSkin,
    super.defaultLabel,
    super.disabledLabel,
    super.size,
    super.position,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority,
  }) {
    super.labelsMap[ButtonState.hover] = hoverLabel;
  }
}
