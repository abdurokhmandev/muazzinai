import 'dart:async';
import '../models/chat_model.dart';

class ChatService {
  final List<ChatModel> _messages = [];
  final _chatController = StreamController<List<ChatModel>>.broadcast();

  Stream<List<ChatModel>> getMessages() {
    // Return mock messages initially
    if (_messages.isEmpty) {
      _messages.addAll([
        ChatModel(
          id: '1',
          senderId: 'bot',
          senderName: 'Tizim',
          text: 'Super Arab tili chatiga xush kelibsiz!',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
      ]);
    }

    // Immediate first data
    Timer.run(() => _chatController.add(List.from(_messages.reversed)));

    return _chatController.stream;
  }

  Future<void> sendMessage(
    String senderId,
    String senderName,
    String text,
  ) async {
    final chat = ChatModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: senderId,
      senderName: senderName,
      text: text,
      timestamp: DateTime.now(),
    );

    _messages.add(chat);
    _chatController.add(List.from(_messages.reversed));
  }

  void dispose() {
    _chatController.close();
  }
}
