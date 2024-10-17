import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'levels/level.dart';

class OceanSurvival extends FlameGame {
  late final CameraComponent cam;
  final level = Level();

  @override
  Future<void> onLoad() async {
    // Load all assets here
    await images.loadAllImages();
    cam = CameraComponent.withFixedResolution(
        world: level, width: 1920, height: 1076);
    cam.viewfinder.anchor = Anchor.topLeft;
    add(cam);
    add(level);
    return super.onLoad();
  }
}
