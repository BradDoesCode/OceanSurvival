import 'package:flame/components.dart';
import 'package:ocean_survival/player/character.dart';

class NinjaFrog extends Character {
  @override
  double get hitboxOffsetX => 10;
  @override
  double get hitboxOffsetY => 8;
  @override
  double get hitboxWidth => 14;
  @override
  double get hitboxHeight => 24;

  @override
  Future<void> loadAnimations() async {
    animations = {
      PlayerState.idle: spriteAnimator('ninja_frog', 'idle', 11),
      PlayerState.running: spriteAnimator('ninja_frog', 'run', 12),
      PlayerState.falling: spriteAnimator('ninja_frog', 'fall', 1),
      PlayerState.jumping: spriteAnimator('ninja_frog', 'jump', 1),
      PlayerState.doubleJump: spriteAnimator('ninja_frog', 'double_jump', 6),
      PlayerState.wallJump: spriteAnimator('ninja_frog', 'wall_jump', 5),
      PlayerState.hit: spriteAnimator('ninja_frog', 'hit', 7),
    };
  }

  @override
  SpriteAnimation spriteAnimator(String character, String state, int amount) {
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
