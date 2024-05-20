import 'dart:ui' show PaintingStyle, Paint, Color, Gradient, Offset;
import "package:flutter/painting.dart" show TextStyle;
import "package:flutter/material.dart" show Colors;
import "package:flame/game.dart";
import "package:flame/rendering.dart";

final grayTint = PaintDecorator.tint(const Color(0x7f7f7f7f));
final text16 = TextPaint(
    style: const TextStyle(
        color: Colors.white, fontSize: 16, fontFamily: "SpaceMono"));
final textDamage = TextPaint(
    style: const TextStyle(
        color: Colors.redAccent, fontSize: 16, fontFamily: "SpaceMono"));
final text12 = TextPaint(
    style: const TextStyle(
        color: Colors.white, fontSize: 12, fontFamily: "SpaceMono"));
final hexBorderPaint = Paint()
  ..style = PaintingStyle.stroke
  ..strokeWidth = 1
  ..color = Colors.grey.shade800;
final sectionBorderPaint = Paint()
  ..style = PaintingStyle.stroke
  ..strokeWidth = 2
  ..color = Colors.grey.shade700;
final highlighterPaint = Paint()..color = Colors.blue.withAlpha(128);
final moveendPaint = Paint()..color = Colors.purple.withAlpha(128);
final targetPaint = Paint()..color = Colors.red.withAlpha(128);
final emptyPaint = Paint()
  ..style = PaintingStyle.stroke
  ..color = Colors.transparent;
final buttonGreen = Paint()..color = Colors.green.shade800.withAlpha(221);
final buttonGreenBorder = Paint()
  ..style = PaintingStyle.stroke
  ..color = Colors.green.shade400
  ..strokeWidth = 1;
final buttonGreenHover = Paint()
  ..shader = Gradient.linear(Offset.zero, const Offset(0, 24),
      [Colors.green.shade800, Colors.green.shade400]);
final buttonGreenHoverBorder = Paint()
  ..style = PaintingStyle.stroke
  ..color = Colors.green.shade300
  ..strokeWidth = 1;

final panelBackground = Paint()..color = Colors.grey.shade900;
final panelBar = Paint()..color = Colors.grey.shade800;

final textBox = Paint()..color = Colors.blueGrey.shade900;
final textBoxBorder = Paint()
  ..style = PaintingStyle.stroke
  ..color = Colors.cyan.shade200
  ..strokeWidth = 1;

final textButton = Paint()..color = Colors.cyan.shade700;
final textButtonSelected = Paint()..color = Colors.cyan.shade500;
final textButtonDisabled = Paint()..color = Colors.grey.shade700;
final textBoxBorderDisabled = Paint()
  ..style = PaintingStyle.stroke
  ..color = Colors.grey.shade800
  ..strokeWidth = 1;
final iconButtonSize = Vector2(56, 42);

final List<Paint> buttonGreenSkin = [buttonGreen, buttonGreenBorder];
final List<Paint> buttonGreenHoverSkin = [
  buttonGreenHover,
  buttonGreenHoverBorder
];
final List<Paint> cardSkin = [textBox, textBoxBorder];
final List<Paint> textButtonPaintLayer = [textButton, textBoxBorder];
final List<Paint> textButtonSelectedSkin = [textButtonSelected, textBoxBorder];
final List<Paint> textButtonDisabledPaintLayer = [
  textButtonDisabled,
  textBoxBorderDisabled
];
