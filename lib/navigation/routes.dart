import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../UI/features/add_recipe.dart';
import '../UI/features/list_recipes.dart';
import '../UI/features/login.dart';
import '../UI/features/profile.dart';
import '../UI/features/recipe_details.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = 'login';
  static const String recipes = 'recipes';
  static const String details = 'details';
  static const String adding = 'add-recipe';
  static const String profile = 'profile';

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: '/login',
        name: login,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/recipes',
        name: recipes,
        builder: (context, state) => const ListRecipesView(),
        routes: [
          GoRoute(
            path: ':id',
            name: details,
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return RecipeDetailsView(recipeId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/add-recipe',
        name: adding,
        builder: (context, state) => const AddRecipeView(),
      ),
      GoRoute(
        path: '/profile',
        name: profile,
        builder: (context, state) => const ProfileView(),
      ),
    ],
  );
}
