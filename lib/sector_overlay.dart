import "dart:async";

import 'package:flame/components.dart';
import "package:flame/game.dart";
import "package:flutter/foundation.dart" show ValueNotifier;

import "dialog_background.dart";
import "scifi_game.dart";
import "styles.dart";
import "planet.dart";
import "planet_view.dart";
import "sector.dart";
import "components/advanced_button.dart";
import "components/tab_button.dart";

class SectorScreen extends PositionComponent with HasGameRef<ScifiGame> {
  static const planetViewWidth = 144.0;
  static const columnGapSm = 8.0;
  static const columnGapMd = 20.0;

  final Sector sector;
  final _tab0 = TabButton(
    size: Vector2(100, 48),
    position: Vector2(100, 0),
    defaultLabel: TextComponent(text: "Planets", textRenderer: label12DarkGray),
    hoverLabel: TextComponent(text: "Planets", textRenderer: label12),
  );
  final _tab1 = TabButton(
    size: Vector2(100, 48),
    position: Vector2(220, 0),
    defaultLabel: TextComponent(text: "Star", textRenderer: label12DarkGray),
    hoverLabel: TextComponent(text: "Star", textRenderer: label12),
  );
  final List<PlanetView> _planetViews = [];
  final ValueNotifier<int> _tabIdx = ValueNotifier(0);
  late final SpriteComponent _starBg;

  SectorScreen(this.sector, int tabIndex) {
    _tabIdx.value = tabIndex;
  }

  @override
  FutureOr<void> onLoad() {
    _tab0.onReleased = () {
      _tabIdx.value = 0;
    };
    _tab1.onReleased = () {
      _tabIdx.value = 1;
    };
    addAll([
      _tab0,
      _tab1,
    ]);
    final starImg = game.images.fromCache("star.png");
    _starBg = SpriteComponent(
        sprite: Sprite(starImg),
        position: game.size / 2,
        anchor: Anchor.center);

    _tabIdx.addListener(updateRender);
    updateRender();
    return super.onLoad();
  }

  void updateRender() {
    _clearPlanetViews();
    _clearStarView();
    _tab0.selected = _tabIdx.value == 0;
    _tab1.selected = _tabIdx.value == 1;

    switch (_tabIdx.value) {
      case 0:
        _updatePlanetViews();
        break;
      case 1:
        _updateStarView();
        break;
    }
  }

  void _onPlaceWorker(WorkerSlot slot, WorkerType type) {
    final playerNumber = game.controller.getHumanPlayerNumber();
    game.resourceController.placeWorker(playerNumber, sector, slot, type);
    _updatePlanetViews();
  }

  void _onSwitchWorker(WorkerSlot slot, WorkerType type) {
    final playerNumber = game.controller.getHumanPlayerNumber();
    game.resourceController.switchWorker(playerNumber, sector, slot, type);
    _updatePlanetViews();
  }

  void _clearPlanetViews() {
    for (final p in _planetViews) {
      p.removeFromParent();
    }
    _planetViews.clear();
  }

  void _updatePlanetViews() {
    final gap = game.size.x > 768 ? columnGapMd : columnGapSm;
    final len = sector.planets.length;
    final width = planetViewWidth * len + gap * (len - 1);
    final dx = (game.size.x / 2) - width / 2;
    for (int i = 0; i < sector.planets.length; i++) {
      final planet = sector.planets[i];
      final planetView = PlanetView(planet, _onPlaceWorker, _onSwitchWorker)
        ..position =
            Vector2(dx + (planetViewWidth + gap) * i, game.size.y / 2 - 102);
      _planetViews.add(planetView);
    }

    addAll(_planetViews);
  }

  void _clearStarView() {
    _starBg.removeFromParent();
  }

  void _updateStarView() {
    add(_starBg);
  }
}

class SectorOverlay extends Route with HasGameRef<ScifiGame> {
  late final SectorScreen _sectorScreen;

  SectorOverlay(Sector sector) : super(null) {
    _sectorScreen = SectorScreen(sector, 1);
  }

  @override
  Component build() {
    return DialogBackground(size: game.size, children: [
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
