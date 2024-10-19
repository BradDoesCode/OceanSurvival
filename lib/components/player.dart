import 'dart:async';

import 'package:flame/components.dart';
import 'package:ocean_survival/mixins/movable.dart';
import 'package:ocean_survival/ocean_survival.dart';

enum PlayerState { idle, running, falling, jumping, doubleJump, wallJump, hit }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<OceanSurvival>, Movable {
  String character;

  Player({super.position, this.character = 'ninja_frog'});
  final stepTime = 0.05;
  late final SpriteAnimation idle;
  late final SpriteAnimation running;
  late final SpriteAnimation falling;
  late final SpriteAnimation jumping;
  late final SpriteAnimation doubleJump;
  late final SpriteAnimation wallJump;
  late final SpriteAnimation hit;

  @override
  FutureOr<void> onLoad() async {
    await _loadAnimations();
    debugMode = true;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    current = _updatePlayerState();
    _flipPlayer();
    super.update(dt);
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
    current = PlayerState.idle;
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

  bool isMoving() {
    return gameRef.joystick.delta.length > 0;
  }

  PlayerState _updatePlayerState() {
    if (isMoving()) {
      return PlayerState.running;
    }
    return PlayerState.idle;
  }

  void _flipPlayer() {
    if (gameRef.joystick.delta.x < 0 && isFacingRight) {
      flipHorizontallyAroundCenter();
      isFacingRight = false;
    } else if (gameRef.joystick.delta.x > 0 && !isFacingRight) {
      flipHorizontallyAroundCenter();
      isFacingRight = true;
    }
  }
}
