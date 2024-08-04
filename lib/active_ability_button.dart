import 'package:flame/components.dart';

import "active_ability.dart";

class ActiveAbilityButton extends AdvancedButtonComponent {
  final Ability ability;

  ActiveAbilityButton(
    this.ability, {
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
  });
}
