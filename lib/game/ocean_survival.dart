import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:ocean_survival/game/controls.dart';
import 'package:ocean_survival/player/ninja_frog.dart';
import 'package:ocean_survival/player/player.dart';

import '../components/level.dart';

class OceanSurvival extends FlameGame
    with DragCallbacks, HasCollisionDetection {
  late final CameraComponent cam;
  Controls controls = Controls();
  Player player = Player(character: NinjaFrog());
  bool showJoystick = true;

  @override
  backgroundColor() => const Color.fromARGB(255, 86, 86, 240);

  @override
  Future<void> onLoad() async {
    // Load all assets here
    await images.loadAllImages();
    print('All images loaded');
    final level = Level(name: 'level-01.tmx', player: player);
    cam = CameraComponent.withFixedResolution(
        world: level, width: 640, height: 360);
    cam.viewfinder.anchor = Anchor.center;
    await addAll([cam, level, controls]);
    debugMode = kDebugMode;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    cam.viewfinder.position = player.character.isFacingRight
        ? Vector2(player.character.position.x + (player.character.width / 2),
            player.character.position.y)
        : Vector2(player.character.position.x - (player.character.width / 2),
            player.character.position.y);

    super.update(dt);
  }
}
