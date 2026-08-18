# MyRecipes — Flutter multi-screen app

Projet de validation nextFlutter : application Flutter multi-écrans autour du
thème des recettes de cuisine, avec navigation `go_router`, thème clair/sombre
Material 3 et design system "Gourmet Canvas".

## Écrans

1. **Login** — formulaire à 3 champs (email, pseudo, mot de passe) avec
   validation et état de chargement.
2. **Liste des recettes** — recherche live + filtres par catégorie (chips),
   `ListView` sur mobile et `GridView` sur tablette.
3. **Détail** — image en `Hero`, ingrédients, instructions étape par étape,
   passage de paramètre `id` via l'URL.
4. **Add Recipe** — formulaire complet (titre, catégorie, temps, difficulté,
   ingrédients, instructions), la nouvelle recette est ajoutée au repository.
5. **Profile** — informations utilisateur, toggle Dark Mode connecté au thème
   global, toggle Notifications, About et Log Out.

## Fonctionnalités couvertes par la consigne

| Exigence | Statut |
|---|---|
| ≥ 4 écrans distincts | ✅ 5 écrans |
| Navigation `go_router` avec routes nommées | ✅ `AppRoutes` |
| Écran de liste avec recherche/filtrage | ✅ `ListRecipesView` |
| Écran de détail avec passage de paramètres | ✅ `/recipes/:id` |
| Formulaire avec validation (≥ 3 champs) | ✅ Login (3 champs) + Add Recipe (6 champs) |
| Thème clair/sombre | ✅ `ThemeController` + `ThemeScope` |
| ≥ 8 widgets différents | ✅ `Scaffold`, `AppBar`, `ListView`, `GridView`, `Stack`, `Hero`, `Card`, `TextFormField`, `DropdownButtonFormField`, `Switch`, `NavigationBar` ... |
| ≥ 3 widgets réutilisables sous `widgets/` | ✅ `RecipeCard`, `InstructionCard`, `DefaultButton` |
| Responsive mobile + tablet | ✅ `LayoutBuilder` (breakpoint 600 px) |
| Aucune donnée hardcodée dans les widgets | ✅ Données isolées dans `data/recipes_repository.dart` |

## Structure du projet

```
lib/
├── main.dart                       # MaterialApp.router + ThemeScope
├── navigation/
│   └── routes.dart                 # Configuration GoRouter (5 routes)
├── models/
│   ├── recipe.dart                 # Recipe + enums (Category, Difficulty, Step)
│   └── user_model.dart
├── data/
│   └── recipes_repository.dart     # Repository singleton + seed + filter
├── utils/
│   ├── colors.dart                 # Palette Gourmet Canvas
│   ├── theme.dart                  # ThemeData light/dark M3 + Inter
│   ├── theme_controller.dart       # ValueNotifier<ThemeMode> + ThemeScope
│   ├── button_states.dart
│   └── images.dart
└── UI/
    ├── features/
    │   ├── login.dart
    │   ├── list_recipes.dart
    │   ├── recipe_details.dart
    │   ├── add_recipe.dart
    │   └── profile.dart
    └── shared/
        └── widgets/
            ├── default_button.dart
            ├── recipe_card.dart
            └── instruction_card.dart
```

## Design system — Gourmet Canvas

- Material 3 (`useMaterial3: true`)
- Typographie : Inter via `google_fonts`
- Palette : terracotta (`#9E3D00`) sur crème (`#FCF9F8`)
- Coins arrondis généreux (16 / 24 / 28 px selon les composants)
- Dark mode dérivée automatiquement du seed color

## Lancement

```bash
flutter pub get
flutter run
```

Pour cibler un device précis :

```bash
flutter devices           # liste les devices connectés
flutter run -d chrome     # web
flutter run -d windows    # desktop
```

## Choix techniques

- **Navigation** : `go_router` 17, routes nommées, un `initialLocation`
  démarrant sur `/login`.
- **Data layer** : `RecipesRepository` singleton exposant un
  `ValueNotifier<List<Recipe>>` — les écrans écoutent via
  `ValueListenableBuilder`, aucun state management externe.
- **State d'app** : `ValueNotifier<ThemeMode>` distribué par un
  `InheritedNotifier` (`ThemeScope`) pour le toggle dark/light.
- **Responsive** : `LayoutBuilder` avec breakpoint à 600 px — la liste passe
  d'un `ListView` à un `GridView` en tablette, les formulaires se centrent
  avec une largeur max.
- **Animation** : `Hero` sur l'image de recette entre la carte de la liste et
  l'écran détail.

## Captures d'écran

Ajouter ici les captures une fois l'app lancée :

```
docs/
├── screen_login.png
├── screen_list.png
├── screen_details.png
├── screen_add.png
└── screen_profile.png
```
