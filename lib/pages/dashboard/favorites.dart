import 'package:flutter/material.dart';
import 'package:digimag/utils/user_services.dart';
import 'package:digimag/utils/api_services.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  Set<String> _favoriteCategories = {};
  UserService userService = UserService();
  ApiService apiService = ApiService();
  List<String> _availableCategories = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _loadAvailableCategories();
  }

  Future<void> _loadFavorites() async {
    try {
      Set<String> favorites = await userService.getFavoriteCategories();
      if (mounted) {
        setState(() {
          _favoriteCategories = favorites;
        });
      }
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
      if (mounted) {
        setState(() {
          _availableCategories = categories;
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

  String _capitalize(String text) {
    if (text == null || text.isEmpty) {
      return '';
    }
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  Future<void> _addFavoriteCategory() async {
    TextEditingController searchController = TextEditingController();
    List<String> filteredCategories = _availableCategories;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Favorite Category'),
          content: _isLoading
              ? Center(child: CircularProgressIndicator())
              : SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: searchController,
                        decoration:
                            InputDecoration(hintText: 'Search categories'),
                        onChanged: (value) {
                          setState(() {
                            filteredCategories = _availableCategories
                                .where((category) => _capitalize(category)
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredCategories.length,
                          itemBuilder: (context, index) {
                            String category = filteredCategories[index];
                            return ListTile(
                              title: Text(_capitalize(category)),
                              onTap: () async {
                                try {
                                  String formattedCategory =
                                      _capitalize(category);
                                  if (!_favoriteCategories
                                      .contains(formattedCategory)) {
                                    await userService
                                        .addFavoriteCategory(formattedCategory);
                                    if (mounted) {
                                      setState(() {
                                        _favoriteCategories
                                            .add(formattedCategory);
                                      });
                                    }
                                  }
                                  Navigator.of(context).pop();
                                } catch (e) {
                                  print('Error adding category: $e');
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _removeFavoriteCategory(String category) async {
    try {
      String formattedCategory = _capitalize(category);
      await userService.removeFavoriteCategory(formattedCategory);
      if (mounted) {
        setState(() {
          _favoriteCategories.remove(formattedCategory);
        });
      }
    } catch (e) {
      print('Error removing category: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Categories'),
      ),
      body: _favoriteCategories.isEmpty
          ? Center(child: Text('No favorite categories'))
          : ListView.builder(
              itemCount: _favoriteCategories.length,
              itemBuilder: (context, index) {
                String category = _favoriteCategories.elementAt(index);
                return ListTile(
                  title: Text(_capitalize(category)),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _removeFavoriteCategory(category),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addFavoriteCategory,
        child: Icon(Icons.add),
      ),
    );
  }
}
