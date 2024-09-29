import 'package:flutter/material.dart';
import 'package:hungry/models/core/recipe.dart';
import 'package:hungry/models/helper/recipe_helper.dart';
import 'package:hungry/views/utils/AppColor.dart';
import 'package:hungry/views/widgets/recipe_tile.dart';

class NewlyPostedPage extends StatelessWidget {
  final TextEditingController searchInputController = TextEditingController();

  // The future for fetching newly posted recipes
  final Future<List<Recipe>> newlyPostedRecipe = RecipeHelper.getNewlyPostedRecipes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: AppColor.primary,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Newly Posted',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: newlyPostedRecipe, // Using the future to fetch newly posted recipes
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for the data
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Display an error message if there was an error fetching the data
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Display a message if no recipes were found
            return Center(child: Text('No newly posted recipes found.'));
          } else {
            // When data is available, display the list of recipes
            List<Recipe> recipes = snapshot.data!;
            return ListView.separated(
              padding: EdgeInsets.all(16),
              shrinkWrap: true,
              itemCount: recipes.length,
              physics: BouncingScrollPhysics(),
              separatorBuilder: (context, index) {
                return SizedBox(height: 16);
              },
              itemBuilder: (context, index) {
                return RecipeTile(
                  data: recipes[index],
                );
              },
            );
          }
        },
      ),
    );
  }
}
