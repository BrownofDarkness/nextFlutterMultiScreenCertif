import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:next_flutter_recipe/UI/features/list_recipes.dart';
import 'package:next_flutter_recipe/UI/features/login.dart';
import '../main.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = 'login';
  static const String recipes = 'recipes';
  static const String details = 'details';
  static const String adding = 'add-recipe';
  static const String profile = 'profile';

  AppRoutes._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    initialLocation: "/$login",
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,

    routes: [
      GoRoute(
        path: "/$login",
        name: login,
        builder: (context, state) => const LoginView(),
      ),

      GoRoute(
        path: "/$recipes",
        name: recipes,
        builder: (context, state) {
          return const ListRecipesView();
        },
        routes: [
          GoRoute(
            path: '/:id',
            name: details,
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return Center(child: Text("Recipe details for ID: $id"));
            },
          ),

          GoRoute(
            path: "/$adding",
            builder: (context, state) => Center(child: Text("Add Recipe Screen")),
          ),
        ]
      ),

      GoRoute(
        path: "/$profile",
        name: profile,
        builder: (context, state) => Center(child: Text("Profile Screen")),
      ),
    ],
  );
}