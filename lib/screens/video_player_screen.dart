import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
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
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.lesson.youtubeVideoId,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    )..addListener(_listener);
  }

  void _listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      // Optional: auto-mark as complete when video ends
      if (_controller.value.playerState == PlayerState.ended &&
          !widget.lesson.isCompleted) {
        _markAsComplete();
      }
    }
  }

  void _markAsComplete() {
    ref
        .read(coursesProvider.notifier)
        .markLessonComplete('c1', widget.lesson.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Dars muvaffaqiyatli yakunlandi!',
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.tealCyan,
      ),
    );
    // context.pop(); // Optionally navigate back
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // Handle fullscreen exit
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppColors.yellowGold,
        progressColors: const ProgressBarColors(
          playedColor: AppColors.yellowGold,
          handleColor: AppColors.yellowGold,
        ),
        onReady: () {
          _isPlayerReady = true;
        },
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => context.pop(),
            ),
            title: Text(
              widget.lesson.unitName,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              player,
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.lesson.title, style: AppTextStyles.h2),
                      const SizedBox(height: 16),
                      Text(
                        widget.lesson.description,
                        style: AppTextStyles.body1,
                      ),
                      const SizedBox(height: 24),
                      const Text('Transkripsiya', style: AppTextStyles.h3),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Text(
                          widget.lesson.transcript,
                          style: AppTextStyles.body2.copyWith(height: 1.5),
                        ),
                      ),
                      const SizedBox(height: 32),
                      if (!widget.lesson.isCompleted)
                        ElevatedButton.icon(
                          onPressed: _markAsComplete,
                          icon: const Icon(Icons.check_circle_outline_rounded),
                          label: const Text(
                            'Darsni tugatish',
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.tealCyan,
                            minimumSize: const Size.fromHeight(56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.tealCyan.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.tealCyan,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Tugallangan',
                                style: TextStyle(
                                  color: AppColors.tealCyan,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
