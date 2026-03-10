import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_exchange/config/router/app_router.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/error_message.dart';
import 'package:skill_exchange/core/widgets/skeleton_card.dart';
import 'package:skill_exchange/features/connections/providers/connections_provider.dart';
import 'package:skill_exchange/features/connections/widgets/connection_list.dart';
import 'package:skill_exchange/features/connections/widgets/pending_requests.dart';
import 'package:skill_exchange/features/connections/widgets/sent_requests.dart';

class ConnectionsScreen extends ConsumerStatefulWidget {
  const ConnectionsScreen({super.key});

  @override
  ConsumerState<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends ConsumerState<ConnectionsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  void _onMessage(String userId) {
    context.push('${RouteNames.messages}/$userId');
  }

  void _onBook(String userId) {
    context.push(RouteNames.bookings);
  }

  void _onRemove(String id) {
    ref.read(connectionsNotifierProvider.notifier).removeConnection(id);
  }

  void _onRespond(String id, bool accept) {
    ref.read(connectionsNotifierProvider.notifier).respondToRequest(id, accept);
  }

  void _onProfileTap(String userId) {
    context.push('${RouteNames.profile}/$userId');
  }

  // ── Refresh ───────────────────────────────────────────────────────────────

  Future<void> _refreshConnections() async {
    ref.invalidate(connectionsProvider);
  }

  Future<void> _refreshPending() async {
    ref.invalidate(pendingRequestsProvider);
  }

  Future<void> _refreshSent() async {
    ref.invalidate(sentRequestsProvider);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final pendingAsync = ref.watch(pendingRequestsProvider);
    final pendingCount = pendingAsync.whenOrNull(
          data: (list) => list.length,
        ) ??
        0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connections'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            const Tab(text: 'Connections'),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Requests'),
                  if (pendingCount > 0) ...[
                    const SizedBox(width: AppSpacing.xs),
                    _buildBadge(pendingCount),
                  ],
                ],
              ),
            ),
            const Tab(text: 'Sent'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildConnectionsTab(),
          _buildPendingTab(),
          _buildSentTab(),
        ],
      ),
    );
  }

  // ── Tabs ───────────────────────────────────────────────────────────────────

  Widget _buildConnectionsTab() {
    final connectionsAsync = ref.watch(connectionsProvider);

    return connectionsAsync.when(
      loading: () => _buildLoadingSkeleton(),
      error: (error, _) => Center(
        child: ErrorMessage(
          message: error.toString(),
          onRetry: _refreshConnections,
        ),
      ),
      data: (connections) => RefreshIndicator(
        onRefresh: _refreshConnections,
        child: ConnectionList(
          connections: connections,
          onMessage: _onMessage,
          onBook: _onBook,
          onRemove: _onRemove,
          onProfileTap: _onProfileTap,
        ),
      ),
    );
  }

  Widget _buildPendingTab() {
    final pendingAsync = ref.watch(pendingRequestsProvider);

    return pendingAsync.when(
      loading: () => _buildLoadingSkeleton(),
      error: (error, _) => Center(
        child: ErrorMessage(
          message: error.toString(),
          onRetry: _refreshPending,
        ),
      ),
      data: (requests) => RefreshIndicator(
        onRefresh: _refreshPending,
        child: PendingRequests(
          requests: requests,
          onRespond: _onRespond,
          onProfileTap: _onProfileTap,
        ),
      ),
    );
  }

  Widget _buildSentTab() {
    final sentAsync = ref.watch(sentRequestsProvider);

    return sentAsync.when(
      loading: () => _buildLoadingSkeleton(),
      error: (error, _) => Center(
        child: ErrorMessage(
          message: error.toString(),
          onRetry: _refreshSent,
        ),
      ),
      data: (requests) => RefreshIndicator(
        onRefresh: _refreshSent,
        child: SentRequests(
          requests: requests,
          onProfileTap: _onProfileTap,
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Widget _buildLoadingSkeleton() {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      itemCount: 5,
      separatorBuilder: (_, _) =>
          const SizedBox(height: AppSpacing.listItemGap),
      itemBuilder: (_, _) => const SkeletonCard.profile(),
    );
  }

  Widget _buildBadge(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: context.colors.destructive,
        borderRadius: BorderRadius.circular(AppSpacing.xl),
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: AppTextStyles.labelSmall.copyWith(
          color: context.colors.destructiveForeground,
          fontSize: 10,
        ),
      ),
    );
  }
}
