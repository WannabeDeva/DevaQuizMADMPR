import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devaquiz/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign up with email and password
  Future<UserModel?> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Create user with email and password
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      User? user = result.user;
      
      if (user != null) {
        // Create a new user in Firestore
        UserModel newUser = UserModel(
          id: user.uid,
          name: name,
          email: email,
          isAdmin: false, // Default value for new users
        );
        
        // Add user to Firestore
        await _firestore.collection('users').doc(user.uid).set(newUser.toJson());
        
        return newUser;
      }
    } catch (e) {
      print('Error during sign up: $e');
      rethrow;
    }
    return null;
  }

  // Sign in with email and password and verify user type
  Future<UserModel?> signInWithEmailPassword({
    required String email,
    required String password,
    required bool isAdminLogin,
  }) async {
    try {
      // Sign in user with email and password
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      User? user = result.user;
      
      if (user != null) {
        // Get user data from Firestore
        DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
        
        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          bool isAdmin = data['isAdmin'] ?? false;
          
          // Verify user type based on login screen
          if (isAdminLogin && !isAdmin) {
            await _auth.signOut();
            throw 'Not authorized as admin';
          } else if (!isAdminLogin && isAdmin) {
            await _auth.signOut();
            throw 'Admin cannot login as regular user';
          }
          
          return UserModel.fromJson(data, user.uid);
        } else {
          throw 'User data not found';
        }
      }
    } catch (e) {
      print('Error during sign in: $e');
      rethrow;
    }
    return null;
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}