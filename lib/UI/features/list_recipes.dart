import 'package:flutter/material.dart';
import 'package:next_flutter_recipe/utils/images.dart';

import '../../utils/colors.dart';
import '../shared/widgets/recipe_card.dart';

class ListRecipesView extends StatefulWidget {
  const ListRecipesView({super.key});

  @override
  State<ListRecipesView> createState() => _ListRecipesViewState();
}

class _ListRecipesViewState extends State<ListRecipesView> {
  int activeIndex = 0;
  final List<String> filters = ['Entrée', 'Plat', 'Dessert', 'Boisson', 'Snack'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu, color: AppColors.primaryColor,),
          onPressed: () {
            // Handle menu button press
          },
        ),
        title: Text(
          'MyRecipes',
          style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: AppColors.primaryColor,),
            onPressed: () {
              // Handle person button press
            },
          ),
        ],
      ),
      body: Column(
        children: [
          //search textField
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                filled: true,
                fillColor: AppColors.secondaryColor.withAlpha(50),
                hintText: 'Search recipes...',
                hintStyle: TextStyle(color: AppColors.secondaryColor),
                prefixIcon: Icon(Icons.search, color: AppColors.primaryColor),
                border: InputBorder.none
              ),
            ),
          ),
          SizedBox(height: 10),
          //filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (int i = 0; i < filters.length; i++)
                  filterCard(
                    value: filters[i],
                    isActive: i == activeIndex,
                  ),
              ],
            ),
          ),
          SizedBox(height: 10),
          // listview of recipes cards
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(16),
              itemCount: 10,
              separatorBuilder: (context, index) => SizedBox(height: 10),
              itemBuilder: (context, index) {
                return RecipeCard(
                  recipeName: 'Recipe Title $index',
                  recipeTime: 10,
                  recipeDifficulty: 'Easy',
                  recipeImage: AppImages.logo,
                  type: 'Entrée',
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          // Handle floating action button press
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget filterCard({required String value, bool isActive = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          activeIndex = filters.indexOf(value);
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryColor : AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: isActive?Border.fromBorderSide(BorderSide(color: AppColors.primaryColor, width: 1)): null
        ),
        child: Text(value, style: TextStyle(color: isActive ? Colors.white : AppColors.primaryColor)),
      ),
    );
  }
}
