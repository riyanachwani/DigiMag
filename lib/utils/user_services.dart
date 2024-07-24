import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, String?>> getUserInfo() async {
    User? user = _auth.currentUser;
    if (user == null) {
      print('No user logged in');
      throw Exception('No user logged in');
    }
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();
    if (!userDoc.exists) {
      print('User document does not exist');
      throw Exception('User document does not exist');
    }
    String? name = userDoc['Name'];
    String? email = user.email;
    return {'Name': name, 'Email': email};
  }

  Future<Set<String>> getFavoriteCategories() async {
    User? user = _auth.currentUser;
    if (user == null) {
      print('No user logged in');
      throw Exception('No user logged in');
    }
    DocumentReference userDocRef = _firestore.collection('users').doc(user.uid);
    DocumentSnapshot userDoc = await userDocRef.get();
    if (!userDoc.exists) {
      await userDocRef.set({
        'Favorites':
            [], // Initialize with an empty list if the document doesn't exist
      });
      return {}; // Return an empty set if the document was newly created
    }
    var data = userDoc.data() as Map<String, dynamic>?;
    List<dynamic>? favorites = data?['Favorites'] as List<dynamic>?;
    return Set<String>.from(favorites ?? []);
  }

  Future<void> updateFavoriteCategories(Set<String> favorites) async {
    User? user = _auth.currentUser;
    if (user == null) {
      print('No user logged in');
      throw Exception('No user logged in');
    }
    DocumentReference userDocRef = _firestore.collection('users').doc(user.uid);
    await userDocRef.set({
      'Favorites': favorites.toList(),
    }, SetOptions(merge: true));
  }
}
