import 'dart:ui' show PaintingStyle, Paint, Color, Gradient, Offset;
import "package:flutter/painting.dart" show TextStyle;
import "package:flutter/material.dart" show Colors;
import "package:flame/game.dart";
import "package:flame/rendering.dart";

final grayTint = PaintDecorator.tint(const Color(0x7f7f7f7f));
final text16 =
    TextPaint(style: const TextStyle(color: Colors.white, fontSize: 16));
final textDamage =
    TextPaint(style: const TextStyle(color: Colors.redAccent, fontSize: 16));
final text12 =
    TextPaint(style: const TextStyle(color: Colors.white, fontSize: 12));
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
final buttonBGPaint = Paint()..color = Colors.green.shade800.withAlpha(221);
final buttonBorderPaint = Paint()
  ..style = PaintingStyle.stroke
  ..color = Colors.green.shade400
  ..strokeWidth = 1;
final buttonHoverPaint = Paint()
  ..shader = Gradient.linear(Offset.zero, const Offset(0, 24),
      [Colors.green.shade800, Colors.green.shade400]);
final buttonHoverBorderPaint = Paint()
  ..style = PaintingStyle.stroke
  ..color = Colors.green.shade300
  ..strokeWidth = 1;
final unitBGPaint = Paint()..color = Colors.blueGrey.shade700.withAlpha(221);
final unitBorderPaint = Paint()
  ..style = PaintingStyle.stroke
  ..color = Colors.blue.shade400
  ..strokeWidth = 1;
final unitBGDisabled = Paint()..color = Colors.grey.shade800.withAlpha(221);
final unitBorderDisabled = Paint()
  ..style = PaintingStyle.stroke
  ..color = Colors.grey.shade400
  ..strokeWidth = 1;

final panelBGPaint = Paint()..color = Colors.blueGrey.shade600;
final panelBorderPaint = Paint()
  ..style = PaintingStyle.stroke
  ..color = Colors.grey.shade400
  ..strokeWidth = 1;
final panelBackground = Paint()..color = Colors.grey.shade900;
final textBox = Paint()..color = Colors.blueGrey.shade900;
final textButton = Paint()..color = Colors.cyan.shade700;
final textBoxBorder = Paint()
  ..style = PaintingStyle.stroke
  ..color = Colors.cyan.shade200
  ..strokeWidth = 1;
final textButtonDisabled = Paint()..color = Colors.grey.shade700;
final textBoxBorderDisabled = Paint()
  ..style = PaintingStyle.stroke
  ..color = Colors.grey.shade800
  ..strokeWidth = 1;

final List<Paint> buttonPaintLayer = [buttonBGPaint, buttonBorderPaint];
final List<Paint> buttonHoverPaintLayer = [
  buttonHoverPaint,
  buttonHoverBorderPaint
];
final List<Paint> unitPaintLayer = [unitBGPaint, unitBorderPaint];
final List<Paint> unitDisabledPaintLayer = [unitBGDisabled, unitBorderDisabled];
final List<Paint> panelPaintLayer = [panelBGPaint, panelBorderPaint];
final List<Paint> textBoxPaintLayer = [textBox, textBoxBorder];
final List<Paint> textButtonPaintLayer = [textButton, textBoxBorder];
final List<Paint> textButtonDisabledPaintLayer = [textButtonDisabled, textBoxBorderDisabled];
