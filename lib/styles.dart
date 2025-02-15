import "package:flutter/material.dart";
import 'package:flame/text.dart';

import "theme.dart";

const navbarHeight = 32.0;

class FlameTheme {
  static final emptyPaint = Paint()..color = Colors.transparent;
  static final labelBackground = [
    Paint()..color = black,
    Paint()
      ..color = darkGray
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
  ];

  static final text10pale = TextPaint(
      style:
          const TextStyle(color: pale, fontSize: 10, fontFamily: "SpaceMono"));
  static final textDamage = TextPaint(
      style:
          const TextStyle(color: red, fontSize: 16, fontFamily: "SpaceMono"));
  static final heading24 = TextPaint(
      style: const TextStyle(color: pale, fontSize: 24, fontFamily: "Chakra"));

  static final panelBackground = Paint()..color = black;
  static final panelBorder = Paint()
    ..color = darkGray
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;
  static final panelSkin = [panelBackground, panelBorder];

  static final planetColonizable = [Paint()..color = pale];
  static final planetUncolonizable = [
    Paint()
      ..color = gray
      ..style = PaintingStyle.stroke
  ];

  static final hexBorderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = darkGray.withAlpha(128);
  static final highlighterPaint = Paint()..color = blue.withAlpha(128);
  static final moveendPaint = Paint()..color = purple.withAlpha(128);
  static final targetPaint = Paint()..color = red.withAlpha(128);
  static final fogPaint = Paint()..color = black;
}

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
  static const tabTheme = TabBarTheme(
    dividerHeight: 0,
    labelColor: pale,
    unselectedLabelColor: gray,
    indicator: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: pale, width: 2),
      ),
    ),
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

  static const iconPurple = purple;
  static const iconBlue = blue;
  static const iconRed = red;
  static const iconYellow = yellow;
  static const iconPale = pale;

  static const miningSlot = red;
  static const economySlot = yellow;
  static const labSlot = blue;
  static const disabledSlot = darkGray;
  static const disabledSlotBorder = gray;
  static const unoccupiedSlot = darkGray;

  static const militaryTech = red;
  static const scienceTech = blue;
  static const industryTech = orange;
  static const tradeTech = yellow;
  static const empireTech = purple;
  static const techNotResearched = darkGray;
  static const techBorder = gray;
}
