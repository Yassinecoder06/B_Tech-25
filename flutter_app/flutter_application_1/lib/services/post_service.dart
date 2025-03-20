import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/post.dart';
import 'package:flutter_application_1/services/storage_service_supa.dart';
import 'package:uuid/uuid.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(BuildContext context, place, String description, Uint8List file, String uid, String username, String profImage) async {
    String res = "Some error occurred";
    try {
      String? photoUrl = await StorageMethods().uploadImage(context, 'posts', file);
      String postId = Uuid().v1(); // creates unique id based on time
      Post post = Post(
        place: place,
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl!,
        profImage: profImage,
      );
      await _firestore.collection('posts').doc(postId).set(post.toMap());
      res = "success";
    } catch (e) {
      res = "Failed to upload post: ${e.toString()}";
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
  String res = "Some error occurred";
  try {
    if (likes.contains(uid)) {
      await _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayRemove([uid])
      });
      print('Like removed for post $postId by user $uid');
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
        print('Like added for post $postId by user $uid');
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
      print('Error in likePost: $res');
    }
    return res;
  }

  Future<String> postComment(String postId, String text, String uid, String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<QuerySnapshot> getPosts() {
    return _firestore.collection("posts").orderBy("timestamp", descending: true).snapshots();
  }

  Future<QuerySnapshot> getPostsPaginated(DocumentSnapshot? lastDocument) async {
    final int limit = 10;
    final CollectionReference postsRef = _firestore.collection('posts');

    if (lastDocument == null) {
      return await postsRef.orderBy('datePublished', descending: true).limit(limit).get();
    } else {
      return await postsRef.orderBy('datePublished', descending: true).startAfterDocument(lastDocument).limit(limit).get();
    }
  }
}
