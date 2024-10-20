import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:ocean_survival/game/ocean_survival.dart';

class Controls extends PositionComponent with HasGameRef<OceanSurvival> {
  JoystickComponent? joystick;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 30, paint: Paint()..color = Colors.white),
      background: CircleComponent(
          radius: 60, paint: Paint()..color = Colors.black.withOpacity(0.5)),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
      priority: 1,
    );
    gameRef.cam.viewport.add(joystick!);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (joystick != null) {
      gameRef.player.character.move(joystick!.delta, dt);
    }
  }
}
