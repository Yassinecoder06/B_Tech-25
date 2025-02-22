import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/post_service.dart';
import 'package:flutter_application_1/utils/utils.dart';
import 'package:flutter_application_1/widgets/comment_card.dart';


class CommentsPage extends StatefulWidget {
  final String postId;
  const CommentsPage({super.key, required this.postId});

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController commentEditingController = TextEditingController();

  void postComment(String uid, String name, String profilePic) async {
    try {
      if (commentEditingController.text.isEmpty) {
        if (context.mounted) showSnackBar(context, "Comment cannot be empty");
        return;
      }

      String res = await PostService().postComment(
        widget.postId,
        commentEditingController.text,
        uid,
        name,
        profilePic,
      );

      if (res != 'success') {
        if (context.mounted) showSnackBar(context, res);
      }
      setState(() {
        commentEditingController.text = "";
      });
    } catch (err) {
      if (context.mounted) showSnackBar(context, err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user!.uid);

    return FutureBuilder<DocumentSnapshot>(
      future: userDoc.get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text("Error fetching user data"));
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        String username = userData['username'];
        String profilePic = userData['photoUrl'];

        return buildCommentsPage(username, profilePic, user.uid);
      },
    );
  }

  Widget buildCommentsPage(String username, String profilePic, String uid) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[100],
        title: const Text('Comments'),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => CommentCard(snap: snapshot.data!.docs[index]),
          );
        },
      ),
      bottomNavigationBar: buildCommentInput(username, profilePic, uid),
    );
  }

  Widget buildCommentInput(String username, String profilePic, String uid) {
    return SafeArea(
      child: Container(
        height: kToolbarHeight,
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(profilePic),
              radius: 18,
            ),
            Expanded(
              child: TextField(
                controller: commentEditingController,
                decoration: InputDecoration(
                  hintText: 'Comment as $username',
                  border: InputBorder.none,
                ),
              ),
            ),
            InkWell(
              onTap: () => postComment(uid, username, profilePic),
              child: const Text('Post', style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ),
    );
  }
}
