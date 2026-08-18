import 'package:flutter/material.dart';
import 'package:next_flutter_recipe/navigation/routes.dart';
import 'package:next_flutter_recipe/utils/theme.dart';
import 'package:next_flutter_recipe/utils/theme_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeController _themeController = ThemeController();

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeScope(
      controller: _themeController,
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: _themeController,
        builder: (context, mode, _) {
          return GestureDetector(
            onTap: () =>
                FocusManager.instance.primaryFocus?.unfocus(),
            child: MaterialApp.router(
              title: 'MyRecipes',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              themeMode: mode,
              routerConfig: AppRoutes.router,
            ),
          );
        },
      ),
    );
  }
}
