import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';

import 'scifi_game.dart';
import 'planet.dart';
import 'ship.dart';
import 'select_control.dart';
import 'styles.dart';
import 'player_state.dart';

import 'level_data/level.dart';

class MapGrid extends Component
    with HasGameReference<ScifiGame>, TapCallbacks, HasCollisionDetection {
  final List<Planet> planets = [];
  final Map<int, Planet> planetsMap = {};
  final Map<int, List<int>> connectedPlanets = {};
  final List<(Offset, Offset)> connectionDrawings = [];
  final List<Ship> ships = [];
  final List<PlayerState> playerStates = [];
  late SelectControlComponent _selectControl;

  set selectControl(SelectControlComponent s) {
    _selectControl.removeFromParent();
    _selectControl = s;
    add(_selectControl);
  }

  SelectControlComponent get selectControl => _selectControl;

  void deselect() {
    selectControl = SelectControlWaitForInput();
  }

  void start(String sceneName) {
    final levelData = levelDataTable[sceneName]!;

    for (int i = 0; i < levelData.players.length; i++) {
      final player = levelData.players[i];
      final playerState =
          PlayerState(i, player.isAI, SceneLevelData.playerColors[i]);
      playerStates.add(playerState);
      add(playerState);
    }

    for (final data in levelData.planets) {
      final planet =
          Planet(data.id, data.playerIdx, data.type, position: data.position);
      planets.add(planet);
      add(planet);
      planetsMap[data.id] = planet;
    }

    connectedPlanets.addAll(levelData.connectedPlanets);
    for (final entry in connectedPlanets.entries) {
      for (final planetId in entry.value) {
        connectionDrawings.add((
          planetsMap[entry.key]!.position.toOffset(),
          planetsMap[planetId]!.position.toOffset()
        ));
      }
    }
  }

  bool isConnected(int planetId, int otherPlanetId) {
    return connectedPlanets[planetId]?.contains(otherPlanetId) ?? false;
  }

  bool isPlanetConnected(Planet planet, Planet otherPlanet) {
    return isConnected(planet.id, otherPlanet.id);
  }

  void addShip(Ship ship) {
    ships.add(ship);
    add(ship);
  }

  PlayerState getPlayerState(int playerIdx) {
    return playerStates[playerIdx];
  }

  PlayerState getHumanPlayerState() {
    return playerStates.firstWhere((playerState) => !playerState.isAI);
  }

  void reset() {
    for (final planet in planets) {
      planet.removeFromParent();
    }
    planets.clear();
    planetsMap.clear();
    connectedPlanets.clear();
    connectionDrawings.clear();
    for (final playerState in playerStates) {
      playerState.removeFromParent();
    }
    playerStates.clear();
  }

  @override
  FutureOr<void> onLoad() {
    _selectControl = SelectControlWaitForInput();
    add(_selectControl);

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
    for (final connection in connectionDrawings) {
      canvas.drawLine(connection.$1, connection.$2, FlameTheme.connection);
    }

    super.render(canvas);
  }
}
