import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:ocean_survival/actors/player.dart';

import 'levels/level.dart';

class OceanSurvival extends FlameGame with HasKeyboardHandlerComponents, DragCallbacks {
  late final CameraComponent cam;
  late JoystickComponent joystick;
  Player player = Player();
  bool showJoystick = true;

  @override
  Future<void> onLoad() async {
    // Load all assets here
    await images.loadAllImages();
    final level = Level(name: 'level-01.tmx', player: player);
    cam = CameraComponent.withFixedResolution(world: level, width: 640, height: 360);
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([cam, level]);
    if (showJoystick) addJoystick();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) updateJoystickDirection(joystick, player);
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent.fromImage(images.fromCache('hud/knob.png')),
      background: SpriteComponent.fromImage(images.fromCache('hud/joystick.png')),
      margin: EdgeInsets.only(left: 32, bottom: 32),
      priority: 1,
    );
    add(joystick);
  }

  void updateJoystickDirection(JoystickComponent joystick, Player player) {
    switch (joystick.direction) {
      case JoystickDirection.up:
        player.direction = PlayerDirection.up;
        break;
      case JoystickDirection.upLeft:
        player.direction = PlayerDirection.up;
        break;
      case JoystickDirection.upRight:
        player.direction = PlayerDirection.up;
        break;
      case JoystickDirection.downLeft:
        player.direction = PlayerDirection.down;
        break;
      case JoystickDirection.downRight:
        player.direction = PlayerDirection.down;
        break;
      case JoystickDirection.down:
        player.direction = PlayerDirection.down;
        break;
      case JoystickDirection.left:
        player.direction = PlayerDirection.left;
        break;
      case JoystickDirection.right:
        player.direction = PlayerDirection.right;
        break;
      case JoystickDirection.idle:
        player.direction = PlayerDirection.none;

        break;
    }
  }
}
