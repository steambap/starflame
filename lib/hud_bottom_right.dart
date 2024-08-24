import 'dart:async';
import 'dart:ui';
import 'package:flutter/painting.dart' show BorderRadius;
import 'package:flame/components.dart';

import 'scifi_game.dart';
import "theme.dart"
    show
        heading20black,
        btnDefaultSkin,
        btnHoverSkin,
        btnSelectedSkin,
        btnHoverAndSelectedSkin,
        blue,
        primaryBtnSkin,
        primaryBtnHover,
        icon16white;
import "./components/cut_out_rect.dart";
import "side_menu_overlay.dart";

class HudBottomRight extends PositionComponent with HasGameRef<ScifiGame> {
  static final primarySize = Vector2(108, 48);
  static final lineSkin = Paint()
    ..color = blue
    ..strokeWidth = 1.5;
  static const primaryCut = BorderRadius.only(
      bottomLeft: Radius.circular(8), topRight: Radius.circular(8));
  static const topRightCut = BorderRadius.only(topRight: Radius.circular(8));
  static const bottomLeftCut =
      BorderRadius.only(bottomLeft: Radius.circular(8));
  static const double marginX = 20;
  static final iconButtonSize = Vector2(36, 36);

  final _primaryButton = AdvancedButtonComponent(
    size: primarySize,
    defaultLabel: TextComponent(
        text: "MENU", anchor: Anchor.center, textRenderer: heading20black),
    defaultSkin:
        CutOutRect(size: primarySize, paint: primaryBtnSkin, cut: primaryCut),
    hoverSkin:
        CutOutRect(size: primarySize, paint: primaryBtnHover, cut: primaryCut),
  );
  final List<Offset> _line = List.filled(4, Offset.zero, growable: false);
  final _deployIcon = TextComponent(text: "\u4626", textRenderer: icon16white);
  late final ToggleButtonComponent _shipDeploy;

  @override
  FutureOr<void> onLoad() {
    _primaryButton.onReleased = () {
      game.router.pushRoute(SideMenuOverlay());
    };
    _shipDeploy = ToggleButtonComponent(
      size: iconButtonSize,
      defaultLabel: _deployIcon,
      defaultSelectedLabel: _deployIcon,
      defaultSkin: CutOutRect(
        size: iconButtonSize,
        cut: bottomLeftCut,
        paintLayers: btnDefaultSkin,
      ),
      hoverSkin: CutOutRect(
        size: iconButtonSize,
        cut: bottomLeftCut,
        paintLayers: btnHoverSkin,
      ),
      defaultSelectedSkin: CutOutRect(
        size: iconButtonSize,
        cut: bottomLeftCut,
        paintLayers: btnSelectedSkin,
      ),
      hoverAndSelectedSkin: CutOutRect(
        size: iconButtonSize,
        cut: bottomLeftCut,
        paintLayers: btnHoverAndSelectedSkin,
      ),
      onSelectedChanged: (value) {
        if (value) {
          game.hudMapDeploy.renderShipButtons();
        } else {
          game.hudMapDeploy.clearShipButtons();
        }
      },
    );

    addAll([_primaryButton, _shipDeploy]);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _primaryButton.position =
        Vector2(size.x - primarySize.x - 8, size.y - primarySize.y - 28);
    _line[0] = Offset(_primaryButton.position.x - marginX, size.y - 28);
    _line[1] = Offset(_primaryButton.position.x, size.y - 28);
    _line[2] = Offset(_primaryButton.position.x + 8, size.y - 20);
    _line[3] = Offset(size.x, size.y - 20);
    _shipDeploy.position = Vector2(
        _primaryButton.position.x - marginX - iconButtonSize.x,
        size.y - iconButtonSize.y - 8);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawLine(_line[0], _line[1], lineSkin);
    canvas.drawLine(_line[1], _line[2], lineSkin);
    canvas.drawLine(_line[2], _line[3], lineSkin);
    super.render(canvas);
  }

  void minimize() {
    _shipDeploy.isSelected = false;
  }
}
