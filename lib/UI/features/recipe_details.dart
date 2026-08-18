import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/recipes_repository.dart';
import '../../models/recipe.dart';
import '../shared/widgets/instruction_card.dart';
import '../shared/widgets/recipe_card.dart';

class RecipeDetailsView extends StatefulWidget {
  final String recipeId;
  const RecipeDetailsView({super.key, required this.recipeId});

  @override
  State<RecipeDetailsView> createState() => _RecipeDetailsViewState();
}

class _RecipeDetailsViewState extends State<RecipeDetailsView> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final recipe = RecipesRepository.instance.findById(widget.recipeId);

    if (recipe == null) {
      return Scaffold(
        appBar: AppBar(leading: const _RoundBackButton()),
        body: Center(
          child: Text(
            'Recipe not found',
            style: text.titleLarge,
          ),
        ),
      );
    }

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth >= 600;
          final horizontalPadding = isTablet ? 32.0 : 16.0;
          final maxContentWidth = isTablet ? 720.0 : double.infinity;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _HeroHeader(
                  recipe: recipe,
                  isFavorite: _isFavorite,
                  onToggleFavorite: () =>
                      setState(() => _isFavorite = !_isFavorite),
                ),
              ),
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(maxWidth: maxContentWidth),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: scheme.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              recipe.category.label,
                              style: text.labelMedium?.copyWith(
                                color: scheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            recipe.title,
                            style: text.headlineMedium?.copyWith(
                              color: scheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _MetaRow(recipe: recipe),
                          const Divider(height: 32),
                          _SectionHeader(
                            label: 'Ingredients',
                            trailing: '${recipe.ingredients.length} items',
                          ),
                          const SizedBox(height: 8),
                          ...recipe.ingredients.map(
                            (i) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.circle,
                                      size: 8,
                                      color: scheme.primary),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      i,
                                      style: text.bodyLarge,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          _SectionHeader(label: 'Instructions'),
                          const SizedBox(height: 12),
                          ...List.generate(
                            recipe.instructions.length,
                            (i) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10),
                              child: InstructionCard(
                                index: i,
                                title: recipe.instructions[i].title,
                                description:
                                    recipe.instructions[i].description,
                              ),
                            ),
                          ),
                          const SizedBox(height: 96),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.play_arrow),
        label: const Text('Start cooking'),
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final Recipe recipe;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  const _HeroHeader({
    required this.recipe,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: RecipeCard.heroTagFor(recipe.id),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: Image.network(
                recipe.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  alignment: Alignment.center,
                  child: const Icon(Icons.restaurant, size: 64),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const _RoundBackButton(),
                _RoundIconButton(
                  icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: onToggleFavorite,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundBackButton extends StatelessWidget {
  const _RoundBackButton();

  @override
  Widget build(BuildContext context) {
    return _RoundIconButton(
      icon: Icons.arrow_back,
      color: Colors.black,
      onPressed: () {
        if (context.canPop()) {
          context.pop();
        } else {
          Navigator.of(context).maybePop();
        }
      },
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  const _RoundIconButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.85),
      shape: const CircleBorder(),
      child: IconButton(
        icon: Icon(icon, color: color),
        onPressed: onPressed,
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final Recipe recipe;
  const _MetaRow({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _MetaItem(
            icon: Icons.access_time_outlined,
            label: '${recipe.prepTimeMinutes} min'),
        _MetaItem(
            icon: Icons.local_fire_department_outlined,
            label: recipe.difficulty.label),
        _MetaItem(
            icon: Icons.person_outline,
            label: '${recipe.portions} portions'),
      ],
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, color: scheme.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final String? trailing;
  const _SectionHeader({required this.label, this.trailing});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          label,
          style: text.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: text.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}
