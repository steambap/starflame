import "dart:math";

import "scifi_game.dart";
import 'ship.dart';
import 'cell.dart';

class CombatResolver {
  final ScifiGame game;
  final Random rand = Random();

  CombatResolver(this.game);

  void resolve(Ship ship, Cell cell) {
    final defender = cell.ship!;
    final dx = ship.hex.distance(cell.hex);
    if (dx > 1) {
      resolveMissileAttack(ship, defender);
      return;
    }

    final atkIni = ship.blueprint.initiative();
    final defIni = defender.blueprint.initiative();
    if (atkIni > defIni) {
      resolveCannonAttack(ship, defender);
      if (defender.state.health > 0) {
        resolveCannonAttack(defender, ship);
      }
    } else {
      resolveCannonAttack(defender, ship);
      if (ship.state.health > 0) {
        resolveCannonAttack(ship, defender);
      }
    }
  }

  void resolveCannonAttack(Ship attacker, Ship defender) {
    final int damage = getCannonDamage(attacker, defender);
    attacker.useAttack();
    defender.takeDamage(damage);
    game.world.renderDamageText("-${damage.toString()}", defender.position);
  }

  void resolveMissileAttack(Ship attacker, Ship defender) {
    final int damage = getMissileDamage(attacker, defender);
    attacker.useAttack();
    defender.takeDamage(damage);
    game.world.renderDamageText("-${damage.toString()}", defender.position);
  }

  int getShift(Ship attacker, Ship defender) {
    final result =
        attacker.blueprint.computers() - defender.blueprint.countermeasures();

    return result.clamp(-4, 4);
  }

  int getCannonDamage(Ship attacker, Ship defender) {
    final shift = getShift(attacker, defender);
    int ret = 0;
    for (final dice in attacker.blueprint.cannons()) {
      ret += max(dice + shift, 0);
    }

    return ret;
  }

  int getMissileDamage(Ship attacker, Ship defender) {
    final shift = getShift(attacker, defender);
    int ret = 0;
    for (final dice in attacker.blueprint.missiles()) {
      ret += max(dice + shift, 0);
    }

    return ret;
  }
}
