import "dart:async";
import 'dart:ui' show PlatformDispatcher;

import 'package:flame/components.dart';
import "package:flame/game.dart";
import "package:flutter/foundation.dart" show ValueNotifier;

import "dialog_background.dart";
import "scifi_game.dart";
import "styles.dart";
import "components/advanced_button.dart";
import "research.dart";
import "data/tech.dart";

class TechButton extends AdvancedButton {
  final Research tech;
  final _title = TextComponent(
    text: "Title",
    position: Vector2(4, 4),
    textRenderer: label12,
    priority: 1,
  );
  late final ScrollTextBoxComponent _desc;

  TechButton(this.tech,
      {super.size,
      super.position,
      super.anchor,
      super.onReleased,
      super.defaultSkin,
      super.hoverSkin});

  @override
  Future<void> onLoad() {
    _title.text = tech.displayName;
    _desc = ScrollTextBoxComponent(
      size: Vector2(size.x, 56),
      text: tech.description,
      position: Vector2(0, 24),
      textRenderer: text12,
      priority: 1,
      pixelRatio: PlatformDispatcher.instance.views.first.devicePixelRatio,
    );
    addAll([
      _title,
      _desc,
    ]);
    return super.onLoad();
  }
}

class ResearchScreen extends PositionComponent with HasGameRef<ScifiGame> {
  static final bgSize = Vector2(612, 238);
  static final techBoxSize = Vector2(204, 80);

  final tab1 = TextComponent(
    text: "Engines",
    position: Vector2(8, 8),
    textRenderer: label12,
  );
  final _panelBg = RectangleComponent(
    size: bgSize,
    paintLayers: panelSkin,
  );
  final _panelBar = RectangleComponent(
    size: Vector2(bgSize.x, 32),
    paint: panelTitleBG,
  );
  final _techTitle = TextComponent(
    text: "Title",
    position: Vector2(8, 16),
    anchor: Anchor.centerLeft,
    textRenderer: label16,
  );
  final List<TechButton> _techButtons = [];
  final _costLabel = TextComponent(
    text: "Cost: 0",
    position: Vector2(8, 214),
    anchor: Anchor.centerLeft,
    textRenderer: label16,
  );
  final _cta = AdvancedButton(
    size: menuButtonSize,
    position: Vector2(
        bgSize.x - menuButtonSize.x - 8, bgSize.y - menuButtonSize.y - 8),
    defaultSkin: RectangleComponent(paint: btnDefault),
    hoverSkin: RectangleComponent(paint: btnHover),
    defaultLabel: TextComponent(
      text: 'Get',
      textRenderer: label16,
    ),
    hoverLabel: TextComponent(
      text: 'Get',
      textRenderer: label16DarkGray,
    ),
  );

  final ValueNotifier<int> _tabIdx = ValueNotifier(0);
  final ValueNotifier<String> _tid = ValueNotifier('');

  ResearchScreen({int tab = 0}) {
    _tabIdx.value = tab;
  }

  @override
  FutureOr<void> onLoad() {
    _panelBg.addAll([
      _panelBar,
      _techTitle,
    ]);

    addAll([
      _panelBg,
      tab1,
    ]);
    _updateRender();
    _tabIdx.addListener(_updateRender);
    _tid.addListener(_updateRender);

    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    _panelBg.position = Vector2(
      (size.x - bgSize.x) / 2,
      (size.y - bgSize.y) / 2,
    );
    super.onGameResize(size);
  }

  void _updateRender() {
    _techTitle.text = getTechDesc(_tabIdx.value);
    _renderTechs();
    _renderFooter();
  }

  void _renderTechs() {
    _clearTechButtons();
    final techs = techMap.values.where((t) => t.category == _tabIdx.value);

    for (int i = 0; i < techs.length; i++) {
      final tech = techs.elementAt(i);
      final row = i ~/ 3;
      final col = i % 3;
      final selected = tech.id == _tid.value;
      final techButton = TechButton(
        tech,
        size: techBoxSize,
        position: Vector2(col * (techBoxSize.x), 32 + row * (techBoxSize.y)),
        onReleased: () {
          _tid.value = tech.id;
        },
        defaultSkin: RectangleComponent(
          size: techBoxSize,
          paint: selected ? iconButtonBorderHover : iconButtonBorder,
        ),
        hoverSkin: RectangleComponent(
          size: techBoxSize,
          paint: shipBtnBgHover,
        ),
      );
      _techButtons.add(techButton);
    }

    _panelBg.addAll(_techButtons);
  }

  void _clearTechButtons() {
    for (final b in _techButtons) {
      b.removeFromParent();
    }
    _techButtons.clear();
  }

  void _renderFooter() {
    _costLabel.removeFromParent();
    _cta.removeFromParent();
    if (_tid.value.isEmpty || !techMap.containsKey(_tid.value)) {
      return;
    }
    final playerState = game.controller.getHumanPlayerState();
    if (playerState.techs.contains(_tid.value)) {
      _costLabel.text = "Researched";
      _panelBg.addAll([
        _costLabel,
      ]);
      return;
    }

    final tech = techMap[_tid.value]!;
    _costLabel.text = "Cost: ${tech.cost}";
    _cta.onReleased = () {
      game.resourceController
          .doResearch(game.controller.getHumanPlayerNumber(), tech.id);
      _updateRender();
    };
    final ctaEnabled = game.resourceController
        .canResearch(game.controller.getHumanPlayerNumber(), tech.id);
    _panelBg.addAll([
      _costLabel,
      if (ctaEnabled) _cta,
    ]);
  }
}

class ResearchOverlay extends Route with HasGameRef<ScifiGame> {
  final _researchScreen = ResearchScreen();

  ResearchOverlay() : super(null);

  @override
  Component build() {
    return DialogBackground(
      size: game.size,
      children: [
        _researchScreen,
        AdvancedButton(
          size: primarySize,
          position: Vector2(
              game.size.x - primarySize.x - 8, game.size.y - primarySize.y - 8),
          defaultLabel: TextComponent(text: "Close", textRenderer: heading20),
          hoverLabel:
              TextComponent(text: "Close", textRenderer: heading20DarkGray),
          defaultSkin: RectangleComponent(paint: btnDefault),
          hoverSkin: RectangleComponent(paint: btnHover),
          onReleased: game.controller.popAll,
        ),
      ],
    );
  }
}
