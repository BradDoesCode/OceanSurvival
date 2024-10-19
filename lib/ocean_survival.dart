import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:ocean_survival/components/player.dart';

import 'components/level.dart';

class OceanSurvival extends FlameGame with DragCallbacks {
  late final CameraComponent cam;
  late JoystickComponent joystick;
  Player player = Player();
  bool showJoystick = true;

  @override
  backgroundColor() => const Color.fromARGB(255, 86, 86, 240);

  @override
  Future<void> onLoad() async {
    // Load all assets here
    await images.loadAllImages();
    final level = Level(name: 'level-01.tmx', player: player);
    cam = CameraComponent.withFixedResolution(
        world: level, width: 640, height: 360);
    cam.viewfinder.anchor = Anchor.center;
    addAll([cam, level]);
    if (showJoystick) {
      joystick = addJoystick();
      cam.viewport.add(joystick);
    }
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) updateJoystickDirection(joystick, player, dt);
    // follow the player
    cam.viewfinder.position = player.position;

    super.update(dt);
  }

  JoystickComponent addJoystick() {
    return JoystickComponent(
      knob: SpriteComponent.fromImage(images.fromCache('hud/knob.png')),
      background:
          SpriteComponent.fromImage(images.fromCache('hud/joystick.png')),
      margin: EdgeInsets.only(left: 32, bottom: 32),
      priority: 1,
    );
  }

  void updateJoystickDirection(
      JoystickComponent joystick, Player player, double dt) {
    final double inputX = joystick.delta.x;
    final double inputY = joystick.delta.y;
    final double x = inputX * player.speed * dt;
    final double y = inputY * player.speed * dt;
    player.move(Vector2(x, y), dt);
  }
}
