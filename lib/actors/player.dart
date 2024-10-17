import 'dart:async';

import 'package:flame/components.dart';
import 'package:ocean_survival/ocean_survival.dart';

enum PlayerState { idle, running }

class Player extends SpriteAnimationGroupComponent with HasGameRef<OceanSurvival> {
  late final SpriteAnimation idle;
  final double stepTime = 0.05;

  @override
  FutureOr<void> onLoad() async {
    await _loadAnimations();
    return super.onLoad();
  }

  Future<void> _loadAnimations() async {
    idle = SpriteAnimation.fromFrameData(
      game.images.fromCache('main_characters/ninja_frog/idle.png'),
      SpriteAnimationData.sequenced(
        amount: 11,
        stepTime: stepTime,
        textureSize: Vector2.all(132),
      ),
    );

    // list of all animations
    animations = {
      PlayerState.idle: idle,
    };

    // set the default animation
    current = PlayerState.idle;
  }
}
