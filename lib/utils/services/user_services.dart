import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Utility method to get the current user
  Future<User?> _getCurrentUser() async {
    User? user = _auth.currentUser;
    if (user == null) {
      log('No user logged in');
    }
    return user;
  }

  // Get user info
  Future<Map<String, String?>> getUserInfo() async {
    User? user = await _getCurrentUser();
    if (user == null) throw Exception('No user logged in');

    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();
    if (!userDoc.exists) throw Exception('User document does not exist');

    String? name = userDoc['Name'];
    String? email = user.email;

    return {'Name': name, 'Email': email};
  }

  // Get favorite categories
  Future<Set<String>> getFavoriteCategories() async {
    User? user = await _getCurrentUser();
    if (user == null) return {}; // Return empty set if no user

    DocumentReference userDocRef = _firestore.collection('users').doc(user.uid);
    DocumentSnapshot userDoc = await userDocRef.get();

    if (!userDoc.exists) {
      // Initialize with an empty list if the document doesn't exist
      await userDocRef.set({'Favorites': []});
      return {}; // Return empty set if the document was newly created
    }

    var data = userDoc.data() as Map<String, dynamic>?;
    List<dynamic>? favorites = data?['Favorites'] as List<dynamic>?;

    return Set<String>.from(favorites ?? []);
  }

  // Update favorite categories
  Future<void> updateFavoriteCategories(Set<String> favorites) async {
    User? user = await _getCurrentUser();
    if (user == null) throw Exception('No user logged in');

    DocumentReference userDocRef = _firestore.collection('users').doc(user.uid);
    await userDocRef
        .set({'Favorites': favorites.toList()}, SetOptions(merge: true));
  }

  // Add a favorite category
  Future<void> addFavoriteCategory(String category) async {
    User? user = await _getCurrentUser();
    if (user == null) return;

    DocumentReference userDocRef = _firestore.collection('users').doc(user.uid);
    await userDocRef.update({
      'Favorites': FieldValue.arrayUnion([category]),
    });
  }

  // Remove a favorite category
  Future<void> removeFavoriteCategory(String category) async {
    User? user = await _getCurrentUser();
    if (user == null) return;

    DocumentReference userDocRef = _firestore.collection('users').doc(user.uid);
    await userDocRef.update({
      'Favorites': FieldValue.arrayRemove([category]),
    });
  }

Future<bool> checkIfBookmarked(String articleTitle) async {
  User? user = await _getCurrentUser();
  if (user != null) {
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('bookmarks')
        .where('title', isEqualTo: articleTitle)
        .get();
    return snapshot.docs.isNotEmpty;
  }
  return false;
}
  // Save an article to bookmarks
  Future<void> addBookmark(Map<String, dynamic> article) async {
    User? user = await _getCurrentUser();
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('bookmarks')
          .add(article);
    }
  }

  // Remove an article from bookmarks
  Future<void> removeBookmark(String articleId) async {
    User? user = await _getCurrentUser();
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('bookmarks')
          .doc(articleId)
          .delete();
    }
  }

  // Get all bookmarked articles
  Future<List<Map<String, dynamic>>> getBookmarks() async {
    User? user = await _getCurrentUser();
    if (user != null) {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('bookmarks')
          .get();
      return snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    }
    return [];
  }
}
