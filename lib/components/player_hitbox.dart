import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

class PlayerHitbox extends PositionComponent {
  final double offsetX;

  final double offsetY;
  @override
  final double width;

  @override
  final double height;

  PlayerHitbox({
    required this.offsetX,
    required this.offsetY,
    required this.width,
    required this.height,
  });
}
