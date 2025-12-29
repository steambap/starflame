import 'dart:async';
import 'package:flutter/material.dart' show Colors;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';

import 'scifi_game.dart';
import 'cell.dart';
import "hex.dart";
import 'planet.dart';
import 'ship.dart';
import 'select_control.dart';
import 'styles.dart';
import 'player_state.dart';
import 'game_settings.dart';
import 'game_creator.dart';

class MapGrid extends Component
    with HasGameReference<ScifiGame>, TapCallbacks, HasCollisionDetection {
      static const playerColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.brown,
    Colors.cyan,
  ];

  final List<Planet> planets = [];
  final Map<int, Planet> planetsMap = {};

  final List<Ship> ships = [];
  final List<PlayerState> playerStates = [];
  final fogLayer = PositionComponent(priority: 3);

  int _humanPlayerIdx = 0;
  List<Cell> cells = List.empty();
  late SelectControlComponent _selectControl;
  late final corners = Hex.zero
      .polygonCorners()
      .map((e) => e.toOffset())
      .toList(growable: false);

  set selectControl(SelectControlComponent s) {
    _selectControl.removeFromParent();
    _selectControl = s;
    add(_selectControl);
  }

  SelectControlComponent get selectControl => _selectControl;

  void deselect() {
    selectControl = SelectControlWaitForInput();
  }

  void start(GameSettings gameSettings, GameCreator gameCreator) {
    for (int i = 0; i < gameSettings.players.length; i++) {
      final player = gameSettings.players[i];
      if (!player.isAI) {
        _humanPlayerIdx = i;
      }
      final playerState =
          PlayerState(i, player.isAI, playerColors[i]);
      playerStates.add(playerState);
      add(playerState);
    }

    cells = gameCreator.cells;
    addAll(cells);
  }

  void addShip(Ship ship) {
    ships.add(ship);
    add(ship);
  }

  PlayerState getPlayerState(int playerIdx) {
    return playerStates[playerIdx];
  }

  PlayerState getHumanPlayerState() {
    return getPlayerState(_humanPlayerIdx);
  }

  void reset() {
    for (final planet in planets) {
      planet.removeFromParent();
    }
    planets.clear();
    planetsMap.clear();

    for (final playerState in playerStates) {
      playerState.removeFromParent();
    }
    playerStates.clear();
  }

  @override
  FutureOr<void> onLoad() {
    _selectControl = SelectControlWaitForInput();
    add(_selectControl);
    add(fogLayer);

    return super.onLoad();
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    return true;
  }

  @override
  void onTapUp(TapUpEvent event) {
    bool found = false;
    for (final planet in planets) {
      if (planet.position.distanceTo(event.localPosition) <= Planet.radius) {
        selectControl.onPlanetClick(planet);
        found = true;
        break;
      }
    }

    if (!found) {
      selectControl = SelectControlWaitForInput();
    }

    super.onTapUp(event);
  }

  @override
  void render(Canvas canvas) {
    for (final cell in cells) {
      canvas.renderAt(cell.position, (myCanvas) {
        final ns = cell.hex.getNeighbours();
        for (int i = 0; i < ns.length; i++) {
          canvas.drawLine(corners[(11 - i) % 6], corners[(12 - i) % 6],
              FlameTheme.hexBorderPaint);
        }
      });
    }

    super.render(canvas);
  }
}
