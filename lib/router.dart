// Copyright 2023, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ocean_survival/ocean_survival.dart';
import 'package:provider/provider.dart';

import 'game_internals/score.dart';
import 'level_selection/level_selection_screen.dart';
import 'level_selection/levels.dart';
import 'main_menu/main_menu_screen.dart';
import 'settings/settings_screen.dart';
import 'style/my_transition.dart';
import 'style/palette.dart';
import 'win_game/win_game_screen.dart';

/// The router describes the game's navigational hierarchy, from the main
/// screen through settings screens all the way to each individual level.
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainMenuScreen(key: Key('main menu')),
      routes: [
        GoRoute(
            path: 'play',
            pageBuilder: (context, state) => buildMyTransition<void>(
                  key: const ValueKey('play'),
                  color: context.watch<Palette>().backgroundLevelSelection,
                  child: const LevelSelectionScreen(
                    key: Key('level selection'),
                  ),
                ),
            routes: [
              GoRoute(
                path: 'session/:level',
                pageBuilder: (context, state) {
                  final levelNumber = int.parse(state.pathParameters['level']!);
                  final game = OceanSurvival();
                  final level = gameLevels.singleWhere((e) => e.number == levelNumber);
                  return MaterialPage(
                    key: state.pageKey,
                    child: GameWidget(game: (kDebugMode) ? OceanSurvival() : game),
                  );
                },
              ),
              GoRoute(
                path: 'won',
                redirect: (context, state) {
                  if (state.extra == null) {
                    // Trying to navigate to a win screen without any data.
                    // Possibly by using the browser's back button.
                    return '/';
                  }

                  // Otherwise, do not redirect.
                  return null;
                },
                pageBuilder: (context, state) {
                  final map = state.extra! as Map<String, dynamic>;
                  final score = map['score'] as Score;

                  return buildMyTransition<void>(
                    key: const ValueKey('won'),
                    color: context.watch<Palette>().backgroundPlaySession,
                    child: WinGameScreen(
                      score: score,
                      key: const Key('win game'),
                    ),
                  );
                },
              )
            ]),
        GoRoute(
          path: 'settings',
          builder: (context, state) => const SettingsScreen(key: Key('settings')),
        ),
      ],
    ),
  ],
);
