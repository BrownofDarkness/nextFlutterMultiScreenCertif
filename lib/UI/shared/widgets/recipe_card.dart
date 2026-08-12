import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class RecipeCard extends StatelessWidget {
  final String recipeName;
  final int recipeTime;
  final String recipeDifficulty;
  final String recipeImage;
  final String type;
  const RecipeCard({super.key, required this.recipeName, required this.recipeTime, required this.recipeDifficulty, required this.recipeImage, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey.withAlpha(200),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(recipeImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    recipeName,
                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.timer),
                          SizedBox(width: 8),
                          Text('$recipeTime min', style: TextStyle(color: AppColors.primaryColor.withAlpha(200)),)
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.local_fire_department),
                          SizedBox(width: 8),
                          Text(recipeDifficulty, style: TextStyle(color: AppColors.primaryColor.withAlpha(200)),)
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  type,
                  style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        )
    );
  }
}
