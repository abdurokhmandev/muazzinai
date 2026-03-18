import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(appProvider).user;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildUserInfo(context, ref, user),
            const SizedBox(height: 32),
            _buildCertificateCTA(),
            const SizedBox(height: 32),
            _buildSectionHeader('Yutuqlar'),
            const SizedBox(height: 16),
            _buildAchievements(),
            const SizedBox(height: 32),
            _buildSectionHeader('Faollik'),
            const SizedBox(height: 16),
            _buildActivityCard(),
            const SizedBox(height: 32),
            _buildSectionHeader('Kurslarim'),
            const SizedBox(height: 16),
            _buildMyCourses(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, WidgetRef ref, user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _showEmojiPicker(context, ref),
            child: Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFF63DC8A),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      user.profileEmoji,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      size: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _showNameEditor(context, ref, user.name),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.edit_outlined,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Qo\'shilgan: Avgust 2025',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEmojiPicker(BuildContext context, WidgetRef ref) {
    final emojis = [
      '🇸🇦',
      '🧕',
      '👳',
      '🕌',
      '📖',
      '🌟',
      '🐪',
      '🌴',
      '⚔️',
      '🌙',
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profil rasmini tanlang',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: emojis
                  .map(
                    (e) => GestureDetector(
                      onTap: () {
                        ref.read(appProvider).updateUser(profileEmoji: e);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(e, style: const TextStyle(fontSize: 30)),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showNameEditor(
    BuildContext context,
    WidgetRef ref,
    String currentName,
  ) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ismni tahrirlash'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Ismingizni kiriting'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Bekor qilish'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(appProvider).updateUser(name: controller.text);
              Navigator.pop(context);
            },
            child: const Text('Saqlash'),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificateCTA() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF951A),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            '2+6 SERTIFIKATINI OLISH',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Barchasi',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    final achievements = [
      {'label': 'So\'z jangchisi', 'icon': Icons.shield_outlined},
      {'label': 'Vunderkind', 'icon': Icons.school_outlined},
      {'label': 'Marafonchi', 'icon': Icons.directions_run_outlined},
      {'label': 'Tezkor o\'quvchi', 'icon': Icons.bolt_outlined},
    ];

    return SizedBox(
      height: 120,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: achievements.length,
        separatorBuilder: (context, index) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                ),
                child: Center(
                  child: Icon(
                    achievements[index]['icon'] as IconData,
                    color: Colors.grey.shade500,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                achievements[index]['label'] as String,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActivityCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.access_time_filled_rounded,
                color: Color(0xFFFF5277),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sarflangan',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  const Text(
                    '6 daqiqa',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFFF951A).withValues(alpha: 0.5),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Text(
                    'Haftalik',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: Colors.grey.shade500,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyCourses() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return Container(
            width: 140,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FA),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: index == 0
                      ? const Text('🇸🇦', style: TextStyle(fontSize: 20))
                      : const Icon(
                          Icons.emoji_events_outlined,
                          color: Colors.amber,
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
