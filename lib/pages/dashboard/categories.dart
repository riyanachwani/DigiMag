import 'package:digimag/main.dart';
import 'package:digimag/utils/user_services.dart';
import 'package:flutter/material.dart';
import 'package:digimag/utils/api_services.dart';
import 'package:provider/provider.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late Future<List<String>> _categoriesFuture;
  late Future<Set<String>> _favoritesFuture;
  Set<String> favorites = {};

  @override
  void initState() {
    super.initState();
    _categoriesFuture = ApiService().getAvailableCategories();
    _favoritesFuture = UserService().getFavoriteCategories().then((fav) {
      setState(() {
        favorites = fav;
      });
      return fav;
    });
  }

  String formatCategoryName(String categoryName) {
    if (categoryName.isEmpty) return '';
    return categoryName[0].toUpperCase() +
        categoryName.substring(1).toLowerCase();
  }

  void addToFavorites(String categoryName) {
    setState(() {
      if (favorites.contains(categoryName)) {
        favorites.remove(categoryName);
      } else {
        favorites.add(categoryName);
      }
      UserService().updateFavoriteCategories(favorites);  // Update favorites in Firestore
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    final isDarkMode = themeModel.mode == ThemeMode.dark;
    final tileShade = isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Categories",
          style: TextStyle(fontFamily: "RosebayRegular", fontSize: 20),
        ),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<String>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No categories available'));
          }

          final categories = snapshot.data!;
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = formatCategoryName(categories[index]);
              final isFavorite = favorites.contains(category);

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 4.0,
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  title: Text(
                    category,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () => addToFavorites(category),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  tileColor: tileShade,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
