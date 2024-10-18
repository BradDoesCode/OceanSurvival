import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:ocean_survival/ocean_survival.dart';

enum PlayerState { idle, running, falling, jumping, doubleJump, wallJump, hit }

enum PlayerDirection { left, right, up, down, none }

class Player extends SpriteAnimationGroupComponent with HasGameRef<OceanSurvival>, KeyboardHandler {
  String character;
  Player({super.position, this.character = 'ninja_frog'});

  late final SpriteAnimation idle;
  late final SpriteAnimation running;
  late final SpriteAnimation falling;
  late final SpriteAnimation jumping;
  late final SpriteAnimation doubleJump;
  late final SpriteAnimation wallJump;
  late final SpriteAnimation hit;

  PlayerDirection direction = PlayerDirection.none;
  double stepTime = 0.05;
  double speed = 100;
  // veocity used to upgrade the speed of the player
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;
  bool isStanding = true;
  @override
  FutureOr<void> onLoad() async {
    await _loadAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.arrowLeft) || keysPressed.contains(LogicalKeyboardKey.keyA);
    final isRightKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowRight) || keysPressed.contains(LogicalKeyboardKey.keyD);
    final isUpKeyPressed = keysPressed.contains(LogicalKeyboardKey.arrowUp) || keysPressed.contains(LogicalKeyboardKey.keyW);
    final isDownKeyPressed = keysPressed.contains(LogicalKeyboardKey.arrowDown) || keysPressed.contains(LogicalKeyboardKey.keyS);

    if (isLeftKeyPressed && !isRightKeyPressed) {
      direction = PlayerDirection.left;
    } else if (isRightKeyPressed && !isLeftKeyPressed) {
      direction = PlayerDirection.right;
    } else if (isUpKeyPressed && !isDownKeyPressed) {
      direction = PlayerDirection.up;
    } else if (isDownKeyPressed && !isUpKeyPressed) {
      direction = PlayerDirection.down;
    } else {
      direction = PlayerDirection.none;
    }
    return super.onKeyEvent(event, keysPressed);
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

  void _updatePlayerMovement(double dt) {
    double directionX = 0.0;
    double directionY = 0.0;
    switch (direction) {
      case PlayerDirection.left:
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        current = PlayerState.running;
        directionX -= speed;
        break;
      case PlayerDirection.right:
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        current = PlayerState.running;
        directionX += speed;
        break;
      case PlayerDirection.up:
        if (!isStanding) {
          flipVerticallyAroundCenter();
          isStanding = true;
        }
        current = PlayerState.running;
        directionY -= speed;
        break;
      case PlayerDirection.down:
        if (isStanding) {
          flipVerticallyAroundCenter();
          isStanding = false;
        }
        current = PlayerState.running;
        directionY += speed;
        break;
      case PlayerDirection.none:
        current = PlayerState.idle;
        break;
    }
    velocity = Vector2(directionX, directionY);
    position += velocity * dt;
  }
}
