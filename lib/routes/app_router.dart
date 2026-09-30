import 'package:go_router/go_router.dart';

import '../views/access_screens.dart';
import '../views/core_screens.dart';
import '../views/management_screens.dart';
import '../views/profile_screens.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
    GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, _) => const RegisterScreen()),
    GoRoute(
      path: '/forgot-password',
      builder: (_, _) => const ForgotPasswordScreen(),
    ),
    GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
    GoRoute(path: '/translate', builder: (_, _) => const TranslationScreen()),
    GoRoute(path: '/not-found', builder: (_, _) => const WordNotFoundScreen()),
    GoRoute(path: '/spelling', builder: (_, _) => const SpellingScreen()),
    GoRoute(path: '/dictionary', builder: (_, _) => const DictionaryScreen()),
    GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
    GoRoute(path: '/history', builder: (_, _) => const HistoryScreen()),
    GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
    GoRoute(path: '/premium', builder: (_, _) => const PremiumScreen()),
    GoRoute(path: '/admin', builder: (_, _) => const AdminDashboardScreen()),
    GoRoute(path: '/admin/users', builder: (_, _) => const AdminUsersScreen()),
    GoRoute(
      path: '/admin/dictionary',
      builder: (_, _) => const DictionaryManagementScreen(),
    ),
    GoRoute(
      path: '/admin/avatar-editor',
      builder: (_, _) => const AvatarEditorScreen(),
    ),
  ],
);
