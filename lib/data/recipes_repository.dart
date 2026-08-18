import 'package:flutter/foundation.dart';

import '../models/recipe.dart';

/// In-memory reactive store for recipes. UI reads via ValueListenableBuilder
/// and mutates via [addRecipe]. Search/filter helpers are pure functions
/// operating on the current snapshot.
class RecipesRepository extends ValueNotifier<List<Recipe>> {
  RecipesRepository._() : super(List.of(_seed));

  static final RecipesRepository instance = RecipesRepository._();

  void addRecipe(Recipe recipe) {
    value = [recipe, ...value];
  }

  Recipe? findById(String id) {
    for (final r in value) {
      if (r.id == id) return r;
    }
    return null;
  }

  /// Filter by category (nullable = all) and free-text query on the title.
  List<Recipe> filtered({
    RecipeCategory? category,
    String query = '',
  }) {
    final q = query.trim().toLowerCase();
    return value.where((r) {
      final matchesCategory = category == null || r.category == category;
      final matchesQuery = q.isEmpty || r.title.toLowerCase().contains(q);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  static final List<Recipe> _seed = [
    Recipe(
      id: 'spicy-ramen',
      title: 'Spicy Ramen',
      tag: 'Asian',
      category: RecipeCategory.plat,
      difficulty: Difficulty.medium,
      prepTimeMinutes: 25,
      portions: 2,
      imageUrl:
          'https://images.unsplash.com/photo-1591814468924-caf88d1232e1?w=800&auto=format&fit=crop',
      ingredients: const [
        '2 packs of ramen noodles',
        '4 cups Chicken broth',
        '2 tbsp Miso paste',
        '2 Soft-boiled eggs',
        '1 tbsp Chili oil',
        'Fresh scallions',
      ],
      instructions: const [
        RecipeStep(
          title: 'Boil the broth',
          description:
              'In a medium pot, bring the chicken broth to a gentle simmer over medium heat. Do not let it boil vigorously.',
        ),
        RecipeStep(
          title: 'Mix the miso',
          description:
              'Whisk the miso paste with a ladle of hot broth until fully dissolved, then stir back into the pot.',
        ),
        RecipeStep(
          title: 'Cook the noodles',
          description:
              'Add noodles and cook according to package instructions — usually 3 minutes.',
        ),
        RecipeStep(
          title: 'Assemble and serve',
          description:
              'Divide the noodles into bowls, pour the broth over, and top with soft-boiled egg, scallions and chili oil.',
        ),
      ],
    ),
    Recipe(
      id: 'berry-tart',
      title: 'Berry Tart',
      tag: 'Pastry',
      category: RecipeCategory.dessert,
      difficulty: Difficulty.medium,
      prepTimeMinutes: 45,
      portions: 6,
      imageUrl:
          'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=800&auto=format&fit=crop',
      ingredients: const [
        '1 tart shell, pre-baked',
        '1 cup mascarpone',
        '2 tbsp honey',
        '250g mixed berries',
        '1 tbsp powdered sugar',
      ],
      instructions: const [
        RecipeStep(
          title: 'Whip the filling',
          description:
              'Beat mascarpone with honey until smooth and spread evenly into the tart shell.',
        ),
        RecipeStep(
          title: 'Top with berries',
          description:
              'Arrange the berries in loose circles from the outside in.',
        ),
        RecipeStep(
          title: 'Finish',
          description:
              'Dust with powdered sugar just before serving.',
        ),
      ],
    ),
    Recipe(
      id: 'mediterranean-salad',
      title: 'Mediterranean Salad',
      tag: 'Healthy',
      category: RecipeCategory.entree,
      difficulty: Difficulty.easy,
      prepTimeMinutes: 15,
      portions: 4,
      imageUrl:
          'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=800&auto=format&fit=crop',
      ingredients: const [
        '2 cups romaine lettuce',
        '1 cup cherry tomatoes',
        '1/2 cup kalamata olives',
        '150g feta cheese',
        '3 tbsp olive oil',
        '1 tbsp red wine vinegar',
      ],
      instructions: const [
        RecipeStep(
          title: 'Prep the vegetables',
          description:
              'Chop the lettuce and halve the cherry tomatoes.',
        ),
        RecipeStep(
          title: 'Assemble',
          description:
              'Toss lettuce, tomatoes and olives in a large bowl. Crumble the feta on top.',
        ),
        RecipeStep(
          title: 'Dress and serve',
          description:
              'Whisk oil and vinegar, drizzle over the salad and serve immediately.',
        ),
      ],
    ),
    Recipe(
      id: 'lemon-herb-salmon',
      title: 'Lemon Herb Salmon',
      tag: 'Seafood',
      category: RecipeCategory.plat,
      difficulty: Difficulty.medium,
      prepTimeMinutes: 30,
      portions: 2,
      imageUrl:
          'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=800&auto=format&fit=crop',
      ingredients: const [
        '2 salmon fillets',
        '1 bunch asparagus',
        '1 lemon',
        '2 tbsp olive oil',
        'Fresh dill',
        'Salt & pepper',
      ],
      instructions: const [
        RecipeStep(
          title: 'Prep the pan',
          description:
              'Heat olive oil in a heavy skillet over medium-high heat.',
        ),
        RecipeStep(
          title: 'Sear the salmon',
          description:
              'Season salmon and sear skin-side down for 4 minutes, then flip and cook 3 more minutes.',
        ),
        RecipeStep(
          title: 'Cook asparagus & finish',
          description:
              'Add asparagus around the salmon, squeeze lemon over the top, scatter dill and serve.',
        ),
      ],
    ),
    Recipe(
      id: 'iced-hibiscus-tea',
      title: 'Iced Hibiscus Tea',
      tag: 'Refreshing',
      category: RecipeCategory.boisson,
      difficulty: Difficulty.easy,
      prepTimeMinutes: 10,
      portions: 4,
      imageUrl:
          'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=800&auto=format&fit=crop',
      ingredients: const [
        '3 tbsp dried hibiscus flowers',
        '1 L water',
        '3 tbsp honey',
        '1 lime',
        'Ice',
      ],
      instructions: const [
        RecipeStep(
          title: 'Steep',
          description:
              'Bring water to a boil, remove from heat, add hibiscus and steep for 8 minutes.',
        ),
        RecipeStep(
          title: 'Sweeten',
          description:
              'Strain, stir in honey while warm, then cool completely.',
        ),
        RecipeStep(
          title: 'Serve',
          description:
              'Pour over ice, add lime wedges and serve.',
        ),
      ],
    ),
    Recipe(
      id: 'granola-bites',
      title: 'Granola Bites',
      tag: 'Snack',
      category: RecipeCategory.snack,
      difficulty: Difficulty.easy,
      prepTimeMinutes: 20,
      portions: 12,
      imageUrl:
          'https://images.unsplash.com/photo-1490474418585-ba9bad8fd0ea?w=800&auto=format&fit=crop',
      ingredients: const [
        '2 cups rolled oats',
        '1/2 cup peanut butter',
        '1/3 cup honey',
        '1/4 cup dark chocolate chips',
        '2 tbsp chia seeds',
      ],
      instructions: const [
        RecipeStep(
          title: 'Mix',
          description:
              'Combine all ingredients in a large bowl until sticky and even.',
        ),
        RecipeStep(
          title: 'Roll',
          description:
              'Roll into 12 small balls and place on a parchment-lined tray.',
        ),
        RecipeStep(
          title: 'Chill',
          description:
              'Refrigerate at least 30 minutes before serving. Keeps 1 week.',
        ),
      ],
    ),
  ];
}
