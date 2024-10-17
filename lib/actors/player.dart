import 'dart:async';

import 'package:flame/components.dart';
import 'package:ocean_survival/ocean_survival.dart';

enum PlayerState { idle, running, falling, jumping, doubleJump, wallJump, hit }

class Player extends SpriteAnimationGroupComponent with HasGameRef<OceanSurvival> {
  String character;
  Player({super.position, required this.character});

  late final SpriteAnimation idle;
  late final SpriteAnimation running;
  late final SpriteAnimation falling;
  late final SpriteAnimation jumping;
  late final SpriteAnimation doubleJump;
  late final SpriteAnimation wallJump;
  late final SpriteAnimation hit;

  double stepTime = 0.05;

  @override
  FutureOr<void> onLoad() async {
    await _loadAnimations();
    return super.onLoad();
  }

  Future<void> _loadAnimations() async {
    idle = _spriteAnimator('idle', 11);
    running = _spriteAnimator('run', 12);
    falling = _spriteAnimator('fall', 1);
    jumping = _spriteAnimator('jump', 1);
    doubleJump = _spriteAnimator('double_jump', 6);
    wallJump = _spriteAnimator('wall_jump', 5);
    hit = _spriteAnimator('hit', 7);

    // list of all animations
    animations = {
      PlayerState.idle: idle,
      PlayerState.running: running,
      PlayerState.falling: falling,
      PlayerState.jumping: jumping,
      PlayerState.doubleJump: doubleJump,
      PlayerState.wallJump: wallJump,
      PlayerState.hit: hit,
    };

    // set the default animation
    current = PlayerState.doubleJump;
  }

  SpriteAnimation _spriteAnimator(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('main_characters/$character/$state.png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }
}
