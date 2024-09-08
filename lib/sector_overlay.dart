import "dart:async";

import 'package:flame/components.dart';
import "package:flame/game.dart";

import "dialog_background.dart";
import "scifi_game.dart";
import "styles.dart";
import "hud_player_info.dart";
import "planet.dart";
import "planet_view.dart";
import "sector.dart";
import "components/advanced_button.dart";

class SectorScreen extends PositionComponent with HasGameRef<ScifiGame> {
  static const planetViewWidth = 144.0;
  static const columnGapSm = 8.0;
  static const columnGapMd = 20.0;

  final Sector sector;
  final tab1 = TextComponent(
    text: "Planets",
    position: Vector2(204, 4 + navbarHeight),
    textRenderer: label12,
  );
  final List<PlanetView> _planetViews = [];

  SectorScreen(this.sector);

  @override
  FutureOr<void> onLoad() {
    addAll([
      tab1,
    ]);
    _updatePlanetViews();
    return super.onLoad();
  }

  _onPlaceWorker(WorkerSlot slot, WorkerType type) {
    final playerNumber = game.controller.getHumanPlayerNumber();
    game.resourceController.placeWorker(playerNumber, sector, slot, type);
    _updatePlanetViews();
  }

  _onSwitchWorker(WorkerSlot slot, WorkerType type) {
    final playerNumber = game.controller.getHumanPlayerNumber();
    game.resourceController.switchWorker(playerNumber, sector, slot, type);
    _updatePlanetViews();
  }

  _updatePlanetViews() {
    // Remove previous
    for (final p in _planetViews) {
      p.removeFromParent();
    }
    _planetViews.clear();

    final gap = game.size.x > 768 ? columnGapMd : columnGapSm;
    final len = sector.planets.length;
    final width = planetViewWidth * len + gap * (len - 1);
    final dx = (game.size.x / 2) - width / 2;
    for (int i = 0; i < sector.planets.length; i++) {
      final planet = sector.planets[i];
      final planetView = PlanetView(planet, _onPlaceWorker, _onSwitchWorker)
        ..position = Vector2(dx + (planetViewWidth + gap) * i, game.size.y / 2 - 102);
      _planetViews.add(planetView);
    }

    addAll(_planetViews);
  }
}

class SectorOverlay extends Route with HasGameRef<ScifiGame> {
  final _playerInfo = HudPlayerInfo();
  late final SectorScreen _sectorScreen;

  SectorOverlay(Sector sector) : super(null) {
    _sectorScreen = SectorScreen(sector);
  }

  @override
  Component build() {
    return DialogBackground(size: game.size, children: [
      _playerInfo,
      _sectorScreen,
      AdvancedButton(
        size: primarySize,
        position: Vector2(
            game.size.x - primarySize.x - 8, game.size.y - primarySize.y - 8),
        defaultLabel: TextComponent(text: "Close", textRenderer: heading20),
        hoverLabel:
            TextComponent(text: "Close", textRenderer: heading20DarkGray),
        defaultSkin: RectangleComponent(paint: btnDefault),
        hoverSkin: RectangleComponent(paint: btnHover),
        onReleased: () {
          game.router.popRoute(this);
        },
      ),
    ]);
  }
}
