import 'package:flutter/material.dart';
import 'package:next_flutter_recipe/navigation/routes.dart';
import 'package:next_flutter_recipe/utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: hideKeyboard,
      child: MaterialApp.router(
        routeInformationParser: AppRoutes.router.routeInformationParser,
        routerDelegate: AppRoutes.router.routerDelegate,
        routeInformationProvider: AppRoutes.router.routeInformationProvider,
        title: 'My recipe app',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryLightColor),
        ),
      ),
    );

  }

  void hideKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
