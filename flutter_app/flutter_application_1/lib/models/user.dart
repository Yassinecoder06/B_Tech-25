import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String? photoUrl;
  final String username;
  final String country;
  final List followers;
  final List following;
  final int coins;

  User({required this.username,
      required this.uid,
      required this.photoUrl,
      required this.email,
      required this.country,
      required this.followers,
      required this.following,
      required this.coins});

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      country: snapshot["country"],
      followers: snapshot["followers"],
      following: snapshot["following"],
      coins: snapshot["coins"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'uid': uid,
      'email': email,
      'photoUrl': photoUrl,
      'country': country,
      'followers': followers,
      'following': following,
      'coins': coins,
    };
  }
}
