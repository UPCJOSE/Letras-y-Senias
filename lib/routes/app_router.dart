import 'package:go_router/go_router.dart';

import '../views/access_screens.dart';
import '../views/core_screens.dart';
import '../views/management_screens.dart';
import '../views/profile_screens.dart';

final appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
    GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, _) => const RegisterScreen()),
    GoRoute(
      path: '/forgot-password',
      builder: (_, _) => const ForgotPasswordScreen(),
    ),
    GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
    GoRoute(path: '/translate', builder: (_, _) => const TranslationScreen()),
    GoRoute(path: '/dictionary', builder: (_, _) => const DictionaryScreen()),
    GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
    GoRoute(path: '/history', builder: (_, _) => const HistoryScreen()),
    GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
    GoRoute(path: '/premium', builder: (_, _) => const PremiumScreen()),
    GoRoute(
      path: '/company',
      builder: (_, _) => const CompanyDashboardScreen(),
    ),
    GoRoute(
      path: '/company/users',
      builder: (_, _) => const CompanyUsersScreen(),
    ),
    GoRoute(
      path: '/company/import',
      builder: (_, _) => const ImportUsersScreen(),
    ),
    GoRoute(path: '/admin', builder: (_, _) => const AdminDashboardScreen()),
    GoRoute(path: '/admin/users', builder: (_, _) => const AdminUsersScreen()),
    GoRoute(
      path: '/admin/company-users',
      builder: (_, _) =>
          const CompanyUsersScreen(title: 'Clínica Erasmo Ltda.'),
    ),
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
