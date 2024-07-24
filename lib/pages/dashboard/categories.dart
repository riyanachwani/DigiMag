import 'package:digimag/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:digimag/utils/user_services.dart';
import 'package:digimag/utils/api_services.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  Set<String> _favoriteCategories = {};
  List<String> _availableCategories = [];
  List<String> _likedCategories = [];
  List<String> _unlikedCategories = [];
  bool _isLoading = false;
  final UserService userService = UserService();
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _loadAvailableCategories();
  }

  Future<void> _loadFavorites() async {
    try {
      final favoriteCategories = await userService.getFavoriteCategories();
      setState(() {
        print("Loaded favorites: $_favoriteCategories");
        _favoriteCategories = favoriteCategories.toSet();
        _updateCategoryLists();
      });
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }

  Future<void> _loadAvailableCategories() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<String> categories = await apiService.getAvailableCategories();

      // Capitalize the first letter and lowercase the rest of each category
      List<String> formattedCategories = categories.map((category) {
        if (category.isEmpty) return category; // Handle empty strings
        String formattedCategory =
            category[0].toUpperCase() + category.substring(1).toLowerCase();
        return formattedCategory;
      }).toList();

      if (mounted) {
        setState(() {
          _availableCategories = formattedCategories;
          print("\n\nLoaded available categories: $_availableCategories");
          _updateCategoryLists();
        });
      }
    } catch (e) {
      print('Error loading categories: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _updateCategoryLists() {
    setState(() {
      _likedCategories = _favoriteCategories.toList();

      // Capitalize the first letter and lowercase the rest for consistency
      _unlikedCategories = _availableCategories
          .where((category) => !_favoriteCategories.contains(category))
          .map((category) =>
              category[0].toUpperCase() + category.substring(1).toLowerCase())
          .toList();

      print(
          "\n\nUpdated category lists: liked: $_likedCategories, unliked: $_unlikedCategories");
    });
  }

  Future<void> _toggleFavoriteCategory(String category) async {
    try {
      String formattedCategory =
          category[0].toUpperCase() + category.substring(1).toLowerCase();
      if (_favoriteCategories.contains(formattedCategory)) {
        await userService.removeFavoriteCategory(formattedCategory);
        setState(() {
          _favoriteCategories.remove(formattedCategory);
          _likedCategories.remove(formattedCategory);
          _unlikedCategories.add(formattedCategory);
          print("Removed category from favorites: $formattedCategory");
          print(
              "Updated lists: liked: $_likedCategories, unliked: $_unlikedCategories");
        });
      } else {
        await userService.addFavoriteCategory(formattedCategory);
        setState(() {
          _favoriteCategories.add(formattedCategory);
          _likedCategories.add(formattedCategory);
          _unlikedCategories.remove(formattedCategory);
          print("Added category to favorites: $formattedCategory");
          print(
              "Updated lists: liked: $_likedCategories, unliked: $_unlikedCategories");
        });
      }
    } catch (e) {
      print('Error toggling category: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);

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
                      hintText: 'Search categories',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _likedCategories = _availableCategories
                            .where((category) =>
                                _favoriteCategories.contains(category) &&
                                category
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                            .toList();
                        _unlikedCategories = _availableCategories
                            .where((category) =>
                                !_favoriteCategories.contains(category) &&
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
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(
              fontFamily: "RosebayRegular",
              fontSize: 18,
            ),
          ),
        ),
        ...categories.map((category) {
          bool isFavorite = _favoriteCategories.contains(category);
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
