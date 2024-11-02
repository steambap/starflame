import "package:flutter/material.dart";
import "package:flame/game.dart";
import "package:flame/rendering.dart";
import 'package:flame/text.dart';

import "theme.dart";

final grayTint = PaintDecorator.tint(const Color(0x7f7f7f7f));
final textDamage = TextPaint(
    style: const TextStyle(color: red, fontSize: 16, fontFamily: "SpaceMono"));
final text12 = TextPaint(
    style: const TextStyle(color: pale, fontSize: 12, fontFamily: "SpaceMono"));
final label12 = TextPaint(
    style: const TextStyle(color: pale, fontSize: 12, fontFamily: "Chakra"));
final label12DarkGray = TextPaint(
    style:
        const TextStyle(color: darkGray, fontSize: 12, fontFamily: "Chakra"));
final label16 = TextPaint(
    style: const TextStyle(color: pale, fontSize: 16, fontFamily: "Chakra"));
final label16DarkGray = TextPaint(
    style:
        const TextStyle(color: darkGray, fontSize: 16, fontFamily: "Chakra"));
final heading20 = TextPaint(
    style: const TextStyle(color: pale, fontSize: 20, fontFamily: "Chakra"));
final heading20DarkGray = TextPaint(
    style:
        const TextStyle(color: darkGray, fontSize: 20, fontFamily: "Chakra"));
final heading24 = TextPaint(
    style: const TextStyle(color: pale, fontSize: 24, fontFamily: "Chakra"));

final hexBorderPaint = Paint()
  ..style = PaintingStyle.stroke
  ..strokeWidth = 1
  ..color = darkGray.withAlpha(128);
final highlighterPaint = Paint()..color = blue.withAlpha(128);
final moveendPaint = Paint()..color = purple.withAlpha(128);
final targetPaint = Paint()..color = red.withAlpha(128);
final emptyPaint = Paint()
  ..style = PaintingStyle.stroke
  ..color = Colors.transparent;
final fogPaint = Paint()..color = black;

final dialogBackground = Paint()..color = black.withAlpha(225);
final panelBackground = Paint()..color = black;
final panelBorder = Paint()
  ..color = darkGray
  ..style = PaintingStyle.stroke
  ..strokeWidth = 1;
final panelTitleBG = Paint()..color = darkGray;
final panelSkin = [panelBackground, panelBorder];
final iconButtonBorder = Paint()
  ..color = gray
  ..style = PaintingStyle.stroke
  ..strokeWidth = 1;
final iconButtonBorderHover = Paint()
  ..color = pale
  ..style = PaintingStyle.stroke
  ..strokeWidth = 1;

final btnDefault = Paint()..color = darkGray;
final btnHover = Paint()..color = pale;
final primarySize = Vector2(100, 48);
final secondartSize = Vector2(100, 32);
final iconButtonSize = Vector2(120, 32);
final menuButtonSize = Vector2(160, 32);
final circleIconSize = Vector2(36, 36);
const navbarHeight = 32.0;

final shipBtnSkin = [panelBackground, iconButtonBorder];
final shipBtnBgHover = Paint()..color = blue;
final shipBtnBorderHover = Paint()
  ..color = blue
  ..style = PaintingStyle.stroke
  ..strokeWidth = 1;
final shipBtnHoverSkin = [shipBtnBgHover, shipBtnBorderHover];
final shipBtnDisabledSkin = [panelTitleBG, iconButtonBorder];

final icon16red = TextPaint(
    style: const TextStyle(color: red, fontSize: 16, fontFamily: "Icon"));
final icon16yellow = TextPaint(
    style: const TextStyle(color: yellow, fontSize: 16, fontFamily: "Icon"));
final icon16blue = TextPaint(
    style: const TextStyle(color: blue, fontSize: 16, fontFamily: "Icon"));
final icon16purple = TextPaint(
    style: const TextStyle(color: purple, fontSize: 16, fontFamily: "Icon"));
final icon16pale = TextPaint(
    style: const TextStyle(color: pale, fontSize: 16, fontFamily: "Icon"));

final tabDefault = Paint()..color = gray;
final tabHover = Paint()..color = pale;

class AppTheme {
  static final dialogBackground = black.withAlpha(225);
  static final ButtonStyle menuButton = ElevatedButton.styleFrom(
    fixedSize: const Size(120, 40),
    foregroundColor: pale,
    backgroundColor: darkGray,
    padding: const EdgeInsets.all(0),
    shape: const RoundedRectangleBorder(),
  );
  static final ButtonStyle iconButton = IconButton.styleFrom(
    foregroundColor: pale,
    hoverColor: blue,
    disabledBackgroundColor: darkGray,
  );

  static final dialogTheme = DialogTheme(
    backgroundColor: panelBackground,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: const BorderSide(color: panelBorder)),
    clipBehavior: Clip.hardEdge,
  );
  static const dialogTitleBg = blue;

  static const panelBackground = black;
  static const panelBorder = darkGray;

  static const cardColor = Color(0xff373336);

  static const iconButtonColor = pale;
  static const iconButtonHoverColor = blue;

  static const addShipButtonColor = black;
  static const addShipButtonHoverColor = blue;
  static const addShipButtonDisabledColor = darkGray;
  static const addShipButtonBorder = gray;

  static const navbarHeight = 32.0;

  static const label12 = TextStyle(color: pale, fontSize: 12);
  static const label12Gray = TextStyle(color: gray, fontSize: 12);
  static const label16 = TextStyle(color: pale, fontSize: 16);
  static const label16Gray = TextStyle(color: gray, fontSize: 16);
  static const heading24 = TextStyle(color: pale, fontSize: 24);

  static const icon16red =
      TextStyle(color: red, fontSize: 16, fontFamily: "Icon");
  static const icon16yellow =
      TextStyle(color: yellow, fontSize: 16, fontFamily: "Icon");
  static const icon16blue =
      TextStyle(color: blue, fontSize: 16, fontFamily: "Icon");
  static const icon16purple =
      TextStyle(color: purple, fontSize: 16, fontFamily: "Icon");
  static const icon16pale =
      TextStyle(color: pale, fontSize: 16, fontFamily: "Icon");
  static const iconSlot =
      TextStyle(color: pale, fontSize: 48, fontFamily: "Icon");
  static const iconSlotDisabled =
      TextStyle(color: gray, fontSize: 48, fontFamily: "Icon");

  static const slotBorder = pale;
  static const slotBorderDisabled = gray;

  static const supportSlot = purple;
  static const miningSlot = red;
  static const economySlot = yellow;
  static const labSlot = blue;
  static const unoccupiedSlot = darkGray;
}
