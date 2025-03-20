import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/storage_service_supa.dart';
import 'package:flutter_application_1/utils/utils.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AIPage extends StatefulWidget {
  const AIPage({super.key});

  @override
  State<AIPage> createState() => _AIPageState();
}

class _AIPageState extends State<AIPage> {
  final Gemini gemini = Gemini.instance;
  String? _username;
  String? _photoUrl;
  String uid = auth.FirebaseAuth.instance.currentUser!.uid;
  ChatUser? currUser;
  List<ChatMessage> messages = [];
  Uint8List? _image;
  bool isTyping = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          _username = userDoc['username'] ?? 'Anonymous';
          _photoUrl = userDoc['photoUrl'] ?? '';

          currUser = ChatUser(
            id: uid,
            firstName: _username,
            profileImage: _photoUrl?.isNotEmpty == true
                ? _photoUrl
                : 'https://default-profile-image-url',
          );
        });
      }
    }
  }

  ChatUser geminiUser = ChatUser(
    id: 'ai',
    firstName: 'Wander Sphere ChatBot',
    profileImage:
        'https://uhdtgzffszdjaeibbyxc.supabase.co/storage/v1/object/public/images/uploads/profilePics/logo.png',
  );

  void _sendMessage(ChatMessage chatMessage) async {
    if (chatMessage.text.trim().isEmpty && (chatMessage.medias?.isEmpty ?? true)) {
      return;
    }

    setState(() {
      messages.insert(0, chatMessage);
      isTyping = true;
    });

    try {
      String question = chatMessage.text;
      List<Uint8List>? images;

      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = await Future.wait(chatMessage.medias!.map(
          (media) async => await _getImageBytes(media.url),
        ));
      }

      // Create an AI response message with an empty text initially
      ChatMessage aiMessage = ChatMessage(
        text: "",
        user: geminiUser,
        createdAt: DateTime.now(),
      );

      setState(() {
        messages.insert(0, aiMessage); // Insert AI message only once
      });

      // Listen for AI response
      gemini.streamGenerateContent(question, images: images).listen((event) {
        String responseChunk = event.content?.parts?.fold(
              '',
              (prev, curr) => "$prev ${(curr is TextPart ? curr.text : '')}",
            ) ??
            '';

        if (responseChunk.isNotEmpty) {
          setState(() {
            // Find the last AI message and update its text
            for (int i = 0; i < messages.length; i++) {
              if (messages[i].user.id == 'ai') {
                messages[i] = ChatMessage(
                  text: messages[i].text + responseChunk, // Append new text
                  user: messages[i].user,
                  createdAt: messages[i].createdAt,
                  medias: messages[i].medias,
                  customProperties: messages[i].customProperties,
                );
                break;
              }
            }
          });
        }
      }, onDone: () {
        setState(() {
          isTyping = false;
        });
      }, onError: (error) {
        print("Error generating AI response: $error");
        setState(() {
          isTyping = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to process message')),
        );
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        isTyping = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong')),
      );
    }
  }


  void _sendMediaMessage() async {
    try {
      Uint8List im = await pickImage(ImageSource.gallery);
      setState(() {
        _image = im;
      });

      if (_image == null) return;

      String? photoUrl = await StorageMethods()
          .uploadImage(context, 'AI_uploadedPics', _image!);

      if (photoUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image')),
        );
        return;
      }

      String? description = await _promptUserForImageDescription();
      if (description == null || description.isEmpty) {
        description = 'Analyze this image';
      }

      ChatMessage message = ChatMessage(
        text: description,
        user: currUser!,
        medias: [
          ChatMedia(url: photoUrl, fileName: "", type: MediaType.image)
        ],
        createdAt: DateTime.now(),
      );

      _sendMessage(message);
    } catch (e) {
      print("Error sending media message: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send media message')),
      );
    }
  }

  Future<String?> _promptUserForImageDescription() async {
    return await showDialog<String>(
      context: context,
      builder: (context) {
        String input = '';
        return AlertDialog(
          title: const Text('Write your prompt'),
          content: TextField(
            onChanged: (value) {
              input = value;
            },
            decoration: const InputDecoration(hintText: 'Write your prompt'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(input);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<Uint8List> _getImageBytes(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wander Sphere ChatBot'),
      ),
      body: (currUser == null)
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: DashChat(
                    inputOptions: InputOptions(trailing: [
                      IconButton(
                          onPressed: _sendMediaMessage,
                          icon: const Icon(Icons.image)),
                    ]),
                    currentUser: currUser!,
                    onSend: _sendMessage,
                    messages: messages,
                    typingUsers: isTyping ? [geminiUser] : [],
                  ),
                ),
                if (isTyping)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Wander Sphere ChatBot is typing...'),
                  ),
              ],
            ),
    );
  }
}
