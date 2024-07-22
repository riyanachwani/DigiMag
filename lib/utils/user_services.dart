import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, String?>> getUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      String? name = userDoc['name'];
      String? email = user.email;
      return {'name': name, 'email': email};
    } else {
      throw Exception('No user logged in');
    }
  }

  Future<Set<String>> getFavoriteCategories() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentReference userDocRef = _firestore.collection('users').doc(user.uid);
      DocumentSnapshot userDoc = await userDocRef.get();

      // Check if the document exists
      if (!userDoc.exists) {
        await userDocRef.set({
          'Favorites': [], // Initialize with an empty list if the document doesn't exist
        });
        return {}; // Return an empty set if the document was newly created
      }

      // Safely access and check the 'favorites' field
      var data = userDoc.data() as Map<String, dynamic>?;
      if (data != null) {
        List<dynamic>? favorites = data['Favorites'] as List<dynamic>?;
        return favorites != null ? Set<String>.from(favorites) : {};
      } else {
        return {}; // Return an empty set if the data is null
      }
    } else {
      throw Exception('No user logged in');
    }
  }

  Future<void> updateFavoriteCategories(Set<String> favorites) async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentReference userDocRef = _firestore.collection('users').doc(user.uid);
      
      // Update or initialize the 'favorites' field
      await userDocRef.set({
        'favorites': favorites.toList(),
      }, SetOptions(merge: true));
    } else {
      throw Exception('No user logged in');
    }
  }
}
