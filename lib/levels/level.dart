import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:ocean_survival/actors/player.dart';

class Level extends World {
  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    //TODO: Create a very simple level in tiled and save it in the assets folder
    level = await TiledComponent.load('level-01.tmx', Vector2.all(16.0));
    add(level);
    add(Player());
    return super.onLoad();
  }
}
