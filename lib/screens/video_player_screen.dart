import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:lottie/lottie.dart';
import '../../models/lesson_model.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/text_styles.dart';
import '../../providers/courses_provider.dart';

class VideoPlayerScreen extends ConsumerStatefulWidget {
  final LessonModel lesson;

  const VideoPlayerScreen({required this.lesson, super.key});

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  bool _isCompleted = false;
  bool _showCelebration = false;


  @override
  void initState() {
    super.initState();
    _isCompleted = widget.lesson.isCompleted;
    
    final videoId = YoutubePlayerController.convertUrlToId(widget.lesson.youtubeVideoId) ?? widget.lesson.youtubeVideoId;
    
    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
      ),
    );

    _controller.listen((event) {
      if (event.playerState == PlayerState.ended && !_isCompleted) {
        _markAsComplete();
      }
    });
  }

  void _markAsComplete() {
    if (_isCompleted) return;

    ref
        .read(coursesProvider.notifier)
        .markLessonComplete('c1', widget.lesson.id);

    setState(() {
      _isCompleted = true;
      if (widget.lesson.id == 'l1') {
        _showCelebration = true;
      }
    });

    if (_showCelebration) {
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted) {
          setState(() {
            _showCelebration = false;
          });
        }
      });
    }


    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Dars muvaffaqiyatli yakunlandi!',
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.tealCyan,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      controller: _controller,
      aspectRatio: 16 / 9,
      builder: (context, player) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.textPrimary,
                  ),
                  onPressed: () => context.pop(),
                ),
                title: Text(
                  widget.lesson.unitName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Player with container to maintain aspect ratio
                  Container(
                    color: Colors.black,
                    child: player,
                  ),
                  
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            widget.lesson.title,
                            style: AppTextStyles.h2.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Description
                          Text(
                            widget.lesson.description,
                            style: AppTextStyles.body1.copyWith(
                              color: AppColors.textSecondary.withValues(alpha: 0.8),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Transcription Section
                          if (widget.lesson.transcript.isNotEmpty) ...[
                            const Text(
                              'Dars transkripsiyasi',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                              child: Text(
                                widget.lesson.transcript,
                                style: TextStyle(
                                  color: AppColors.textPrimary.withValues(alpha: 0.9),
                                  fontSize: 15,
                                  height: 1.6,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],

                          // Completion Status/Button
                          _isCompleted
                              ? _buildCompletedBadge()
                              : _buildCompleteButton(),
                          
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_showCelebration)
              Positioned.fill(
                child: IgnorePointer(
                  child: Lottie.network(
                    'https://assets9.lottiefiles.com/packages/lf20_77bw8pqc.json', // Fireworks Lottie
                    repeat: false,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            if (_showCelebration)
              const Center(
                child: IgnorePointer(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'TABRIKLAYMIZ!',
                        style: TextStyle(
                          color: AppColors.yellowGold,
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Birinchi darsni muvaffaqiyatli tugatdingiz',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },

    );
  }

  Widget _buildCompleteButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.tealCyan.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: _markAsComplete,
        icon: const Icon(Icons.check_circle_outline_rounded, size: 24),
        label: const Text(
          'Darsni tugatish',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.tealCyan,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildCompletedBadge() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.tealCyan.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.tealCyan.withValues(alpha: 0.2),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: AppColors.tealCyan,
            size: 28,
          ),
          SizedBox(width: 12),
          Text(
            'Tugalangan',
            style: TextStyle(
              color: AppColors.tealCyan,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}