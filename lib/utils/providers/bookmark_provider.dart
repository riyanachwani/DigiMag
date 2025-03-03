import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:digimag/utils/services/user_services.dart';

class BookmarkProvider extends ChangeNotifier {
  final UserService _userService = UserService();
  List<Map<String, dynamic>> _bookmarks = [];

  List<Map<String, dynamic>> get bookmarks => _bookmarks;

  // Load bookmarks when called
  Future<void> loadBookmarks() async {
    try {
      _bookmarks = await _userService.getBookmarks();
      log("✅ Bookmarks loaded: $_bookmarks");  // Debugging line
      notifyListeners();  // Notify listeners to update UI
    } catch (e) {
      log("❌ Error loading bookmarks: $e");
    }
  }

  // 🟢 Add bookmark and refresh the list
  Future<void> addBookmark(Map<String, dynamic> article) async {
    try {
      await _userService.addBookmark(article);  // Add to Firebase
      log("✅ Bookmark added: ${article['title']}");  // Debugging line
      await loadBookmarks();  // Reload bookmarks after adding
    } catch (e) {
      log("❌ Error adding bookmark: $e");
    }
  }

  // 🔵 Remove bookmark and refresh the list
  Future<void> removeBookmark(String articleId) async {
    try {
      await _userService.removeBookmark(articleId);  // Remove from Firebase
      log("✅ Bookmark removed: $articleId");  // Debugging line
      await loadBookmarks();  // Reload bookmarks after removal
    } catch (e) {
      log("❌ Error removing bookmark: $e");
    }
  }
}
