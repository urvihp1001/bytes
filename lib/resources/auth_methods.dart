// ignore_for_file: avoid_print

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/foundation.dart";
import "package:tech_snap/models/user.dart" as model;
import "package:tech_snap/resources/storage_methods.dart";

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  // Sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    Uint8List? file, // Profile picture
  }) async {
    String res = "";
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty) {
        // Create user in Firebase Authentication
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Upload profile picture
        String photoURL = await Storage().uploadImageToSource(
          'profilePics',
          file!,
          false,
        );

        // Create user object
        model.User user = model.User(
          username: username,
          bio: bio,
          email: email,
          followers: [],
          following: [],
          photoURL: photoURL,
          subscriptions: [],
          uid: cred.user!.uid,
        );

        // Add user to Firestore using UID as document ID
        await _firestore.collection("users").doc(cred.user!.uid).set(
              user.toJson(),
            );

        res = "success";
      } else {
        res = "Please enter all fields";
      }
    } on FirebaseAuthException catch (err) {
      res = err.toString();
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Log in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // Log in the user
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all fields";
      }
    } on FirebaseAuthException catch (err) {
      res = err.toString();
    }
    return res;
  }
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
