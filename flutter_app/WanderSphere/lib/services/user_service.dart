import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/models/user.dart' as model;

class UserMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get user details
  Future<model.User?> getUserDetails() async {
    User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      return null; // Return null instead of throwing an exception
    }

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    if (!documentSnapshot.exists) {
      return null; // Handle case where user document doesn't exist
    }

    return model.User.fromSnap(documentSnapshot);
  }
}
