import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../ui/screens/splash_screen.dart';
import '../ui/screens/auth/login_screen.dart';
import '../ui/screens/auth/register_screen.dart';
import '../ui/screens/dashboard/widgets/dashboard_screen.dart';
import '../ui/screens/profile/profile_screen.dart';
import '../ui/screens/schedule/schedule_screen.dart';
import '../ui/screens/add_schedule/add_schedule_screen.dart';
import '../ui/screens/detail_activity/detail_activity_screen.dart';
import '../ui/screens/add_activity/add_activity_screen.dart';
import '../ui/shell/app_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return AppShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/schedule',
          builder: (context, state) => const ScheduleScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/add-schedule',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AddScheduleScreen(),
    ),
    GoRoute(
      path: '/detail-activity/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return DetailActivityScreen(activityId: id);
      },
    ),
    GoRoute(
      path: '/add-activity',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AddActivityScreen(),
    ),
  ],
);
