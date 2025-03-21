import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:constatel/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isSigningOut = false;

  User? get currentUser => _auth.currentUser;

  // Check if user is already logged in
  bool get isAuthenticated => _auth.currentUser != null;
  bool get isSigningOut => _isSigningOut;

  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);

    } catch (e) {
      // Handle sign up errors
      throw e;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      // Handle sign in errors
      throw e;
    }
  }
  /// Save user info in Firestore
  Future<void> saveUserInfo(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set({
        'name': user.name,
        'phoneNumber': user.phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> saveUserId(String userId) async {
    try {
      final currentUser = _auth.currentUser;

      if (currentUser != null) {
        await _firestore.collection('users').doc(currentUser.uid).set({
          'userId': userId,
        });
      }
    } catch (e) {
      // Handle errors while saving user ID
      throw e;
    }
  }
  /// Sign in with phone number
  Future<void> signInWithPhoneNumber(
      BuildContext context, String mobile, Function(String) onCodeSent) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: mobile,
      verificationCompleted: (PhoneAuthCredential credential) async {
        UserCredential userCredential =
        await _auth.signInWithCredential(credential);
        await _handleUserLogin(userCredential.user!);
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Error: ${e.code} - ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('Timeout: $verificationId');
      },
    );
  }

  // Save user data after authentication
  Future<void> _handleUserLogin(User user) async {
    DocumentReference userDoc = _firestore.collection('users').doc(user.uid);
    DocumentSnapshot docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      await userDoc.set({
        'uid': user.uid,
        'phoneNumber': user.phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Verify SMS code and sign in
  Future<void> verifySmsCode(BuildContext context, String verificationId, String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      await _handleUserLogin(userCredential.user!);
      notifyListeners();
    } catch (error) {
      print("Verification failed: $error");
    }
  }



  Future<String?> signInAsGuest() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      return userCredential.user?.uid;
    } catch (e) {
      // Handle anonymous sign in errors
      throw e;
    }
  }

  Future<void> signOut() async {
    _isSigningOut = true;
    notifyListeners();  // Notify UI to update the sign-out state

    await _auth.signOut();

    _isSigningOut = false;
    notifyListeners();  // Notify UI again after signing out
  }
}
