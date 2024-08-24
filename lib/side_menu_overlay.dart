import "package:flame/components.dart";
import 'package:flame/game.dart';

import "../scifi_game.dart";
import "../theme.dart"
    show
        primaryBtnSkin,
        primaryBtnHover,
        heading20black,
        label16,
        btnDefaultSkin,
        btnHoverSkin;
import "../dialog_background.dart";
import "hud_bottom_right.dart";
import "./components/cut_out_rect.dart";

class SideMenuOverlay extends Route with HasGameRef<ScifiGame> {
  static final secondartSize = Vector2(108, 32);
  SideMenuOverlay({super.transparent = false}) : super(null);

  @override
  Component build() {
    final primarySize = HudBottomRight.primarySize;
    final dx = game.size.x - primarySize.x - 8;
    return DialogBackground(
        size: game.size,
        children: [
          AdvancedButtonComponent(
            size: secondartSize,
            position: Vector2(dx, 20),
            defaultLabel: TextComponent(
                text: "Continue", anchor: Anchor.center, textRenderer: label16),
            defaultSkin:
                CutOutRect(size: secondartSize, paintLayers: btnDefaultSkin),
            hoverSkin:
                CutOutRect(size: secondartSize, paintLayers: btnHoverSkin),
            onReleased: () {
              game.router.popRoute(this);
            },
          ),
          AdvancedButtonComponent(
            size: primarySize,
            position: Vector2(dx, game.size.y - primarySize.y - 28),
            defaultLabel: TextComponent(
                text: "Next Turn",
                anchor: Anchor.center,
                textRenderer: heading20black),
            defaultSkin: CutOutRect(
                size: primarySize,
                paint: primaryBtnSkin,
                cut: HudBottomRight.primaryCut),
            hoverSkin: CutOutRect(
                size: primarySize,
                paint: primaryBtnHover,
                cut: HudBottomRight.primaryCut),
            onReleased: () {
              game.router.popRoute(this);
              game.controller.playerEndTurn();
            },
          ),
        ],
        onClick: () {
          game.router.popRoute(this);
        });
  }
}
