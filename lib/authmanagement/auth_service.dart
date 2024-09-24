// In auth_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  // Create user document in Firestore after sign-in or sign-up
  Future<void> createUserDocument(String userId, String username, String email) async {
    final usersCollection = FirebaseFirestore.instance.collection('users');

    // Check if user already exists
    final userDoc = await usersCollection.doc(userId).get();
    if (!userDoc.exists) {
      // Create user document
      await usersCollection.doc(userId).set({
        'username': username,
        'email': email,
        'donations': [], // Use this only if you're storing donation IDs as an array
      });
    }
  }
}
