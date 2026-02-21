import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // We keep the instance private to only allow access through this class
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign Up method
  Future<User?> signUp({
  required String email,
  required String password,
}) async {
  try {
    final UserCredential credential =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
      throw Exception('Account already exists. Please log in.');
    } else if (e.code == 'weak-password') {
      throw Exception('Password is too weak.');
    } else {
      throw Exception(e.message ?? 'Sign up failed.');
    }
  }
}

  // Sign In method
  Future<User?> signIn({required String email, required String password}) 
  async {
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, 
          password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase authentication errors
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');  
      } else {
        throw Exception(e.message ?? 'An unknown error occurred during sign in.');
      }
    } catch (e) {
      throw Exception('System error: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut(); // await is used here to ensure the sign out process completes before we proceed. This is important for maintaining the correct authentication state in the app.
  }
}