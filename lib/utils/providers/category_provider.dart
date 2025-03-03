import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:digimag/utils/services/user_services.dart';

class CategoryProvider extends ChangeNotifier {
  final UserService _userService = UserService();
  Set<String> _likedCategories = {};

  Set<String> get likedCategories => _likedCategories;

  CategoryProvider() {
    _loadLikedCategories();
  }

  Future<void> _loadLikedCategories() async {
    _likedCategories = await _userService.getFavoriteCategories();
    notifyListeners(); // 🔄 Notify listeners when liked categories are loaded
  }

  void toggleLikeCategory(String category) {
    if (_likedCategories.contains(category)) {
      _likedCategories.remove(category);
    } else {
      _likedCategories.add(category);
    }
    log("❤️ Liked Categories: $_likedCategories");
    notifyListeners();
  }

  Future<void> toggleCategory(String category) async {
  if (_likedCategories.contains(category)) {
    _likedCategories.remove(category);
  } else {
    _likedCategories.add(category);
  }
  log("❤️ Liked Categories: $_likedCategories");
  notifyListeners();
}

}
