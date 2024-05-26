import 'package:flame/components.dart';

import "../ship_hull.dart";

final List<ShipHull> hulls = [
  // faction 1 ?
  ShipHull(
      name: "wolf",
      life: 200,
      armor: 40,
      cost: 9,
      image: "ships/wolf.png",
      unlockedAtStart: true,
      slots: [
        ShipSlot(index: 0, itemName: "Depleted Uranium Cannon"),
        ShipSlot(index: 1, itemName: "Nuclear Engine")
      ],
      speedRange: const Block(40, 40)),
  ShipHull(
      name: "tiger",
      life: 255,
      armor: 65,
      cost: 13,
      image: "ships/tiger.png",
      unlockedAtStart: true,
      slots: [
        ShipSlot(index: 0, itemName: "Depleted Uranium Cannon"),
        ShipSlot(index: 1, itemName: "Nuclear Engine")
      ],
      speedRange: const Block(30, 40)),
  ShipHull(
      name: "panther",
      life: 220,
      armor: 50,
      cost: 15,
      image: "ships/panther.png",
      slots: [
        ShipSlot(index: 0, itemName: "Depleted Uranium Cannon"),
        ShipSlot(index: 1, itemName: "Nuclear Engine")
      ],
      speedRange: const Block(40, 50)),
  ShipHull(
      name: "lion",
      life: 300,
      armor: 80,
      cost: 1100,
      image: "ships/lion.png",
      slots: [
        ShipSlot(index: 0, itemName: "Depleted Uranium Cannon"),
        ShipSlot(index: 1, itemName: "Nuclear Engine")
      ],
      speedRange: const Block(25, 35)),
  ShipHull(
      name: "crocodile",
      life: 280,
      armor: 90,
      cost: 34,
      image: "ships/crocodile.png",
      slots: [
        ShipSlot(index: 0, itemName: "Depleted Uranium Cannon"),
        ShipSlot(index: 1, itemName: "Nuclear Engine")
      ],
      speedRange: const Block(20, 30)),
  ShipHull(
      name: "spider",
      life: 400,
      armor: 105,
      cost: 44,
      image: "ships/spider.png",
      slots: [
        ShipSlot(index: 0, itemName: "Depleted Uranium Cannon"),
        ShipSlot(index: 1, itemName: "Nuclear Engine")
      ],
      speedRange: const Block(25, 30)),
  // faction 2
  ShipHull(
      name: "mk-55",
      life: 180,
      armor: 40,
      cost: 9,
      image: "ships/mk55.png",
      unlockedAtStart: true,
      slots: [
        ShipSlot(index: 0, itemName: "Depleted Uranium Cannon"),
        ShipSlot(index: 1, itemName: "Nuclear Engine")
      ],
      speedRange: const Block(40, 40)),
  ShipHull(
      name: "mk-89",
      life: 240,
      armor: 65,
      cost: 13,
      image: "ships/mk89.png",
      unlockedAtStart: true,
      slots: [
        ShipSlot(index: 0, itemName: "Depleted Uranium Cannon"),
        ShipSlot(index: 1, itemName: "Nuclear Engine")
      ],
      speedRange: const Block(30, 40)),
  ShipHull(
      name: "ranger",
      life: 240,
      armor: 60,
      cost: 17,
      image: "ships/ranger.png",
      slots: [
        ShipSlot(index: 0, itemName: "Depleted Uranium Cannon"),
        ShipSlot(index: 1, itemName: "Nuclear Engine")
      ],
      speedRange: const Block(30, 50)),
  ShipHull(
      name: "mk-144",
      life: 320,
      armor: 90,
      cost: 25,
      image: "ships/mk144.png",
      slots: [
        ShipSlot(index: 0, itemName: "Depleted Uranium Cannon"),
        ShipSlot(index: 1, itemName: "Nuclear Engine")
      ],
      speedRange: const Block(30, 35)),
  ShipHull(
      name: "obsidian",
      life: 350,
      armor: 130,
      cost: 38,
      image: "ships/obsidian.png",
      slots: [
        ShipSlot(index: 0, itemName: "Depleted Uranium Cannon"),
        ShipSlot(index: 1, itemName: "Nuclear Engine")
      ],
      speedRange: const Block(20, 30)),
  // faction 3
  ShipHull(
      name: "grasshopper",
      life: 190,
      armor: 40,
      cost: 9,
      image: "ships/scout.png",
      unlockedAtStart: true,
      slots: [
        ShipSlot(index: 0, itemName: "Depleted Uranium Cannon"),
        ShipSlot(index: 1, itemName: "Nuclear Engine")
      ],
      speedRange: const Block(40, 40)),
  ShipHull(
      name: "mantis",
      life: 230,
      armor: 65,
      cost: 13,
      image: "ships/scout.png",
      unlockedAtStart: true,
      slots: [
        ShipSlot(index: 0, itemName: "Depleted Uranium Cannon"),
        ShipSlot(index: 1, itemName: "Nuclear Engine")
      ],
      speedRange: const Block(30, 40)),
  ShipHull(
      name: "raptor",
      life: 270,
      armor: 60,
      cost: 16,
      image: "ships/scout.png",
      slots: [
        ShipSlot(index: 0, itemName: "Depleted Uranium Cannon"),
        ShipSlot(index: 1, itemName: "Nuclear Engine")
      ],
      speedRange: const Block(35, 50)),
  ShipHull(
      name: "griffin",
      life: 260,
      armor: 55,
      cost: 30,
      image: "ships/scout.png",
      slots: [
        ShipSlot(index: 0, itemName: "Depleted Uranium Cannon"),
        ShipSlot(index: 1, itemName: "Nuclear Engine")
      ],
      speedRange: const Block(40, 40)),
  ShipHull(
      name: "pheonix",
      life: 320,
      armor: 75,
      cost: 50,
      image: "ships/scout.png",
      slots: [
        ShipSlot(index: 0, itemName: "Depleted Uranium Cannon"),
        ShipSlot(index: 1, itemName: "Nuclear Engine")
      ],
      speedRange: const Block(30, 40)),
  // neutral / pirates ?
  ShipHull(
      name: "kraken",
      life: 270,
      armor: 65,
      cost: 20,
      image: "ships/heavy_submarine.png",
      slots: [
        ShipSlot(index: 0, itemName: "Depleted Uranium Cannon"),
        ShipSlot(index: 1, itemName: "Nuclear Engine")
      ],
      speedRange: const Block(25, 35)),
];

final Map<String, ShipHull> hullMap =
    Map.fromEntries(hulls.map((hull) => MapEntry(hull.name, hull)));
