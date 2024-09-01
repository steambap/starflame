import "package:flame/components.dart";
import 'package:flame/game.dart';

import "scifi_game.dart";
import "styles.dart";
import "dialog_background.dart";
import "start_page.dart";
import 'components/advanced_button.dart';

class SideMenuOverlay extends Route with HasGameRef<ScifiGame> {
  SideMenuOverlay({super.transparent = false}) : super(null);

  @override
  Component build() {
    final dx = game.size.x - primarySize.x - 8;
    return DialogBackground(
        size: game.size,
        children: [
          AdvancedButton(
            size: secondartSize,
            position: Vector2(dx, 20),
            defaultLabel:
                TextComponent(text: "Continue", textRenderer: label16),
            hoverLabel:
                TextComponent(text: "Continue", textRenderer: label16DarkGray),
            defaultSkin: RectangleComponent(paint: btnDefault),
            hoverSkin: RectangleComponent(paint: btnHover),
            onReleased: () {
              game.router.popRoute(this);
            },
          ),
          AdvancedButton(
            size: secondartSize,
            position: Vector2(dx, secondartSize.y + 28),
            defaultLabel:
                TextComponent(text: "Main Menu", textRenderer: label16),
            hoverLabel:
                TextComponent(text: "Main Menu", textRenderer: label16DarkGray),
            defaultSkin: RectangleComponent(paint: btnDefault),
            hoverSkin: RectangleComponent(paint: btnHover),
            onReleased: () {
              game.router.pushNamed(StartPage.routeName);
            },
          ),
          AdvancedButton(
            size: primarySize,
            position: Vector2(dx, game.size.y - primarySize.y - 8),
            defaultLabel:
                TextComponent(text: "Next Turn", textRenderer: heading20),
            hoverLabel: TextComponent(
                text: "Next Turn", textRenderer: heading20DarkGray),
            defaultSkin: RectangleComponent(paint: btnDefault),
            hoverSkin: RectangleComponent(paint: btnHover),
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
