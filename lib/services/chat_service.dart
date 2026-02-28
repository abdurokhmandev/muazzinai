import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_model.dart';
import '../../config/constants/app_constants.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ChatModel>> getMessages() {
    return _firestore
        .collection(AppConstants.chatCollection)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ChatModel.fromJson(doc.data(), doc.id))
              .toList();
        });
  }

  Future<void> sendMessage(
    String senderId,
    String senderName,
    String text,
  ) async {
    final chat = ChatModel(
      id: '',
      senderId: senderId,
      senderName: senderName,
      text: text,
      timestamp: DateTime.now(),
    );
    await _firestore.collection(AppConstants.chatCollection).add(chat.toJson());
  }
}
