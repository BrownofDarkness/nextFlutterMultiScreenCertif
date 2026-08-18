import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../data/recipes_repository.dart';
import '../../models/recipe.dart';
import '../../utils/button_states.dart';
import '../shared/widgets/default_button.dart';

class AddRecipeView extends StatefulWidget {
  const AddRecipeView({super.key});

  @override
  State<AddRecipeView> createState() => _AddRecipeViewState();
}

class _AddRecipeViewState extends State<AddRecipeView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _prepTimeController = TextEditingController(text: '30');
  final _ingredientsController = TextEditingController();
  final _instructionsController = TextEditingController();

  RecipeCategory? _category;
  Difficulty _difficulty = Difficulty.easy;
  bool _submitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _prepTimeController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please pick a category')),
      );
      return;
    }

    setState(() => _submitting = true);

    final ingredients = _ingredientsController.text
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final steps = _instructionsController.text
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final recipe = Recipe(
      id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      tag: _category!.label,
      category: _category!,
      difficulty: _difficulty,
      prepTimeMinutes: int.parse(_prepTimeController.text),
      portions: 2,
      imageUrl: '',
      ingredients: ingredients,
      instructions: [
        for (var i = 0; i < steps.length; i++)
          RecipeStep(title: 'Step ${i + 1}', description: steps[i]),
      ],
    );

    RecipesRepository.instance.addRecipe(recipe);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${recipe.title} saved')),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recipe'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth >= 600 ? 640.0 : double.infinity;
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                    children: [
                      _PhotoPlaceholder(color: scheme.primary),
                      const SizedBox(height: 24),
                      _FieldLabel('Recipe Title'),
                      TextFormField(
                        controller: _titleController,
                        enabled: !_submitting,
                        decoration: const InputDecoration(
                          hintText: "E.g. Grandmother's Apple Pie",
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Title is required'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      _FieldLabel('Category'),
                      DropdownButtonFormField<RecipeCategory>(
                        initialValue: _category,
                        decoration: const InputDecoration(
                          hintText: 'Select category',
                        ),
                        items: [
                          for (final c in RecipeCategory.values)
                            DropdownMenuItem(value: c, child: Text(c.label)),
                        ],
                        onChanged: _submitting
                            ? null
                            : (v) => setState(() => _category = v),
                        validator: (v) =>
                            v == null ? 'Category is required' : null,
                      ),
                      const SizedBox(height: 20),
                      _FieldLabel('Prep Time (minutes)'),
                      TextFormField(
                        controller: _prepTimeController,
                        enabled: !_submitting,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(hintText: '30'),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Required';
                          final n = int.tryParse(v);
                          if (n == null || n <= 0) {
                            return 'Enter a positive number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _FieldLabel('Difficulty'),
                      _DifficultyToggle(
                        value: _difficulty,
                        onChanged: _submitting
                            ? null
                            : (d) => setState(() => _difficulty = d),
                      ),
                      const SizedBox(height: 20),
                      _FieldLabel('Ingredients'),
                      TextFormField(
                        controller: _ingredientsController,
                        enabled: !_submitting,
                        maxLines: 5,
                        minLines: 5,
                        decoration: const InputDecoration(
                          hintText:
                              'One ingredient per line\nE.g. 2 cups flour\n1 tsp salt',
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'At least one ingredient required'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      _FieldLabel('Instructions'),
                      TextFormField(
                        controller: _instructionsController,
                        enabled: !_submitting,
                        maxLines: 6,
                        minLines: 6,
                        decoration: const InputDecoration(
                          hintText: 'Describe each step (one per line)…',
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Instructions are required'
                            : null,
                      ),
                      const SizedBox(height: 32),
                      DefaultButton(
                        label: 'Save Recipe',
                        icon: Icons.save_outlined,
                        onPressed: _save,
                        buttonState: _submitting
                            ? ButtonState.loading
                            : ButtonState.enabled,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  final Color color;
  const _PhotoPlaceholder({required this.color});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: color,
      child: Container(
        height: 180,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.photo_camera_outlined, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text('Add photo',
                style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}

class _DifficultyToggle extends StatelessWidget {
  final Difficulty value;
  final ValueChanged<Difficulty>? onChanged;
  const _DifficultyToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          for (final d in Difficulty.values)
            Expanded(
              child: GestureDetector(
                onTap: onChanged == null ? null : () => onChanged!(d),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: d == value ? scheme.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    d.label,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: d == value ? scheme.onPrimary : scheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Simple dashed-border container built from a CustomPaint so we don't need
/// an extra package for a single decorative frame.
class DottedBorder extends StatelessWidget {
  final Widget child;
  final Color color;
  const DottedBorder({super.key, required this.child, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedRectPainter(color: color),
      child: child,
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  final Color color;
  _DashedRectPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const dash = 8.0;
    const gap = 6.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(16),
    );
    final path = Path()..addRRect(rrect);
    final dashed = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final end = (distance + dash).clamp(0, metric.length).toDouble();
        dashed.addPath(metric.extractPath(distance, end), Offset.zero);
        distance = end + gap;
      }
    }
    canvas.drawPath(dashed, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedRectPainter old) => old.color != color;
}
