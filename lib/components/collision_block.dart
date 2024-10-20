import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent with CollisionCallbacks {
  final bool isPlatform;

  CollisionBlock({
    required Vector2 position,
    required Vector2 size,
    required this.isPlatform,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox(collisionType: CollisionType.passive));
    await super.onLoad();
  }
}
