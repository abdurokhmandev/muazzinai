import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme/colors.dart';
import '../../services/chat_service.dart';
import '../../models/chat_model.dart';
import '../../widgets/glass_container.dart';

final chatServiceProvider = Provider((ref) => ChatService());

final chatStreamProvider = StreamProvider<List<ChatModel>>((ref) {
  return ref.read(chatServiceProvider).getMessages();
});

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    const mockUserId = '12345';
    const mockUserName = 'Abdurahmon';

    ref.read(chatServiceProvider).sendMessage(mockUserId, mockUserName, _messageController.text.trim());
    _messageController.clear();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatStreamProvider);
    const mockUserId = '12345';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.darkGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: chatState.when(
                  loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryPurple)),
                  error: (err, st) => const Center(
                    child: Text(
                      'Chatga ulanishda xatolik: Firebase sozlanmagan.\nOffline rejimida ko\'rinmoqda',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                  data: (messages) {
                    if (messages.isEmpty) {
                      return const Center(
                        child: Text(
                          'Xabarlar yo\'q, birinchi bo\'lib yozing!',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      );
                    }
                    return ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      itemCount: messages.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        final isMe = msg.senderId == mockUserId;
                        return _buildChatBubble(msg, isMe);
                      },
                    );
                  },
                ),
              ),
              _buildInputArea(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 22),
                onPressed: () => context.pop(),
              ),
              const SizedBox(width: 8),
              const Text(
                'Umumiy Chat',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.info_outline_rounded, color: AppColors.textSecondary, size: 24),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(ChatModel msg, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 4),
                child: Text(
                  msg.senderName,
                  style: const TextStyle(
                    color: AppColors.tealCyan,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            GlassContainer(
              borderRadius: 24,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              opacity: isMe ? 0.2 : 0.08,
              gradient: isMe
                  ? const LinearGradient(colors: [AppColors.primaryPurple, AppColors.primaryBlue])
                  : null,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                child: Text(
                  msg.text,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20).copyWith(bottom: MediaQuery.of(context).padding.bottom + 10),
      child: Row(
        children: [
          Expanded(
            child: GlassContainer(
              borderRadius: 24,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              opacity: 0.1,
              child: TextField(
                controller: _messageController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Xabar yozing...',
                  hintStyle: TextStyle(color: AppColors.textMuted),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 54,
              height: 54,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [AppColors.primaryPurple, AppColors.primaryBlue]),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryPurple,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}
