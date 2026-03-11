import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screens/auth/splash_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/signup_screen.dart';

import '../../screens/home_screen.dart';
import '../../screens/vocabulary_screen.dart';
import '../../screens/chat_screen.dart';
import '../../screens/leaderboard_screen.dart';
import '../../screens/profile_screen.dart';
import '../../screens/speaking_club_screen.dart';
import '../../games/games.dart';
import '../../screens/mock_exam_screen.dart';
import '../../screens/premium_screen.dart';
import '../../screens/video_player_screen.dart';
import '../../models/lesson_model.dart';

import '../../widgets/custom_bottom_nav.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'shell',
);

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return CustomBottomNav(child: child);
        },
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          GoRoute(
            path: '/games',
            builder: (context, state) => const GamePage(),
          ),
          GoRoute(
            path: '/vocabulary',
            builder: (context, state) => const VocabularyScreen(),
          ),
          GoRoute(
            path: '/chat',
            builder: (context, state) => const ChatScreen(),
          ),
          GoRoute(
            path: '/leaderboard',
            builder: (context, state) => const LeaderboardScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      // Independent routes (not in Bottom Nav)
      GoRoute(
        path: '/speaking',
        builder: (context, state) => const SpeakingClubScreen(),
      ),
      GoRoute(
        path: '/exam',
        builder: (context, state) => const MockExamScreen(),
      ),
      GoRoute(
        path: '/premium',
        builder: (context, state) => const PremiumScreen(),
      ),
      GoRoute(
        path: '/videos/play/:id',
        builder: (context, state) {
          final lesson = state.extra as LessonModel;
          return VideoPlayerScreen(lesson: lesson);
        },
      ),
    ],
  );
}
