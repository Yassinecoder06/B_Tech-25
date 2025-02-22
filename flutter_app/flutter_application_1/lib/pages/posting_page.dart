import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:flutter_application_1/services/post_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostingPage extends StatefulWidget {
  const PostingPage({super.key});

  @override
  _PostingPageState createState() => _PostingPageState();
}

class _PostingPageState extends State<PostingPage> {
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  Uint8List? _file;
  final PostService _postService = PostService();
  bool _isLoading = false;
  String? _username;
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
      if (userDoc.exists) {
        setState(() {
          _username = userDoc['username'] ?? 'Anonymous';
          _photoUrl = userDoc['photoUrl'] ?? '';
        });
      }
    }
  }

  void _selectImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final Uint8List file = await image.readAsBytes();
      setState(() {
        _file = file;
      });
    }
  }

  void _postImage() async {
    setState(() {
      _isLoading = true;
    });

    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
      if (!userDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      String res = await _postService.uploadPost(
        context,
        _placeController.text,
        _descriptionController.text,
        _file!,
        userDoc['uid'],
        _username ?? 'Anonymous',
        _photoUrl ?? '',
      );

      setState(() {
        _isLoading = false;
      });

      if (res == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Posted!')),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res)),
        );
      }
    }
  }

  @override
  void dispose() {
    _placeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: _postImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "Post",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _isLoading
                ? const LinearProgressIndicator()
                : const SizedBox(),
            const Divider(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: _photoUrl != null && _photoUrl!.isNotEmpty
                      ? NetworkImage(_photoUrl!)
                      : const AssetImage('assets/profile_placeholder.jpg')
                          as ImageProvider,
                  radius: 40,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _username ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: _placeController,
                        decoration: const InputDecoration(
                          hintText: "Where was this taken?",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: "What's on your mind?",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 15),
            _file == null
                ? const Text('No image selected.')
                : Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.memory(
                        _file!,
                        width: MediaQuery.of(context).size.width,
                        height: 600,
                        //fit: BoxFit.cover,
                      ),
                    ),
                  ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _selectImage,
              icon: const Icon(Icons.photo_library),
              label: const Text("Select Image"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
