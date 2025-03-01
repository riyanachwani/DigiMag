import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:digimag/main.dart';
import 'package:digimag/utils/services/api_services.dart';
import 'package:digimag/utils/providers/category_provider.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<String> _availableCategories = [];
  List<String> _likedCategories = [];
  List<String> _unlikedCategories = [];
  bool _isLoading = false;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadAvailableCategories();
  }

  Future<void> _loadAvailableCategories() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<String> categories = await apiService.getAvailableCategories();

      List<String> formattedCategories = categories.map((category) {
        if (category.isEmpty) return category; // Handle empty strings
        String formattedCategory =
            category[0].toUpperCase() + category.substring(1).toLowerCase();
        return formattedCategory;
      }).toList();

      if (mounted) {
        setState(() {
          _availableCategories = formattedCategories;
          _updateCategoryLists();
        });
      }
    } catch (e) {
      log('Error loading categories: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _updateCategoryLists() {
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    setState(() {
      _likedCategories = categoryProvider.likedCategories.toList();

      // Capitalize the first letter and lowercase the rest for consistency
      _unlikedCategories = _availableCategories
          .where((category) =>
              !categoryProvider.likedCategories.contains(category))
          .map((category) =>
              category[0].toUpperCase() + category.substring(1).toLowerCase())
          .toList();
    });
  }

  Future<void> _toggleFavoriteCategory(String category) async {
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    await categoryProvider.toggleCategory(category);
    _updateCategoryLists(); // Update lists immediately after toggling
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Categories",
          style: TextStyle(fontFamily: "RosebayRegular", fontSize: 20),
        ),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search categories',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _likedCategories = _availableCategories
                            .where((category) =>
                                categoryProvider.likedCategories
                                    .contains(category) &&
                                category
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                            .toList();
                        _unlikedCategories = _availableCategories
                            .where((category) =>
                                !categoryProvider.likedCategories
                                    .contains(category) &&
                                category
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      _buildCategorySection(
                          'Liked Categories', _likedCategories, true),
                      _buildCategorySection(
                          'Unliked Categories', _unlikedCategories, false),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCategorySection(
      String title, List<String> categories, bool isLikedSection) {
    final themeModel = Provider.of<ThemeModel>(context);
    final isDarkMode = themeModel.mode == ThemeMode.dark;

    final tileShade = isDarkMode ? Colors.black : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            title,
            style: TextStyle(
              fontFamily: "RosebayRegular",
              fontSize: 18,
            ),
          ),
        ),
        ...categories.map((category) {
          bool isFavorite = Provider.of<CategoryProvider>(context)
              .likedCategories
              .contains(category);
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 4.0,
            child: ListTile(
              contentPadding: EdgeInsets.all(16.0),
              title: Text(
                category[0].toUpperCase() + category.substring(1).toLowerCase(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: () => _toggleFavoriteCategory(category),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              tileColor: tileShade,
            ),
          );
        }).toList(),
      ],
    );
  }
}
