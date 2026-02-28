import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String id;
  final String senderId;
  final String senderName;
  final String text;
  final DateTime timestamp;

  ChatModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json, String documentId) {
    return ChatModel(
      id: documentId,
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? 'Foydalanuvchi',
      text: json['text'] ?? '',
      timestamp: (json['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}
