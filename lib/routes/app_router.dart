import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../controllers/app_controller.dart';
import '../shared/widgets/app_widgets.dart';
import '../views/access_screens.dart';
import '../views/conversation_screens.dart';
import '../views/core_screens.dart';
import '../views/management_screens.dart';
import '../views/profile_screens.dart';

GoRouter createAppRouter(AppController controller) {
  GoRouter.optionURLReflectsImperativeAPIs = true;
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: controller.routeRefresh,
    redirect: (context, state) {
      final path = state.uri.path;
      const protectedPaths = {'/profile', '/history', '/settings'};
      final isAdminPath = path == '/admin' || path.startsWith('/admin/');
      final isConversationPath =
          path == '/conversation' || path.startsWith('/conversation/');
      final needsAuthentication =
          isAdminPath || isConversationPath || protectedPaths.contains(path);

      if (needsAuthentication && !controller.isAuthReady) return null;
      if (needsAuthentication && !controller.isAuthenticated) {
        final destination = Uri.encodeComponent(state.uri.toString());
        return '/login?from=$destination';
      }
      if (controller.isAuthenticated && !controller.isProfileActive) {
        return '/login';
      }
      if (isAdminPath && !controller.isAdmin) return '/home';
      if ((path == '/spelling' || path == '/not-found') &&
          controller.currentTranslation == null) {
        return '/translate';
      }
      if (path == '/login' && controller.isAuthenticated) {
        return controller.isAdmin ? '/admin' : '/home';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, _) => const RegisterScreen()),
      GoRoute(
        path: '/forgot-password',
        builder: (_, _) => const ForgotPasswordScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, navigationShell) => _MainShell(shell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/translate',
                builder: (_, _) => const TranslationScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dictionary',
                builder: (_, _) => const DictionaryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (_, _) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      _secondary('/not-found', const WordNotFoundScreen()),
      _secondary('/spelling', const SpellingScreen()),
      _secondary('/history', const HistoryScreen()),
      _secondary('/settings', const SettingsScreen()),
      _secondary('/premium', const PremiumScreen()),
      _secondary('/conversation', const ConversationHomeScreen()),
      GoRoute(
        path: '/conversation/room/:code',
        pageBuilder: (_, state) => _slidePage(
          state,
          ConversationRoomScreen(
            key: ValueKey(state.pathParameters['code']),
            code: state.pathParameters['code'] ?? '',
          ),
        ),
      ),
      GoRoute(path: '/admin', builder: (_, _) => const AdminDashboardScreen()),
      _secondary('/admin/users', const AdminUsersScreen()),
      _secondary('/admin/dictionary', const DictionaryManagementScreen()),
    ],
  );
}

GoRoute _secondary(String path, Widget child) =>
    GoRoute(path: path, pageBuilder: (_, state) => _slidePage(state, child));

CustomTransitionPage<void> _slidePage(GoRouterState state, Widget child) =>
    CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 180),
      reverseTransitionDuration: const Duration(milliseconds: 140),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (MediaQuery.disableAnimationsOf(context)) return child;
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.025),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
    );

class _MainShell extends StatelessWidget {
  const _MainShell({required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) => MobileCanvas(
    child: Scaffold(
      body: shell,
      bottomNavigationBar: AppBottomNav(
        index: shell.currentIndex,
        onDestinationSelected: (index) =>
            shell.goBranch(index, initialLocation: index == shell.currentIndex),
      ),
    ),
  );
}
