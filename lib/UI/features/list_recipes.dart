import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/recipes_repository.dart';
import '../../models/recipe.dart';
import '../../navigation/routes.dart';
import '../shared/widgets/recipe_card.dart';

class ListRecipesView extends StatefulWidget {
  const ListRecipesView({super.key});

  @override
  State<ListRecipesView> createState() => _ListRecipesViewState();
}

class _ListRecipesViewState extends State<ListRecipesView> {
  final TextEditingController _searchController = TextEditingController();
  RecipeCategory? _selectedCategory;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        title: Text(
          'MyRecipes',
          style: text.headlineMedium?.copyWith(
            color: scheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.pushNamed(AppRoutes.profile),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 600;
            final horizontalPadding = isTablet ? 32.0 : 16.0;

            return ValueListenableBuilder<List<Recipe>>(
              valueListenable: RecipesRepository.instance,
              builder: (context, _, _) {
                final results = RecipesRepository.instance.filtered(
                  category: _selectedCategory,
                  query: _query,
                );

                return CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                          horizontalPadding, 16, horizontalPadding, 12),
                      sliver: SliverToBoxAdapter(
                        child: _SearchField(controller: _searchController),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding),
                      sliver: SliverToBoxAdapter(
                        child: _CategoryChips(
                          selected: _selectedCategory,
                          onChanged: (c) =>
                              setState(() => _selectedCategory = c),
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 8)),
                    if (results.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: _EmptyState(query: _query),
                      )
                    else
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(horizontalPadding, 8,
                            horizontalPadding, 96),
                        sliver: isTablet
                            ? SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 360,
                                  mainAxisSpacing: 20,
                                  crossAxisSpacing: 20,
                                  childAspectRatio: 0.85,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, i) =>
                                      RecipeCard(recipe: results[i]),
                                  childCount: results.length,
                                ),
                              )
                            : SliverList.separated(
                                itemCount: results.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 16),
                                itemBuilder: (context, i) =>
                                    RecipeCard(recipe: results[i]),
                              ),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(AppRoutes.adding),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  const _SearchField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      decoration: const InputDecoration(
        hintText: 'Search recipes...',
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  final RecipeCategory? selected;
  final ValueChanged<RecipeCategory?> onChanged;
  const _CategoryChips({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Widget chip({
      required String label,
      required bool active,
      required VoidCallback onTap,
    }) {
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(label),
          selected: active,
          onSelected: (_) => onTap(),
          showCheckmark: false,
          selectedColor: scheme.primary,
          backgroundColor: scheme.surface,
          labelStyle: TextStyle(
            color: active ? scheme.onPrimary : scheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          side: BorderSide(
            color: active ? scheme.primary : scheme.outlineVariant,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      );
    }

    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          chip(
            label: 'All',
            active: selected == null,
            onTap: () => onChanged(null),
          ),
          for (final c in RecipeCategory.values)
            chip(
              label: c.label,
              active: selected == c,
              onTap: () => onChanged(c),
            ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String query;
  const _EmptyState({required this.query});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: scheme.onSurfaceVariant),
          const SizedBox(height: 12),
          Text(
            query.isEmpty ? 'No recipes yet' : 'No recipe matches "$query"',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
