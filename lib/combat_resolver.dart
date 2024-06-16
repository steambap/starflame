import "dart:math";

import "scifi_game.dart";
import 'ship.dart';
import 'cell.dart';

class CombatResolver {
  final ScifiGame game;
  final Random rand = Random();

  CombatResolver(this.game);

  void resolve(Ship ship, Cell cell) {
    final int strengthDiff =
        ship.hull.strength - (cell.ship?.hull.strength ?? 10);
    if (ship.hull.range == 0) {
      final damage = getDamage(-strengthDiff);
      ship.takeDamage(damage);
      game.world.renderDamageText("-${damage.toString()}", ship.cell.position);
    }
    final damage = getDamage(strengthDiff);

    ship.useAttack();
    if (cell.ship != null) {
      cell.ship!.takeDamage(damage);
    } else if (cell.planet != null) {
      cell.planet!.takeDamage(damage);
    }
    game.world.renderDamageText("-${damage.toString()}", cell.position);
  }

  int getDamage(int strengthDiff) {
    final num = rand.nextInt(41) + 80;
    final ret = 30 * pow(e, 0.04 * strengthDiff) * (num / 100.0);

    return ret.floor();
  }
}
