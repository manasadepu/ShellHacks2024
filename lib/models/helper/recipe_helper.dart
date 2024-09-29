import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hungry/models/core/recipe.dart';

class RecipeHelper {
  // Function to get newly posted recipes from Firestore
  static Future<List<Recipe>> getNewlyPostedRecipes() async {
    try {
      // Get all documents from the 'scans' collection
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('scans')
          .get();
      // Convert each document to a Recipe instance
      List<Recipe> recipes = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Recipe.fromJson(data);
      }).toList();
      print(recipes);
      return recipes;
    } catch (e) {
      print('Error fetching newly posted recipes: $e');
      return [];
    }
  }
}
