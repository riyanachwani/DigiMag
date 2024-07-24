import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:digimag/utils/user_services.dart';
import 'package:digimag/main.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<Set<String>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = _loadFavorites();
  }

  Future<Set<String>> _loadFavorites() async {
    try {
      return await UserService().getFavoriteCategories();
    } catch (e) {
      print('Error loading favorites: $e');
      return {}; // Return an empty set in case of error
    }
  }

  Future<void> _updateFavorites(String category) async {
    try {
      final Set<String> currentFavorites =
          await UserService().getFavoriteCategories();
      currentFavorites.remove(category);
      await UserService().updateFavoriteCategories(currentFavorites);
      if (mounted) {
        setState(() {
          _favoritesFuture = _loadFavorites(); // Reload the updated favorites
        });
      }
    } catch (e) {
      print('Error updating favorites: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    final isDarkMode = themeModel.mode == ThemeMode.dark;
    final tileShade = isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorites",
          style: TextStyle(fontFamily: "RosebayRegular", fontSize: 20),
        ),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<Set<String>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No favorite categories available'));
          }

          final favorites = snapshot.data!.toList();
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final category = favorites[index];

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
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      // Avoid potential issues with the async method by handling it properly
                      _updateFavorites(category);
                    },
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
