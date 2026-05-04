import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_exchange/config/router/app_shell.dart';
import 'package:skill_exchange/core/services/fcm_service.dart';
import 'package:skill_exchange/config/router/page_transitions.dart';
import 'package:skill_exchange/features/admin/screens/activity_logs_screen.dart';
import 'package:skill_exchange/features/admin/screens/admin_dashboard_screen.dart';
import 'package:skill_exchange/features/admin/screens/analytics_screen.dart';
import 'package:skill_exchange/features/admin/screens/announcements_screen.dart';
import 'package:skill_exchange/features/admin/screens/community_management_screen.dart';
import 'package:skill_exchange/features/admin/screens/content_moderation_screen.dart';
import 'package:skill_exchange/features/admin/screens/skills_management_screen.dart';
import 'package:skill_exchange/features/admin/screens/user_management_screen.dart';
import 'package:skill_exchange/features/auth/providers/auth_provider.dart';
import 'package:skill_exchange/features/auth/screens/banned_screen.dart';
import 'package:skill_exchange/features/auth/screens/forgot_password_screen.dart';
import 'package:skill_exchange/features/auth/screens/login_screen.dart';
import 'package:skill_exchange/features/auth/screens/reset_password_screen.dart';
import 'package:skill_exchange/features/auth/screens/signup_screen.dart';
import 'package:skill_exchange/features/auth/screens/verify_email_screen.dart';
import 'package:skill_exchange/features/community/screens/community_screen.dart';
import 'package:skill_exchange/features/community/screens/circle_detail_screen.dart';
import 'package:skill_exchange/features/connections/screens/connections_screen.dart';
import 'package:skill_exchange/features/dashboard/screens/dashboard_screen.dart';
import 'package:skill_exchange/features/matching/screens/matching_screen.dart';
import 'package:skill_exchange/features/messaging/screens/chat_screen.dart';
import 'package:skill_exchange/features/messaging/screens/conversations_screen.dart';
import 'package:skill_exchange/features/profile/screens/profile_screen.dart';
import 'package:skill_exchange/features/search/screens/search_screen.dart';
import 'package:skill_exchange/features/sessions/screens/sessions_screen.dart';
import 'package:skill_exchange/features/settings/screens/settings_screen.dart';

// ── Route Names ───────────────────────────────────────────────────────────

class RouteNames {
  RouteNames._();

  // Public (login is the entry point for mobile)
  static const String login = '/';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String verifyEmail = '/verify-email';
  static const String resetPassword = '/reset-password';
  static const String banned = '/banned';

  // Authenticated (under shell)
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String matching = '/matching';
  static const String connections = '/connections';
  static const String messages = '/messages';
  static const String search = '/search';
  static const String community = '/community';
  static const String bookings = '/bookings';
  static const String settings = '/settings';

  // Admin
  static const String adminDashboard = '/admin';
  static const String adminUsers = '/admin/users';
  static const String adminModeration = '/admin/moderation';
  static const String adminCommunity = '/admin/community';
  static const String adminAnalytics = '/admin/analytics';
  static const String adminSkills = '/admin/skills';
  static const String adminAnnouncements = '/admin/announcements';
  static const String adminLogs = '/admin/logs';
}

// ── Router Provider ───────────────────────────────────────────────────────

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: globalNavigatorKey.navigatorKey,
    initialLocation: RouteNames.login,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isAuthenticated = authState is AuthAuthenticated;
      final isAuthRoute = [
        RouteNames.login,
        RouteNames.signup,
        RouteNames.forgotPassword,
        RouteNames.verifyEmail,
        RouteNames.resetPassword,
        RouteNames.banned,
      ].contains(state.matchedLocation);

      // Unauthenticated users can only access auth routes
      if (!isAuthenticated && !isAuthRoute) {
        return '${RouteNames.login}?redirect=${Uri.encodeComponent(state.matchedLocation)}';
      }

      // Authenticated users on auth pages
      if (isAuthenticated && isAuthRoute) {
        // Check if verified
        final authUser = authState as AuthAuthenticated;
        if (!authUser.user.isVerified) {
          return RouteNames.verifyEmail;
        }
        return RouteNames.dashboard;
      }

      // Block unverified users from accessing app screens
      if (isAuthenticated) {
        final authUser = authState as AuthAuthenticated;
        if (!authUser.user.isVerified && state.matchedLocation != RouteNames.verifyEmail) {
          return RouteNames.verifyEmail;
        }
      }

      // Admin route guard
      if (state.matchedLocation.startsWith('/admin')) {
        if (authState is AuthAuthenticated && !authState.user.isAdmin) {
          return RouteNames.dashboard;
        }
      }

      return null;
    },
    routes: [
      // ── Auth routes (fade) ──────────────────────────────────────────
      GoRoute(
        path: RouteNames.login,
        pageBuilder: (context, state) => fadeTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.signup,
        pageBuilder: (context, state) => fadeTransitionPage(
          key: state.pageKey,
          child: const SignupScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        pageBuilder: (context, state) => fadeTransitionPage(
          key: state.pageKey,
          child: const ForgotPasswordScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.verifyEmail,
        pageBuilder: (context, state) => fadeTransitionPage(
          key: state.pageKey,
          child: const VerifyEmailScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.resetPassword,
        pageBuilder: (context, state) => fadeTransitionPage(
          key: state.pageKey,
          child: const ResetPasswordScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.banned,
        pageBuilder: (context, state) => fadeTransitionPage(
          key: state.pageKey,
          child: const BannedScreen(),
        ),
      ),

      // ── Messages (outside shell — no bottom nav) ─────────────────────
      GoRoute(
        path: RouteNames.messages,
        pageBuilder: (context, state) => fadeTransitionPage(
          key: state.pageKey,
          child: const ConversationsScreen(),
        ),
        routes: [
          GoRoute(
            path: ':conversationId',
            pageBuilder: (context, state) => slideUpTransitionPage(
              key: state.pageKey,
              child: ChatScreen(
                conversationId: state.pathParameters['conversationId']!,
              ),
            ),
          ),
        ],
      ),

      // ── Authenticated shell (bottom navigation) ─────────────────────
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          // Shell tab routes → fade
          GoRoute(
            path: RouteNames.dashboard,
            pageBuilder: (context, state) => fadeTransitionPage(
              key: state.pageKey,
              child: const DashboardScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.matching,
            pageBuilder: (context, state) => fadeTransitionPage(
              key: state.pageKey,
              child: const MatchingScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.connections,
            pageBuilder: (context, state) => fadeTransitionPage(
              key: state.pageKey,
              child: const ConnectionsScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.profile,
            pageBuilder: (context, state) => fadeTransitionPage(
              key: state.pageKey,
              child: const ProfileScreen(),
            ),
            routes: [
              // Detail route → slideUp
              GoRoute(
                path: ':userId',
                pageBuilder: (context, state) => slideUpTransitionPage(
                  key: state.pageKey,
                  child: ProfileScreen(
                    userId: state.pathParameters['userId'],
                  ),
                ),
              ),
            ],
          ),
          GoRoute(
            path: RouteNames.search,
            pageBuilder: (context, state) => fadeTransitionPage(
              key: state.pageKey,
              child: const SearchScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.community,
            pageBuilder: (context, state) => fadeTransitionPage(
              key: state.pageKey,
              child: const CommunityScreen(),
            ),
            routes: [
              GoRoute(
                path: ':circleId',
                pageBuilder: (context, state) => slideUpTransitionPage(
                  key: state.pageKey,
                  child: CircleDetailScreen(
                    circleId: state.pathParameters['circleId']!,
                  ),
                ),
              ),
            ],
          ),
          GoRoute(
            path: RouteNames.bookings,
            pageBuilder: (context, state) => fadeTransitionPage(
              key: state.pageKey,
              child: const SessionsScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.settings,
            pageBuilder: (context, state) => fadeTransitionPage(
              key: state.pageKey,
              child: const SettingsScreen(),
            ),
          ),

          // ── Admin routes (fade) ─────────────────────────────────────
          GoRoute(
            path: RouteNames.adminDashboard,
            pageBuilder: (context, state) => fadeTransitionPage(
              key: state.pageKey,
              child: const AdminDashboardScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.adminUsers,
            pageBuilder: (context, state) => fadeTransitionPage(
              key: state.pageKey,
              child: const UserManagementScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.adminModeration,
            pageBuilder: (context, state) => fadeTransitionPage(
              key: state.pageKey,
              child: const ContentModerationScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.adminCommunity,
            pageBuilder: (context, state) => fadeTransitionPage(
              key: state.pageKey,
              child: const CommunityManagementScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.adminAnalytics,
            pageBuilder: (context, state) => fadeTransitionPage(
              key: state.pageKey,
              child: const AnalyticsScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.adminSkills,
            pageBuilder: (context, state) => fadeTransitionPage(
              key: state.pageKey,
              child: const SkillsManagementScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.adminAnnouncements,
            pageBuilder: (context, state) => fadeTransitionPage(
              key: state.pageKey,
              child: const AnnouncementsScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.adminLogs,
            pageBuilder: (context, state) => fadeTransitionPage(
              key: state.pageKey,
              child: const ActivityLogsScreen(),
            ),
          ),
        ],
      ),
    ],
  );
});
