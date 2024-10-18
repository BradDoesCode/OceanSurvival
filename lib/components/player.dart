import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:ocean_survival/components/collision_block.dart';
import 'package:ocean_survival/components/utils.dart';
import 'package:ocean_survival/ocean_survival.dart';

enum PlayerState { idle, running, falling, jumping, doubleJump, wallJump, hit }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<OceanSurvival>, KeyboardHandler {
  String character;

  Player({super.position, this.character = 'ninja_frog'});

  late final SpriteAnimation idle;
  late final SpriteAnimation running;
  late final SpriteAnimation falling;
  late final SpriteAnimation jumping;
  late final SpriteAnimation doubleJump;
  late final SpriteAnimation wallJump;
  late final SpriteAnimation hit;

  final double _gravity = 9.8;
  final double jumpForce = 100;
  final double terminalVelocity = 300;
  double stepTime = 0.05;
  double horizontalMovement = 0;
  double verticalMovement = 0;
  double speed = 100;
  bool inWater = false;
  bool hasJumped = false;
  // veocity used to upgrade the speed of the player
  Vector2 velocity = Vector2.zero();
  bool isStanding = true;
  bool isOnGround = false;
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    await _loadAnimations();
    debugMode = true;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerState();
    _updatePlayerMovement(dt);
    _checkHorizontalColl();
    if (!inWater) _applyGravity(dt);
    _checkVerticalColl();
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    verticalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowRight);
    final isUpKeyPressed = keysPressed.contains(LogicalKeyboardKey.arrowUp);
    final isDownKeyPressed = keysPressed.contains(LogicalKeyboardKey.arrowDown);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;
    verticalMovement += isUpKeyPressed ? -1 : 0;
    verticalMovement += isDownKeyPressed ? 1 : 0;
    hasJumped = keysPressed.contains(LogicalKeyboardKey.space);
    //this seems inverted on a mobile emulator that is rotated.
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



  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;
    if (velocity.y > _gravity && !isOnGround) {
      playerState = PlayerState.falling;
    }
    if (velocity.y < 0) {
      playerState = PlayerState.jumping;
    }
    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    // Check for horizontal movement
    if ((velocity.x > 0 || velocity.x < 0) && velocity.y == 0) {
      // If moving left or right and not moving down, face up
      if (scale.y < 0) {
        flipVerticallyAroundCenter();
      }
    }

    // If moving the player should be set to swim
    if (velocity.x != 0 || velocity.y != 0) {
      playerState = PlayerState.running;
      // Add when we have a swim animation
      // playerState = PlayerState.swimming;
    }
    current = playerState;
  }

  void _updatePlayerMovement(double dt) {
    if (hasJumped && isOnGround) {
      velocity.y = -jumpForce;
      isOnGround = false;
      hasJumped = false;
    }

    velocity.x = horizontalMovement * speed;
    velocity.y = verticalMovement * speed;
    //velocity = Vector2(directionX, directionY);
    position.x += velocity.x * dt;
    position.y += velocity.y * dt;
  }

  void _checkHorizontalColl() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - width;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + width;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity * dt;
    velocity.y = velocity.y.clamp(jumpForce, terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalColl() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - height;
            isOnGround = true;
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - height;
            isOnGround = true;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height;
          }
        }
      }
    }
  }
}
