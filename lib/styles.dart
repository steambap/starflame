import "package:flutter/material.dart";
import 'package:flame/text.dart';

// radix-ui/colors
const sand3 = Color(0xFF222221);
const sand5 = Color(0xFF31312E);
const sand6 = Color(0xFF3B3A37);
const sand7 = Color(0x3CFFFBED);
const sand8 = Color(0xFF62605B);
const sand10 = Color(0xFF7C7B74);
const sand11 = Color(0xB0FFFCF4);
const sand12 = Color(0xEDFFFFFD);

const gold10 = Color(0xFFB88C67);
const gold11 = Color(0xD9FED1AA);
const orange10 = Color(0xFFFF801F);
const orange11 = Color(0xFFFFA057);
const red7 = Color(0x84FF5361);
const red11 = Color(0xFFFF9592);
const purple7 = Color(0x7AC378FD);
const purple10 = Color(0xFF9A5CD0);
const purple11 = Color(0xFFD19DFF);
const crimson10 = Color(0xFFEE518A);
const green7 = Color(0x5E50FDAC);
const amber7 = Color(0x67FFAB25);
const iris7 = Color(0x8E7777FE);

const cyan3 = Color(0xFF082C36);
const cyan4 = Color(0x3B00BAFF);
const cyan7 = Color(0x7514CDFF);
const cyan10 = Color(0xFF23AFD0);
const cyan11 = Color(0xE552E1FE);

class FlameTheme {
  static final emptyPaint = Paint()..color = Colors.transparent;
  static final labelBackground = [
    Paint()..color = sand3,
    Paint()
      ..color = sand6
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
  ];

  static final text16pale = TextPaint(
      style:
          const TextStyle(color: sand12, fontSize: 16, fontFamily: "Chakra"));
  static final textDamage = TextPaint(
      style: const TextStyle(color: red11, fontSize: 24, fontFamily: "Chakra"));
  static final heading24 = TextPaint(
      style:
          const TextStyle(color: sand12, fontSize: 24, fontFamily: "Chakra"));

  static final panelBackground = Paint()..color = sand3;
  static final panelBorder = Paint()
    ..color = sand6
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;
  static final panelSkin = [panelBackground, panelBorder];

  static final planetHabitable = Paint()..color = sand11;
  static final planetInhabitable = Paint()
    ..color = sand11
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

  static final hexBorderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = sand8;
  static final planetHighlighter = Paint()
    ..color = cyan7
    ..style = PaintingStyle.stroke
    ..strokeWidth = 6;
  static final prodProgress = Paint()
    ..color = cyan7
    ..style = PaintingStyle.stroke
    ..strokeWidth = 12;
  static final moveendPaint = Paint()..color = purple7;
  static final targetPaint = Paint()..color = red7;
  static final fogPaint = Paint()..color = sand3;
}

class AppTheme {
  static const dialogBackground = Color.fromRGBO(0, 0, 0, 0.9);
  static final ButtonStyle menuButton = ElevatedButton.styleFrom(
    fixedSize: const Size.fromWidth(128),
    foregroundColor: sand12,
    disabledForegroundColor: sand8,
    backgroundColor: cyan4,
    padding: const EdgeInsets.all(0),
    shape: const BeveledRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(6),
        bottomLeft: Radius.circular(6),
      ),
      side: BorderSide(color: sand7, width: 0.5),
    ),
  );
  static final ButtonStyle primaryButton = ElevatedButton.styleFrom(
    foregroundColor: sand12,
    disabledForegroundColor: sand8,
    backgroundColor: cyan4,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
    shape: const BeveledRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(6),
        bottomLeft: Radius.circular(6),
      ),
      side: BorderSide(color: sand7, width: 0.5),
    ),
  );
  static final ButtonStyle textButton = TextButton.styleFrom(
    foregroundColor: sand12,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
  );
  static final ButtonStyle iconButton = IconButton.styleFrom(
    foregroundColor: sand11,
    backgroundColor: cyan4,
    hoverColor: cyan3,
    disabledBackgroundColor: sand8,
    side: const BorderSide(color: sand7, width: 1),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );
  static final ButtonStyle iconButtonFilled = ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return orange10; // Color when pressed
        }
        if (states.contains(WidgetState.disabled)) {
          return sand8;
        }
        return sand3; // Default color
      },
    ),
    foregroundColor: WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return sand12; // Text color when pressed
        }
        return sand11; // Default text color
      },
    ),
  );

  static final dialogTheme = DialogThemeData(
    backgroundColor: panelBackground,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: const BorderSide(color: panelBorder)),
    clipBehavior: Clip.hardEdge,
  );
  static const tabTheme = TabBarThemeData(
    dividerHeight: 0,
    labelColor: sand12,
    unselectedLabelColor: sand8,
    indicator: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: sand8, width: 2),
      ),
    ),
  );

  static const panelBackground = sand3;
  static const panelTitle = sand5;
  static const panelBorder = sand6;
  static const panelBorderDisabled = sand8;

  static const cardColor = Color.fromRGBO(255, 255, 255, 0.1);

  static const addShipButtonColor = sand5;
  static const addShipButtonHoverColor = cyan3;
  static const addShipButtonDisabledColor = sand6;
  static const addShipButtonBorder = sand8;

  static const navbarHeight = 48.0;
  static const navbarMargin = navbarHeight + 12;
  static const navbarWidth = 240.0;

  static const label12 = TextStyle(color: sand12, fontSize: 12);
  static const label12Gray = TextStyle(color: sand8, fontSize: 12);
  static const label14 = TextStyle(color: sand12, fontSize: 14);
  static const label14Gray = TextStyle(color: sand8, fontSize: 14);
  static const label16 = TextStyle(color: sand12, fontSize: 16);
  static const label16Gray = TextStyle(color: sand8, fontSize: 16);
  static const heading24 = TextStyle(color: sand12, fontSize: 24);

  static const iconPurple = purple11;
  static const iconBlue = cyan11;
  static const iconRed = red11;
  static const iconYellow = gold11;
  static const iconPale = sand11;

  static const miningSlot = red11;
  static const economySlot = gold11;
  static const labSlot = cyan11;
  static const disabledSlot = sand6;
  static const disabledSlotBorder = sand8;
  static const unoccupiedSlot = sand6;

  static const militaryTech = crimson10;
  static const scienceTech = cyan10;
  static const industryTech = orange10;
  static const tradeTech = gold10;
  static const empireTech = purple10;
  static const techNotResearched = sand10;
  static const techBorder = sand8;

  static const progressBarColors = [
    cyan10,
    orange10,
    sand10,
  ];
}
