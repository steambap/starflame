import 'package:flame/components.dart';

import "../ship_hull.dart";

final List<ShipHull> hulls = [
  // faction 1 ?
  ShipHull(
      name: "wolf",
      hullSize: 120,
      life: 200,
      armor: 40,
      cost: 400,
      speedRange: const Block(40, 40)),
  ShipHull(
      name: "tiger",
      hullSize: 240,
      life: 255,
      armor: 65,
      cost: 650,
      speedRange: const Block(30, 40)),
  ShipHull(
      name: "panther",
      hullSize: 220,
      life: 220,
      armor: 50,
      cost: 700,
      speedRange: const Block(40, 50)),
  ShipHull(
      name: "jaguar",
      hullSize: 380,
      life: 270,
      armor: 65,
      cost: 800,
      speedRange: const Block(25, 35)),
  ShipHull(
      name: "lion",
      hullSize: 450,
      life: 300,
      armor: 80,
      cost: 1100,
      speedRange: const Block(25, 35)),
  ShipHull(
      name: "crocodile",
      hullSize: 600,
      life: 280,
      armor: 90,
      cost: 1000,
      speedRange: const Block(20, 30)),
  ShipHull(
      name: "spider",
      hullSize: 650,
      life: 400,
      armor: 105,
      cost: 1800,
      speedRange: const Block(25, 30)),
  // faction 2
  ShipHull(
      name: "mk-55",
      hullSize: 120,
      life: 180,
      armor: 40,
      cost: 350,
      speedRange: const Block(40, 40)),
  ShipHull(
      name: "mk-89",
      hullSize: 200,
      life: 240,
      armor: 65,
      cost: 500,
      speedRange: const Block(30, 40)),
  ShipHull(
      name: "ranger",
      hullSize: 360,
      life: 240,
      armor: 60,
      cost: 850,
      speedRange: const Block(30, 50)),
  ShipHull(
      name: "rogue",
      hullSize: 450,
      life: 270,
      armor: 70,
      cost: 1050,
      speedRange: const Block(25, 35)),
  ShipHull(
      name: "mk-144",
      hullSize: 450,
      life: 320,
      armor: 90,
      cost: 1300,
      speedRange: const Block(30, 35)),
  ShipHull(
      name: "obsidian",
      hullSize: 600,
      life: 350,
      armor: 130,
      cost: 1850,
      speedRange: const Block(20, 30)),
  // faction 3
  ShipHull(
      name: "grasshopper",
      hullSize: 120,
      life: 190,
      armor: 40,
      cost: 350,
      speedRange: const Block(40, 40)),
  ShipHull(
      name: "mantis",
      hullSize: 200,
      life: 230,
      armor: 65,
      cost: 550,
      speedRange: const Block(30, 40)),
  ShipHull(
      name: "raptor",
      hullSize: 350,
      life: 270,
      armor: 60,
      cost: 1050,
      speedRange: const Block(35, 50)),
  ShipHull(
      name: "griffin",
      hullSize: 280,
      life: 260,
      armor: 55,
      cost: 650,
      speedRange: const Block(40, 40)),
  ShipHull(
      name: "pheonix",
      hullSize: 350,
      life: 320,
      armor: 75,
      cost: 2400,
      speedRange: const Block(30, 40)),
  // neutral / pirates ?
  ShipHull(
      name: "mk-64b",
      hullSize: 190,
      life: 230,
      armor: 55,
      cost: 450,
      speedRange: const Block(30, 35)),
  ShipHull(
      name: "drake",
      hullSize: 400,
      life: 260,
      armor: 60,
      cost: 750,
      speedRange: const Block(20, 35)),
  ShipHull(
      name: "dragon",
      hullSize: 420,
      life: 280,
      armor: 85,
      cost: 1100,
      speedRange: const Block(25, 35)),
];

final Map<String, ShipHull> hullMap =
    Map.fromEntries(hulls.map((hull) => MapEntry(hull.name, hull)));
