import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MoreDetailsPage extends StatefulWidget {
  final Map<String, dynamic> apiResponse;

  MoreDetailsPage({required this.apiResponse});

  @override
  _MoreDetailsPageState createState() => _MoreDetailsPageState();
}

class _MoreDetailsPageState extends State<MoreDetailsPage> {
  Map<String, dynamic>? structuredNutritionData;

  @override
  void initState() {
    super.initState();
    // Automatically call the API with nutrition data when the page loads
    _getStructuredNutritionFacts();
  }

  Future<void> _getStructuredNutritionFacts() async {
    var nutritionData = widget.apiResponse['nutrition_data'];
    var text = nutritionData[0]["text"] ?? "";

    // Set up the request body for the POST request
    var requestBody = json.encode({
      'text': text,
      'bmi': '22.5', // Replace with actual data or let user input
      'age': '30', // Replace with actual data or let user input
      'users_health_concerns': 'diabetes', // Replace with actual data
      'users_ailments': 'none' // Replace with actual data
    });

    try {
      // Make POST request to Flask API
      var response = await http.post(
        Uri.parse('http://10.108.246.91:5000/get_structured_nutrition_facts'),
        headers: {"Content-Type": "application/json"},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Parse the response JSON
        var responseData = json.decode(response.body);
        setState(() {
          structuredNutritionData = responseData['result'];
        });
      } else {
        print('Failed to get structured nutrition data.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract the ingredient and product recognition data
    var ingredientData = widget.apiResponse['ingredient_data']['ingredients'];
    var productRecognition = widget.apiResponse['product_recognition'];

    return Scaffold(
      appBar: AppBar(
        title: Text('More Details'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nutrition Data',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildNutritionSection(),
            Divider(),
            Text(
              'Ingredients',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildIngredientSection(ingredientData),
            Divider(),
            Text(
              'Product Recognition',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildProductRecognitionSection(productRecognition),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionSection() {
    // If structured nutrition data is not yet available, show loading indicator
    if (structuredNutritionData == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recommendation: ${structuredNutritionData!["recommendation"]}'),
        Text('Servings per Container: ${structuredNutritionData!["servings_per_container"]}'),
        Text('Serving Size: ${structuredNutritionData!["serving_size"]}'),
        Text('Calories: ${structuredNutritionData!["calories"]}'),
        SizedBox(height: 10),
        Text(
          'Nutrients:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: structuredNutritionData!["nutrients"].map<Widget>((nutrient) {
            return Text(
              '${nutrient["name"]}: ${nutrient["amount"]} (${nutrient["daily_value"]}%)',
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildIngredientSection(List<dynamic> ingredientData) {
    if (ingredientData == null || ingredientData.isEmpty) {
      return Text('No ingredients found.');
    }
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(), // Disable scrolling within the ListView
      children: ingredientData.map<Widget>((ingredient) {
        return _buildIngredientTile(ingredient);
      }).toList(),
    );
  }

  Widget _buildIngredientTile(Map<String, dynamic> ingredient) {
    return ExpansionTile(
      title: Text(
        ingredient['ingredient_name'] ?? 'Unknown Ingredient', 
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextRow('Description: ', ingredient['description']),
              _buildTextRow('Benefits: ', ingredient['benefits']),
              _buildTextRow('Detriments: ', ingredient['detriments']),
              _buildTextRow('Conclusion: ', ingredient['conclusion']),
              ingredient['allergy_warning'] == true
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Allergy Warning: This ingredient may cause an allergic reaction.',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    )
                  : Container(), // Empty container if no allergy warning
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value ?? 'Unknown',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductRecognitionSection(Map<String, dynamic> productRecognition) {
    if (productRecognition == null) {
      return Text('No product recognition data.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Web Entities:'),
        ...productRecognition['web_entities'].map<Widget>((entity) {
          return Text('• ${entity["description"]} (Score: ${entity["score"]})');
        }).toList(),
        SizedBox(height: 10),
        Text('Visually Similar Images:'),
        ...productRecognition['visually_similar_images'].map<Widget>((imageUrl) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Image.network(imageUrl),
          );
        }).toList(),
      ],
    );
  }
}
