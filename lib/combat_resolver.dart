import "dart:math";

import "scifi_game.dart";
import 'ship.dart';
import 'ship_blueprint.dart';
import 'cell.dart';

class CombatResolver {
  final ScifiGame game;
  final Random rand = Random();

  CombatResolver(this.game);

  void resolve(Ship ship, Cell cell) {
    final defender = cell.ship!;
    final dx = ship.hex.distance(cell.hex);
    if (dx > 1) {
      resolveRangedAttack(ship, defender);
      return;
    }

    resolveMeleeAttack(ship, defender);
  }

  void resolveMeleeAttack(Ship attacker, Ship defender) {
    final strRatio = attacker.strength() / defender.strength();
    final num = (rand.nextInt(11) + 20) / 100;
    final attackerBonus =
        1 + (getBonus(attacker, defender).clamp(-10, 10) / 12.0);
    final defenderBonus =
        1 + (getBonus(defender, attacker).clamp(-10, 10) / 12.0);
    final int defenderDamage =
        (strRatio * attacker.state.health * attackerBonus * num).toInt();
    final int attackerDamage =
        ((1 / strRatio) * defender.state.health * defenderBonus * num).toInt();
    attacker.useAttack();
    defender.takeDamage(defenderDamage);
    game.world
        .renderDamageText("-${defenderDamage.toString()}", defender.position);
    attacker.takeDamage(attackerDamage);
    game.world
        .renderDamageText("-${attackerDamage.toString()}", attacker.position);
  }

  void resolveRangedAttack(Ship attacker, Ship defender) {
    final strRatio = attacker.rangedStrength() / defender.strength();
    final num = (rand.nextInt(11) + 20) / 100;
    final bonus = 1 + (getBonus(attacker, defender).clamp(-10, 10) * 100 / 12);
    final int damage =
        (strRatio * attacker.state.health * bonus * num * 0.5).toInt();
    attacker.useAttack();
    defender.takeDamage(damage);
    game.world.renderDamageText("-${damage.toString()}", defender.position);
  }

  int getBonus(Ship attacker, Ship defender) {
    int ret = 0;
    if (attacker.blueprint.type == ShipType.destroyer &&
        defender.blueprint.type == ShipType.carrier) {
      ret += 3;
    } else if (attacker.blueprint.type == ShipType.carrier &&
        defender.blueprint.type == ShipType.dreadnought) {
      ret += 3;
    } else if (attacker.blueprint.type == ShipType.dreadnought &&
        defender.blueprint.type == ShipType.destroyer) {
      ret += 3;
    }

    if (attacker.state.playerNumber == game.controller.getHumanPlayerNumber()) {
      ret += 6;
    } else if (defender.state.playerNumber ==
        game.controller.getHumanPlayerNumber()) {
      ret -= 6;
    }

    return ret;
  }
}
