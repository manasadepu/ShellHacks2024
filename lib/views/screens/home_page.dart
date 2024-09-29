import 'package:flutter/material.dart';
import 'package:hungry/models/core/recipe.dart';
import 'package:hungry/models/helper/recipe_helper.dart';
import 'package:hungry/views/screens/newly_posted_page.dart';
import 'package:hungry/views/screens/profile_page.dart';
import 'package:hungry/views/screens/search_page.dart';
import 'package:hungry/views/utils/AppColor.dart';
import 'package:hungry/views/widgets/custom_app_bar.dart';
import 'package:hungry/views/widgets/dummy_search_bar.dart';
import 'package:hungry/views/widgets/recipe_tile.dart';

class HomePage extends StatelessWidget {
  final Future<List<Recipe>> newlyPostedRecipe = RecipeHelper.getNewlyPostedRecipes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'BetterBites',
          style: TextStyle(
            color: AppColor.secondary,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
        ),
        showProfilePhoto: true,
        profilePhoto: AssetImage('assets/images/josephpp.jpeg'),
        profilePhotoOnPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
        },
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          // Section 1 - Featured Recipe - Wrapper
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: 250,
                  color: Color.fromARGB(255, 7, 77, 50),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // The DummySearchBar at the top
                        DummySearchBar(
                          routeTo: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => SearchPage()),
                            );
                          },
                        ),
                        SizedBox(height: 10),
                        // Row for the slogan and logo
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                'Discover your food, one scan at a time.', // Your text
                                style: TextStyle(
                                  color: AppColor.secondary, // Custom color
                                  fontSize: 30, // Font size
                                  fontWeight: FontWeight.w600, // Optional: Adjust weight if needed
                                  fontFamily: 'Times', // Optional: Use your desired font family
                                ),
                              ),
                            ),
                            Image.asset(
                              'assets/images/BetterBitesLogo.png', // Replace with the path to your logo asset
                              height: 150, // Set the logo height
                              width: 150, // Set the logo width
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Section 3 - Newly Posted
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Scanned Foods',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => NewlyPostedPage()),
                        );
                      },
                      child: Text('See All'),
                      style: TextButton.styleFrom(
                        primary: Colors.black,
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                // Content - Use FutureBuilder to display newly posted recipes
                FutureBuilder<List<Recipe>>(
                  future: newlyPostedRecipe,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No newly posted recipes found.'));
                    } else {
                      List<Recipe> recipes = snapshot.data!;
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: recipes.length,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
