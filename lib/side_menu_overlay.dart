import "dart:async";

import "package:flame/components.dart";
import 'package:flame/game.dart';

import "scifi_game.dart";
import "styles.dart";
import "dialog_background.dart";
import "start_page.dart";
import 'research_overlay.dart';
import 'components/advanced_button.dart';
import 'components/row_container.dart';
import "ai/ai_log_overlay.dart";

class CommandMenu extends PositionComponent with HasGameRef<ScifiGame> {
  final _adminRow = RowContainer(
      columnSize: 120,
      columnGap: 8,
      position: Vector2(8, 24),
      size: Vector2(0, navbarHeight),
      children: [
        TextComponent(
            text: "Admin: ", textRenderer: label12),
      ]);
  final _militaryRow = RowContainer(
      columnSize: 120,
      columnGap: 8,
      position: Vector2(8, 72),
      size: Vector2(0, navbarHeight),
      children: [
        TextComponent(
            text: "Military: ", textRenderer: label12),
      ]);
  final _othersRow = RowContainer(
      columnSize: 120,
      columnGap: 8,
      position: Vector2(8, 120),
      size: Vector2(0, navbarHeight),
      children: [
        TextComponent(
            text: "Others: ", textRenderer: label12),
      ]);
  late final AdvancedButton _researchBtn;
  late final AdvancedButton _aiLogBtn;

  CommandMenu();

  @override
  FutureOr<void> onLoad() {
    _researchBtn = AdvancedButton(
      size: iconButtonSize,
      defaultLabel: TextComponent(text: "Research", textRenderer: label16),
      hoverLabel: TextComponent(text: "Research", textRenderer: label16DarkGray),
      defaultSkin: RectangleComponent(paint: btnDefault),
      hoverSkin: RectangleComponent(paint: btnHover),
      onReleased: () {
        game.router.pushRoute(ResearchOverlay());
      },
    );
    _adminRow.add(_researchBtn);
    _aiLogBtn = AdvancedButton(
      size: iconButtonSize,
      defaultLabel: TextComponent(text: "Logs", textRenderer: label16),
      hoverLabel: TextComponent(text: "Logs", textRenderer: label16DarkGray),
      defaultSkin: RectangleComponent(paint: btnDefault),
      hoverSkin: RectangleComponent(paint: btnHover),
      onReleased: () {
        game.router.pushRoute(AiLogOverlay());
      },
    );
    _othersRow.add(_aiLogBtn);

    addAll([
      _adminRow,
      _militaryRow,
      _othersRow,
    ]);
    return super.onLoad();
  }
}

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
              game.router.popRoute(this);
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
          CommandMenu(),
        ],
        onClick: () {
          game.router.popRoute(this);
        });
  }
}
