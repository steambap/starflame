import 'package:flame/components.dart';

class ShipSlot {
  final int index;
  final String itemName;

  ShipSlot({
    required this.index,
    this.itemName = '',
  });
}

class ShipHull {
  final String name;
  final int life;
  final int armor;
  final Block speedRange;
  final int cost;
  final String image;
  final bool unlockedAtStart;
  final List<ShipSlot> slots;

  ShipHull({
    required this.name,
    required this.life,
    required this.armor,
    required this.speedRange,
    required this.cost,
    required this.image,
    this.unlockedAtStart = false,
    required this.slots,
  });
}
