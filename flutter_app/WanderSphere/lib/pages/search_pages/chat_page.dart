import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/chat_bubble.dart';
import 'package:flutter_application_1/services/chat_service.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String userEmail;
  final String username;

  ChatPage({super.key, 
    required this.receiverEmail,
    required this.userEmail,
    required this.username,
  });

  final TextEditingController messageController = TextEditingController();
  final ChatService chatService = ChatService();

  Future<void> sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await chatService.sendMessage(receiverEmail, userEmail, messageController.text);
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
      ),
      body: Column(
        children: [
          Expanded(
            child: buildMessageList(),
          ),
          // user input field
          buildMessageInput(),
        ],
      ),
    );
  }

  //build the message list
  Widget buildMessageList() {
    String senderEmail = userEmail;
    return StreamBuilder(
      stream: chatService.getMessages(receiverEmail, senderEmail),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No messages yet.'));
        }

        return ListView(
          children: snapshot.data!.docs.map<Widget>((doc) => buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  // Build message input
  Widget buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          // TextField should take up most of the space
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: 'Enter your message...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          // Send button
          Container(
            decoration: const BoxDecoration(
              color: Colors.purple,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(left: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //build the message item
  Widget buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    //is current user
    bool isCurrentUser = data['senderEmail'] == userEmail;

    //align the message to the right if it is the current user
    var alignement = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignement,
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(
            message: data['message'],
            isCurrentUser: isCurrentUser,
          ),
        ],
      ));
  }
}