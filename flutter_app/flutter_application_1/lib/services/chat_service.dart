import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/message.dart';

class ChatService {
  final FirebaseFirestore  firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverEmail, String userEmail, String message) async {
    // Get current user information
    final String currentUserEmail = userEmail;
    final String currentReceiverEmail = receiverEmail;
    final Timestamp timestamp = Timestamp.now();

    // Create a new message
    Message newMessage = Message(
      senderEmail: currentUserEmail,
      receiverEmail: currentReceiverEmail,
      message: message,
      timestamp: timestamp,
    );

    // Construct chat room ID for the two users (sorted to ensure uniqueness)
    List<String> ids = [currentUserEmail, currentReceiverEmail];
    ids.sort(); // Sort the IDs to ensure the chatRoomID is the same for any 2 people
    String chatRoomID = ids.join('_');

    // Add new message to database
    await firestore
        .collection("chat rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // Get messages
  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    // Construct a chatroom ID for the two users
    List<String> ids = [userID, otherUserID];
    ids.sort(); // Ensure the chatRoomID is the same for any 2 people
    String chatRoomID = ids.join('_');

    return firestore
        .collection("chat rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}