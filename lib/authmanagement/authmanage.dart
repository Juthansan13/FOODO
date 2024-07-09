import 'package:firebase_auth/firebase_auth.dart';

class AuthManage {
  Future<void> signUp(String userEmail, String userPassword) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }
}
