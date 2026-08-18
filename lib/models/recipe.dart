import 'dart:convert';

enum RecipeCategory {
  entree('Entrée'),
  plat('Plat'),
  dessert('Dessert'),
  boisson('Boisson'),
  snack('Snack');

  const RecipeCategory(this.label);
  final String label;

  static RecipeCategory fromLabel(String label) => values.firstWhere(
        (c) => c.label.toLowerCase() == label.toLowerCase(),
        orElse: () => RecipeCategory.plat,
      );
}

enum Difficulty {
  easy('Easy'),
  medium('Medium'),
  hard('Hard');

  const Difficulty(this.label);
  final String label;

  static Difficulty fromLabel(String label) => values.firstWhere(
        (d) => d.label.toLowerCase() == label.toLowerCase(),
        orElse: () => Difficulty.easy,
      );
}

class RecipeStep {
  final String title;
  final String description;

  const RecipeStep({required this.title, required this.description});

  factory RecipeStep.fromMap(Map<String, dynamic> map) => RecipeStep(
        title: map['title'] as String? ?? '',
        description: map['description'] as String? ?? '',
      );

  Map<String, dynamic> toMap() => {
        'title': title,
        'description': description,
      };
}

class Recipe {
  final String id;
  final String title;
  final String tag;
  final RecipeCategory category;
  final Difficulty difficulty;
  final int prepTimeMinutes;
  final int portions;
  final String imageUrl;
  final List<String> ingredients;
  final List<RecipeStep> instructions;

  const Recipe({
    required this.id,
    required this.title,
    required this.tag,
    required this.category,
    required this.difficulty,
    required this.prepTimeMinutes,
    required this.portions,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
  });

  Recipe copyWith({
    String? id,
    String? title,
    String? tag,
    RecipeCategory? category,
    Difficulty? difficulty,
    int? prepTimeMinutes,
    int? portions,
    String? imageUrl,
    List<String>? ingredients,
    List<RecipeStep>? instructions,
  }) =>
      Recipe(
        id: id ?? this.id,
        title: title ?? this.title,
        tag: tag ?? this.tag,
        category: category ?? this.category,
        difficulty: difficulty ?? this.difficulty,
        prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
        portions: portions ?? this.portions,
        imageUrl: imageUrl ?? this.imageUrl,
        ingredients: ingredients ?? this.ingredients,
        instructions: instructions ?? this.instructions,
      );

  factory Recipe.fromJson(String source) =>
      Recipe.fromMap(json.decode(source) as Map<String, dynamic>);

  String toJson() => json.encode(toMap());

  factory Recipe.fromMap(Map<String, dynamic> map) => Recipe(
        id: map['id'] as String,
        title: map['title'] as String,
        tag: map['tag'] as String? ?? '',
        category: RecipeCategory.fromLabel(map['category'] as String),
        difficulty: Difficulty.fromLabel(map['difficulty'] as String),
        prepTimeMinutes: map['prepTimeMinutes'] as int,
        portions: map['portions'] as int? ?? 2,
        imageUrl: map['imageUrl'] as String,
        ingredients: List<String>.from(map['ingredients'] as List),
        instructions: (map['instructions'] as List)
            .map((e) => RecipeStep.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'tag': tag,
        'category': category.label,
        'difficulty': difficulty.label,
        'prepTimeMinutes': prepTimeMinutes,
        'portions': portions,
        'imageUrl': imageUrl,
        'ingredients': ingredients,
        'instructions': instructions.map((e) => e.toMap()).toList(),
      };
}
