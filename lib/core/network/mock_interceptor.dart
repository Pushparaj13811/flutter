/// Dio interceptor that returns fake data for every API endpoint.
///
/// Enabled via `--dart-define=ENABLE_MOCK_DATA=true` or by default during
/// development when no backend is available.
library;

import 'dart:math';

import 'package:dio/dio.dart';

class MockInterceptor extends Interceptor {
  static const _delay = Duration(milliseconds: 400);

  /// Tracks whether the last login was admin (simple stateful flag for mocking)
  static bool _isAdminSession = false;

  // ── Reusable profile snippets ──────────────────────────────────────────

  static const _demoUserId = 'user_demo_001';

  static Map<String, dynamic> _availability({
    bool mon = true,
    bool tue = true,
    bool wed = false,
    bool thu = true,
    bool fri = true,
    bool sat = false,
    bool sun = false,
  }) =>
      {
        'monday': mon,
        'tuesday': tue,
        'wednesday': wed,
        'thursday': thu,
        'friday': fri,
        'saturday': sat,
        'sunday': sun,
      };

  static Map<String, dynamic> _stats({
    int connections = 12,
    int sessions = 5,
    int reviews = 3,
    double rating = 4.5,
  }) =>
      {
        'connectionsCount': connections,
        'sessionsCompleted': sessions,
        'reviewsReceived': reviews,
        'averageRating': rating,
      };

  static Map<String, dynamic> _skill(
    String id,
    String name,
    String category,
    String level,
  ) =>
      {'id': id, 'name': name, 'category': category, 'level': level};

  static Map<String, dynamic> _profile({
    required String id,
    required String username,
    required String fullName,
    required String email,
    String? avatar,
    String bio = '',
    String location = 'San Francisco, CA',
    String timezone = 'America/Los_Angeles',
    List<String> languages = const ['English'],
    List<Map<String, dynamic>>? skillsToTeach,
    List<Map<String, dynamic>>? skillsToLearn,
    List<String> interests = const ['Web Development'],
    Map<String, dynamic>? availability,
    String learningStyle = 'visual',
    Map<String, dynamic>? stats,
  }) =>
      {
        'id': id,
        'username': username,
        'email': email,
        'fullName': fullName,
        'avatar': avatar,
        'bio': bio,
        'location': location,
        'timezone': timezone,
        'languages': languages,
        'skillsToTeach': skillsToTeach ??
            [_skill('s1', 'Flutter', 'Mobile', 'advanced')],
        'skillsToLearn': skillsToLearn ??
            [_skill('s2', 'React', 'Frontend', 'beginner')],
        'interests': interests,
        'availability': availability ?? _availability(),
        'preferredLearningStyle': learningStyle,
        'joinedAt': '2024-01-15T10:00:00Z',
        'lastActive': '2026-03-07T14:30:00Z',
        'stats': stats ?? _stats(),
      };

  // The logged-in demo user
  static Map<String, dynamic> get _demoProfile => _profile(
        id: _demoUserId,
        username: 'demo',
        fullName: 'Demo User',
        email: 'demo@skillexchange.com',
        bio: 'Full-stack developer passionate about teaching and learning.',
        skillsToTeach: [
          _skill('s1', 'Flutter', 'Mobile', 'advanced'),
          _skill('s3', 'Dart', 'Programming', 'advanced'),
        ],
        skillsToLearn: [
          _skill('s2', 'React', 'Frontend', 'beginner'),
          _skill('s4', 'Python', 'Programming', 'intermediate'),
        ],
        interests: ['Mobile Development', 'Web Development', 'Open Source'],
        stats: _stats(connections: 12, sessions: 8, reviews: 6, rating: 4.7),
      );

  // Other mock users
  static final _otherUsers = <Map<String, dynamic>>[
    _profile(
      id: 'user_002',
      username: 'janedoe',
      fullName: 'Jane Doe',
      email: 'jane@example.com',
      bio: 'Python expert, data science enthusiast.',
      location: 'New York, NY',
      skillsToTeach: [
        _skill('s4', 'Python', 'Programming', 'expert'),
        _skill('s5', 'Data Science', 'Data Science', 'advanced'),
      ],
      skillsToLearn: [
        _skill('s1', 'Flutter', 'Mobile', 'beginner'),
      ],
      interests: ['Data Science', 'Machine Learning'],
      stats: _stats(connections: 8, sessions: 3, reviews: 2, rating: 4.2),
    ),
    _profile(
      id: 'user_003',
      username: 'bobsmith',
      fullName: 'Bob Smith',
      email: 'bob@example.com',
      bio: 'Cloud architect and DevOps specialist.',
      location: 'Seattle, WA',
      skillsToTeach: [
        _skill('s6', 'AWS', 'Cloud', 'expert'),
        _skill('s7', 'Docker', 'DevOps', 'advanced'),
      ],
      skillsToLearn: [
        _skill('s3', 'Dart', 'Programming', 'beginner'),
      ],
      interests: ['Cloud Computing', 'DevOps'],
      stats: _stats(connections: 15, sessions: 10, reviews: 8, rating: 4.8),
    ),
    _profile(
      id: 'user_004',
      username: 'alicew',
      fullName: 'Alice Williams',
      email: 'alice@example.com',
      bio: 'UI/UX designer who loves clean interfaces.',
      location: 'Austin, TX',
      skillsToTeach: [
        _skill('s8', 'Figma', 'Design', 'expert'),
        _skill('s9', 'UI Design', 'Design', 'advanced'),
      ],
      skillsToLearn: [
        _skill('s1', 'Flutter', 'Mobile', 'intermediate'),
        _skill('s2', 'React', 'Frontend', 'beginner'),
      ],
      interests: ['Design', 'User Experience'],
      stats: _stats(connections: 20, sessions: 12, reviews: 10, rating: 4.9),
    ),
    _profile(
      id: 'user_005',
      username: 'carlos_m',
      fullName: 'Carlos Martinez',
      email: 'carlos@example.com',
      bio: 'Blockchain developer and smart contract auditor.',
      location: 'Miami, FL',
      skillsToTeach: [
        _skill('s10', 'Solidity', 'Blockchain', 'expert'),
        _skill('s11', 'Web3', 'Blockchain', 'advanced'),
      ],
      skillsToLearn: [
        _skill('s4', 'Python', 'Programming', 'intermediate'),
      ],
      interests: ['Blockchain', 'Crypto', 'DeFi'],
      stats: _stats(connections: 6, sessions: 4, reviews: 3, rating: 4.3),
    ),
    _profile(
      id: 'user_006',
      username: 'priya_s',
      fullName: 'Priya Sharma',
      email: 'priya@example.com',
      bio: 'Full-stack engineer specializing in Node.js and React.',
      location: 'Chicago, IL',
      skillsToTeach: [
        _skill('s2', 'React', 'Frontend', 'expert'),
        _skill('s12', 'Node.js', 'Backend', 'advanced'),
      ],
      skillsToLearn: [
        _skill('s1', 'Flutter', 'Mobile', 'beginner'),
        _skill('s6', 'AWS', 'Cloud', 'intermediate'),
      ],
      interests: ['Web Development', 'Full Stack'],
      stats: _stats(connections: 18, sessions: 15, reviews: 12, rating: 4.6),
    ),
  ];

  // ── Interceptor ────────────────────────────────────────────────────────

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    await Future<void>.delayed(_delay);

    final path = options.path;
    final method = options.method.toUpperCase();

    final response = _route(method, path, options);
    if (response != null) {
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: response,
        ),
      );
    } else {
      // Fallback — unknown route
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {'data': {}, 'message': 'Mock: unhandled route', 'success': true},
        ),
      );
    }
  }

  // ── Router ─────────────────────────────────────────────────────────────

  Map<String, dynamic>? _route(
    String method,
    String path,
    RequestOptions options,
  ) {
    // ── Auth ──────────────────────────────────────────────────────────
    if (path == '/auth/login' && method == 'POST') return _loginResponse(options);
    if (path == '/auth/signup' && method == 'POST') return _signupResponse(options);
    if (path == '/auth/logout' && method == 'POST') return _ok('Logged out');
    if (path == '/auth/me' && method == 'GET') return _currentUser();
    if (path == '/auth/forgot-password') return _ok('Reset link sent');
    if (path == '/auth/reset-password') return _ok('Password reset');
    if (path == '/auth/verify-email') return _ok('Email verified');
    if (path == '/auth/change-password') return _ok('Password changed');
    if (path == '/auth/refresh') return _refreshToken();

    // ── Profile ───────────────────────────────────────────────────────
    if (path == '/profiles/me' && method == 'GET') return _wrap(_demoProfile);
    if (path == '/profiles/me' && method == 'PUT') return _wrap(_demoProfile);
    if (path.startsWith('/profiles/') && method == 'GET') {
      return _profileById(path.split('/').last);
    }

    // ── Skills ────────────────────────────────────────────────────────
    if (path == '/skills' && method == 'GET') return _allSkills();
    if (path == '/skills/categories') return _skillCategories();

    // ── Matching ──────────────────────────────────────────────────────
    if (path == '/matching' && method == 'GET') return _matchesPaginated(options);
    if (path == '/matching/suggestions') return _topMatches();

    // ── Connections ───────────────────────────────────────────────────
    if (path == '/connections' && method == 'GET') return _connectionsList();
    if (path == '/connections/pending') return _pendingConnections();
    if (path == '/connections/sent') return _sentConnections();
    if (path == '/connections/request' && method == 'POST') {
      return _sendConnectionRequest(options);
    }
    if (path.contains('/connections/') && path.endsWith('/respond')) {
      return _respondConnection(path);
    }
    if (path.contains('/connections/') && path.endsWith('/status')) {
      return _wrap({'status': 'accepted'});
    }
    if (path.startsWith('/connections/') && method == 'DELETE') {
      return _ok('Connection removed');
    }

    // ── Sessions ──────────────────────────────────────────────────────
    if (path == '/sessions/upcoming') return _upcomingSessions();
    if (path == '/sessions' && method == 'POST') return _createSession(options);
    if (path.contains('/sessions/') && path.endsWith('/cancel')) {
      return _sessionAction(path, 'cancelled');
    }
    if (path.contains('/sessions/') && path.endsWith('/complete')) {
      return _sessionAction(path, 'completed');
    }
    if (path.contains('/sessions/') && path.endsWith('/reschedule')) {
      return _sessionAction(path, 'scheduled');
    }

    // ── Reviews ───────────────────────────────────────────────────────
    if (path == '/reviews' && method == 'POST') return _createReview(options);
    if (path.startsWith('/reviews/user/') && path.endsWith('/stats')) {
      return _reviewStats();
    }
    if (path.startsWith('/reviews/user/')) return _userReviews();

    // ── Messages ──────────────────────────────────────────────────────
    if (path == '/messages/conversations' && method == 'GET') {
      return _conversations();
    }
    if (path.startsWith('/messages/conversations/') && method == 'GET') {
      return _conversationMessages(path);
    }
    if (path == '/messages' && method == 'POST') return _sendMessage(options);
    if (path.contains('/messages/') && path.endsWith('/read')) {
      return _ok('Marked as read');
    }

    // ── Notifications ─────────────────────────────────────────────────
    if (path == '/notifications' && method == 'GET') return _notifications();
    if (path == '/notifications/unread-count') return _wrap({'count': 3});
    if (path == '/notifications/read-all') return _ok('All read');
    if (path.contains('/notifications/') && path.endsWith('/read')) {
      return _ok('Notification read');
    }
    if (path.startsWith('/notifications/') && method == 'DELETE') {
      return _ok('Notification deleted');
    }

    // ── Search ────────────────────────────────────────────────────────
    if (path == '/search/users') return _searchUsers(options);

    // ── Community ─────────────────────────────────────────────────────
    if (path == '/community/posts' && method == 'GET') return _communityPosts();
    if (path == '/community/posts' && method == 'POST') {
      return _createPost(options);
    }
    if (path.contains('/community/posts/') && path.endsWith('/like')) {
      return method == 'POST'
          ? _ok('Post liked')
          : _ok('Post unliked');
    }
    if (path == '/community/circles' && method == 'GET') return _circles();
    if (path == '/community/circles' && method == 'POST') {
      return _createCircle(options);
    }
    if (path.contains('/circles/') && path.endsWith('/join')) {
      return _ok('Joined circle');
    }
    if (path.contains('/circles/') && path.endsWith('/leave')) {
      return _ok('Left circle');
    }
    if (path == '/community/leaderboard') return _leaderboard();

    // ── Admin ─────────────────────────────────────────────────────────
    if (path == '/reports' && method == 'GET') return _reports();
    if (path == '/reports' && method == 'POST') return _createReport(options);
    if (path.startsWith('/reports/') && method == 'PUT') {
      return _updateReport(path);
    }
    if (path == '/admin/stats') return _platformStats();

    // Admin community posts
    if (path == '/admin/community/posts' && method == 'GET') {
      return _adminPosts();
    }
    if (path.contains('/admin/community/posts/') &&
        path.endsWith('/pin') &&
        method == 'PUT') {
      return _ok('Pin toggled');
    }
    if (path.contains('/admin/community/posts/') &&
        path.endsWith('/hide') &&
        method == 'PUT') {
      return _ok('Visibility toggled');
    }
    if (path.startsWith('/admin/community/posts/') && method == 'DELETE') {
      return _ok('Post deleted');
    }

    // Admin community circles
    if (path == '/admin/community/circles' && method == 'GET') {
      return _adminCircles();
    }
    if (path.contains('/admin/community/circles/') &&
        path.endsWith('/feature') &&
        method == 'PUT') {
      return _ok('Featured toggled');
    }
    if (path.startsWith('/admin/community/circles/') && method == 'PUT') {
      return _ok('Circle updated');
    }
    if (path.startsWith('/admin/community/circles/') && method == 'DELETE') {
      return _ok('Circle deleted');
    }

    // Admin analytics
    if (path == '/admin/analytics' && method == 'GET') {
      return _analyticsData();
    }

    // Admin skills
    if (path == '/admin/skills' && method == 'GET') return _adminSkills();
    if (path == '/admin/skills' && method == 'POST') return _ok('Skill created');
    if (path.startsWith('/admin/skills/') && method == 'PUT') {
      return _ok('Skill updated');
    }
    if (path.startsWith('/admin/skills/') && method == 'DELETE') {
      return _ok('Skill deleted');
    }

    // Admin announcements
    if (path == '/admin/announcements' && method == 'GET') {
      return _announcements();
    }
    if (path == '/admin/announcements' && method == 'POST') {
      return _ok('Announcement created');
    }
    if (path.startsWith('/admin/announcements/') && method == 'DELETE') {
      return _ok('Announcement deleted');
    }

    // Admin activity logs
    if (path == '/admin/activity-logs' && method == 'GET') {
      return _activityLogs();
    }

    // ── Uploads ───────────────────────────────────────────────────────
    if (path == '/uploads/avatar') {
      return _wrap({'url': 'https://i.pravatar.cc/300?u=$_demoUserId'});
    }

    return null;
  }

  // ── Response helpers ───────────────────────────────────────────────────

  Map<String, dynamic> _wrap(dynamic data) => {'data': data};

  Map<String, dynamic> _ok(String message) =>
      {'message': message, 'success': true};

  Map<String, dynamic> _wrapPaginated(
    List<dynamic> data, {
    int page = 1,
    int pageSize = 20,
    int? totalItems,
  }) {
    final total = totalItems ?? data.length;
    return {
      'data': data,
      'pagination': {
        'page': page,
        'pageSize': pageSize,
        'totalItems': total,
        'totalPages': (total / pageSize).ceil(),
        'hasNextPage': page * pageSize < total,
        'hasPreviousPage': page > 1,
      },
    };
  }

  // ── Auth ────────────────────────────────────────────────────────────────

  Map<String, dynamic> _loginResponse(RequestOptions options) {
    final body = options.data as Map<String, dynamic>? ?? {};
    final email = body['email'] as String? ?? '';
    final isAdmin = email == 'admin@skillexchange.com';
    _isAdminSession = isAdmin;

    return _wrap({
      'accessToken':
          'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
      'refreshToken': 'mock_refresh_token',
      'user': {
        'id': isAdmin ? 'user_admin_001' : _demoUserId,
        'email': isAdmin ? 'admin@skillexchange.com' : 'demo@skillexchange.com',
        'name': isAdmin ? 'Admin User' : 'Demo User',
        'avatar': null,
        'role': isAdmin ? 'admin' : 'user',
      },
    });
  }

  Map<String, dynamic> _signupResponse(RequestOptions options) {
    final body = options.data as Map<String, dynamic>? ?? {};
    return _wrap({
      'accessToken': 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
      'refreshToken': 'mock_refresh_token',
      'user': {
        'id': 'user_new_${DateTime.now().millisecondsSinceEpoch}',
        'email': body['email'] ?? 'new@skillexchange.com',
        'name': body['name'] ?? 'New User',
        'avatar': null,
        'role': 'user',
      },
    });
  }

  Map<String, dynamic> _currentUser() => _wrap({
        'id': _isAdminSession ? 'user_admin_001' : _demoUserId,
        'email': _isAdminSession
            ? 'admin@skillexchange.com'
            : 'demo@skillexchange.com',
        'name': _isAdminSession ? 'Admin User' : 'Demo User',
        'avatar': null,
        'role': _isAdminSession ? 'admin' : 'user',
      });

  Map<String, dynamic> _refreshToken() => _wrap({
        'accessToken': 'mock_access_token_refreshed_${DateTime.now().millisecondsSinceEpoch}',
      });

  // ── Profile ─────────────────────────────────────────────────────────────

  Map<String, dynamic> _profileById(String id) {
    final profile = _otherUsers.firstWhere(
      (p) => p['id'] == id,
      orElse: () => _otherUsers.first,
    );
    return _wrap(profile);
  }

  // ── Skills ──────────────────────────────────────────────────────────────

  Map<String, dynamic> _allSkills() => _wrap([
        _skill('s1', 'Flutter', 'Mobile', 'beginner'),
        _skill('s2', 'React', 'Frontend', 'beginner'),
        _skill('s3', 'Dart', 'Programming', 'beginner'),
        _skill('s4', 'Python', 'Programming', 'beginner'),
        _skill('s5', 'Data Science', 'Data Science', 'beginner'),
        _skill('s6', 'AWS', 'Cloud', 'beginner'),
        _skill('s7', 'Docker', 'DevOps', 'beginner'),
        _skill('s8', 'Figma', 'Design', 'beginner'),
        _skill('s9', 'UI Design', 'Design', 'beginner'),
        _skill('s10', 'Solidity', 'Blockchain', 'beginner'),
        _skill('s11', 'Web3', 'Blockchain', 'beginner'),
        _skill('s12', 'Node.js', 'Backend', 'beginner'),
        _skill('s13', 'TypeScript', 'Frontend', 'beginner'),
        _skill('s14', 'Go', 'Backend', 'beginner'),
        _skill('s15', 'Kubernetes', 'DevOps', 'beginner'),
      ]);

  Map<String, dynamic> _skillCategories() => _wrap([
        'Frontend',
        'Backend',
        'Programming',
        'Data Science',
        'DevOps',
        'Cloud',
        'Design',
        'Blockchain',
        'Security',
        'Mobile',
        'Other',
      ]);

  // ── Matching ────────────────────────────────────────────────────────────

  Map<String, dynamic> _matchesPaginated(RequestOptions options) {
    final matches = _otherUsers.asMap().entries.map((e) {
      final score = 0.95 - (e.key * 0.05);
      return {
        'userId': e.value['id'],
        'profile': e.value,
        'compatibilityScore': score,
        'skillOverlapScore': score - 0.02,
        'availabilityScore': 0.85,
        'locationScore': 1.0,
        'languageScore': 1.0,
        'matchedSkills': {
          'theyTeach': (e.value['skillsToTeach'] as List)
              .map((s) => (s as Map<String, dynamic>)['name'])
              .toList(),
          'youTeach': ['Flutter'],
        },
      };
    }).toList();

    return _wrapPaginated(matches, totalItems: matches.length);
  }

  Map<String, dynamic> _topMatches() {
    final top = _otherUsers.take(3).toList().asMap().entries.map((e) {
      final score = 0.95 - (e.key * 0.05);
      return {
        'userId': e.value['id'],
        'profile': e.value,
        'compatibilityScore': score,
        'skillOverlapScore': score - 0.02,
        'availabilityScore': 0.85,
        'locationScore': 1.0,
        'languageScore': 1.0,
        'matchedSkills': {
          'theyTeach': (e.value['skillsToTeach'] as List)
              .map((s) => (s as Map<String, dynamic>)['name'])
              .toList(),
          'youTeach': ['Flutter'],
        },
      };
    }).toList();

    return _wrap(top);
  }

  // ── Connections ─────────────────────────────────────────────────────────

  Map<String, dynamic> _connectionsList() => _wrap([
        {
          'id': 'conn_001',
          'fromUserId': _demoUserId,
          'toUserId': 'user_002',
          'status': 'accepted',
          'message': null,
          'createdAt': '2024-12-01T10:00:00Z',
          'updatedAt': '2024-12-02T15:30:00Z',
          'fromUser': null,
          'toUser': _otherUsers[0],
        },
        {
          'id': 'conn_002',
          'fromUserId': 'user_003',
          'toUserId': _demoUserId,
          'status': 'accepted',
          'message': null,
          'createdAt': '2025-01-10T08:00:00Z',
          'updatedAt': '2025-01-11T09:00:00Z',
          'fromUser': _otherUsers[1],
          'toUser': null,
        },
        {
          'id': 'conn_003',
          'fromUserId': _demoUserId,
          'toUserId': 'user_004',
          'status': 'accepted',
          'message': null,
          'createdAt': '2025-02-05T12:00:00Z',
          'updatedAt': '2025-02-06T14:00:00Z',
          'fromUser': null,
          'toUser': _otherUsers[2],
        },
      ]);

  Map<String, dynamic> _pendingConnections() => _wrap([
        {
          'id': 'conn_004',
          'fromUserId': 'user_005',
          'toUserId': _demoUserId,
          'status': 'pending',
          'message': 'I would love to learn Flutter from you!',
          'createdAt': '2026-03-05T09:00:00Z',
          'updatedAt': '2026-03-05T09:00:00Z',
          'fromUser': _otherUsers[3],
          'toUser': null,
        },
      ]);

  Map<String, dynamic> _sentConnections() => _wrap([
        {
          'id': 'conn_005',
          'fromUserId': _demoUserId,
          'toUserId': 'user_006',
          'status': 'pending',
          'message': 'Can you teach me React?',
          'createdAt': '2026-03-04T14:00:00Z',
          'updatedAt': '2026-03-04T14:00:00Z',
          'fromUser': null,
          'toUser': _otherUsers[4],
        },
      ]);

  Map<String, dynamic> _sendConnectionRequest(RequestOptions options) {
    final body = options.data as Map<String, dynamic>? ?? {};
    return _wrap({
      'id': 'conn_new_${DateTime.now().millisecondsSinceEpoch}',
      'fromUserId': _demoUserId,
      'toUserId': body['toUserId'] ?? 'user_unknown',
      'status': 'pending',
      'message': body['message'],
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'fromUser': null,
      'toUser': null,
    });
  }

  Map<String, dynamic> _respondConnection(String path) {
    final parts = path.split('/');
    final id = parts[parts.length - 2];
    return _wrap({
      'id': id,
      'fromUserId': 'user_005',
      'toUserId': _demoUserId,
      'status': 'accepted',
      'message': null,
      'createdAt': '2026-03-05T09:00:00Z',
      'updatedAt': DateTime.now().toIso8601String(),
      'fromUser': _otherUsers[3],
      'toUser': null,
    });
  }

  // ── Sessions ────────────────────────────────────────────────────────────

  Map<String, dynamic> _upcomingSessions() => _wrap([
        {
          'id': 'session_001',
          'hostId': _demoUserId,
          'participantId': 'user_002',
          'title': 'Flutter Widget Deep Dive',
          'description': 'Learn about custom widgets and state management.',
          'skillsToCover': ['Flutter', 'Dart'],
          'scheduledAt':
              DateTime.now().add(const Duration(days: 2)).toIso8601String(),
          'duration': 60,
          'status': 'scheduled',
          'sessionMode': 'online',
          'meetingPlatform': 'zoom',
          'meetingLink': 'https://zoom.us/j/mock123',
          'location': null,
          'notes': 'Bring questions about StatefulWidget lifecycle.',
          'createdAt': '2026-03-05T10:00:00Z',
          'updatedAt': '2026-03-05T10:00:00Z',
          'host': null,
          'participant': _otherUsers[0],
        },
        {
          'id': 'session_002',
          'hostId': 'user_003',
          'participantId': _demoUserId,
          'title': 'AWS Fundamentals',
          'description': 'Introduction to EC2, S3, and Lambda.',
          'skillsToCover': ['AWS', 'Cloud'],
          'scheduledAt':
              DateTime.now().add(const Duration(days: 5)).toIso8601String(),
          'duration': 90,
          'status': 'scheduled',
          'sessionMode': 'online',
          'meetingPlatform': 'google_meet',
          'meetingLink': 'https://meet.google.com/mock-abc',
          'location': null,
          'notes': null,
          'createdAt': '2026-03-04T08:00:00Z',
          'updatedAt': '2026-03-04T08:00:00Z',
          'host': _otherUsers[1],
          'participant': null,
        },
      ]);

  Map<String, dynamic> _createSession(RequestOptions options) {
    final body = options.data as Map<String, dynamic>? ?? {};
    return _wrap({
      'id': 'session_new_${DateTime.now().millisecondsSinceEpoch}',
      'hostId': _demoUserId,
      'participantId': body['participantId'] ?? 'user_002',
      'title': body['title'] ?? 'New Session',
      'description': body['description'] ?? '',
      'skillsToCover': body['skillsToCover'] ?? [],
      'scheduledAt': body['scheduledAt'] ?? DateTime.now().toIso8601String(),
      'duration': body['duration'] ?? 60,
      'status': 'scheduled',
      'sessionMode': body['sessionMode'] ?? 'online',
      'meetingPlatform': body['meetingPlatform'],
      'meetingLink': body['meetingLink'],
      'location': body['location'],
      'notes': null,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'host': null,
      'participant': null,
    });
  }

  Map<String, dynamic> _sessionAction(String path, String status) {
    return _wrap({
      'id': 'session_001',
      'hostId': _demoUserId,
      'participantId': 'user_002',
      'title': 'Flutter Widget Deep Dive',
      'description': 'Learn about custom widgets.',
      'skillsToCover': ['Flutter', 'Dart'],
      'scheduledAt': DateTime.now().add(const Duration(days: 2)).toIso8601String(),
      'duration': 60,
      'status': status,
      'sessionMode': 'online',
      'meetingPlatform': 'zoom',
      'meetingLink': 'https://zoom.us/j/mock123',
      'location': null,
      'notes': null,
      'createdAt': '2026-03-05T10:00:00Z',
      'updatedAt': DateTime.now().toIso8601String(),
      'host': null,
      'participant': _otherUsers[0],
    });
  }

  // ── Reviews ─────────────────────────────────────────────────────────────

  Map<String, dynamic> _userReviews() => _wrap([
        {
          'id': 'review_001',
          'fromUserId': 'user_002',
          'toUserId': _demoUserId,
          'rating': 5,
          'comment': 'Excellent Flutter teacher! Very patient and knowledgeable.',
          'skillsReviewed': ['Flutter', 'Dart'],
          'sessionId': 'session_001',
          'createdAt': '2026-02-15T16:00:00Z',
          'updatedAt': '2026-02-15T16:00:00Z',
          'fromUser': _otherUsers[0],
          'toUser': null,
        },
        {
          'id': 'review_002',
          'fromUserId': 'user_004',
          'toUserId': _demoUserId,
          'rating': 4,
          'comment': 'Great session on mobile development basics.',
          'skillsReviewed': ['Flutter'],
          'sessionId': 'session_003',
          'createdAt': '2026-01-20T12:00:00Z',
          'updatedAt': '2026-01-20T12:00:00Z',
          'fromUser': _otherUsers[2],
          'toUser': null,
        },
      ]);

  Map<String, dynamic> _reviewStats() => _wrap({
        'averageRating': 4.7,
        'totalReviews': 6,
        'ratingDistribution': {
          '5': 4,
          '4': 2,
          '3': 0,
          '2': 0,
          '1': 0,
        },
      });

  Map<String, dynamic> _createReview(RequestOptions options) {
    final body = options.data as Map<String, dynamic>? ?? {};
    return _wrap({
      'id': 'review_new_${DateTime.now().millisecondsSinceEpoch}',
      'fromUserId': _demoUserId,
      'toUserId': body['toUserId'] ?? 'user_002',
      'rating': body['rating'] ?? 5,
      'comment': body['comment'] ?? '',
      'skillsReviewed': body['skillsReviewed'] ?? [],
      'sessionId': body['sessionId'],
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'fromUser': null,
      'toUser': null,
    });
  }

  // ── Messaging ───────────────────────────────────────────────────────────

  Map<String, dynamic> _conversations() => _wrap([
        {
          'id': 'conv_001',
          'participants': [_demoUserId, 'user_002'],
          'lastMessage': 'See you at the session tomorrow!',
          'lastMessageAt': '2026-03-06T18:30:00Z',
          'unreadCount': 2,
          'updatedAt': '2026-03-06T18:30:00Z',
          'participantProfiles': [_otherUsers[0]],
        },
        {
          'id': 'conv_002',
          'participants': [_demoUserId, 'user_003'],
          'lastMessage': 'Thanks for the AWS tips!',
          'lastMessageAt': '2026-03-05T14:00:00Z',
          'unreadCount': 0,
          'updatedAt': '2026-03-05T14:00:00Z',
          'participantProfiles': [_otherUsers[1]],
        },
        {
          'id': 'conv_003',
          'participants': [_demoUserId, 'user_004'],
          'lastMessage': 'Can we schedule a design review?',
          'lastMessageAt': '2026-03-04T10:00:00Z',
          'unreadCount': 1,
          'updatedAt': '2026-03-04T10:00:00Z',
          'participantProfiles': [_otherUsers[2]],
        },
      ]);

  Map<String, dynamic> _conversationMessages(String path) {
    final convId = path.split('/').last;
    return _wrap([
      {
        'id': 'msg_001',
        'conversationId': convId,
        'senderId': 'user_002',
        'receiverId': _demoUserId,
        'content': 'Hey, are you free for a Flutter session this week?',
        'createdAt': '2026-03-06T10:00:00Z',
        'read': true,
        'sender': _otherUsers[0],
        'isFromMe': false,
      },
      {
        'id': 'msg_002',
        'conversationId': convId,
        'senderId': _demoUserId,
        'receiverId': 'user_002',
        'content': 'Sure! How about Wednesday at 3pm?',
        'createdAt': '2026-03-06T10:15:00Z',
        'read': true,
        'sender': null,
        'isFromMe': true,
      },
      {
        'id': 'msg_003',
        'conversationId': convId,
        'senderId': 'user_002',
        'receiverId': _demoUserId,
        'content': 'Perfect, I\'ll send a calendar invite.',
        'createdAt': '2026-03-06T10:20:00Z',
        'read': true,
        'sender': _otherUsers[0],
        'isFromMe': false,
      },
      {
        'id': 'msg_004',
        'conversationId': convId,
        'senderId': 'user_002',
        'receiverId': _demoUserId,
        'content': 'See you at the session tomorrow!',
        'createdAt': '2026-03-06T18:30:00Z',
        'read': false,
        'sender': _otherUsers[0],
        'isFromMe': false,
      },
    ]);
  }

  Map<String, dynamic> _sendMessage(RequestOptions options) {
    final body = options.data as Map<String, dynamic>? ?? {};
    return _wrap({
      'id': 'msg_new_${DateTime.now().millisecondsSinceEpoch}',
      'conversationId': body['conversationId'] ?? 'conv_001',
      'senderId': _demoUserId,
      'receiverId': 'user_002',
      'content': body['content'] ?? '',
      'createdAt': DateTime.now().toIso8601String(),
      'read': false,
      'sender': null,
      'isFromMe': true,
    });
  }

  // ── Notifications ───────────────────────────────────────────────────────

  Map<String, dynamic> _notifications() => _wrap([
        {
          'id': 'notif_001',
          'userId': _demoUserId,
          'type': 'connection_request',
          'title': 'New Connection Request',
          'message': 'Carlos Martinez wants to connect with you.',
          'read': false,
          'createdAt': '2026-03-07T10:00:00Z',
          'actionUrl': 'app://connections/pending',
          'metadata': {
            'fromUserId': 'user_005',
            'connectionId': 'conn_004',
          },
        },
        {
          'id': 'notif_002',
          'userId': _demoUserId,
          'type': 'session_reminder',
          'title': 'Session Reminder',
          'message': 'Your session "Flutter Widget Deep Dive" starts soon.',
          'read': false,
          'createdAt': '2026-03-07T08:00:00Z',
          'actionUrl': 'app://sessions',
          'metadata': {'sessionId': 'session_001'},
        },
        {
          'id': 'notif_003',
          'userId': _demoUserId,
          'type': 'new_message',
          'title': 'New Message',
          'message': 'Jane Doe: See you at the session tomorrow!',
          'read': false,
          'createdAt': '2026-03-06T18:30:00Z',
          'actionUrl': 'app://messages/conv_001',
          'metadata': {
            'conversationId': 'conv_001',
            'messageId': 'msg_004',
          },
        },
        {
          'id': 'notif_004',
          'userId': _demoUserId,
          'type': 'review_received',
          'title': 'New Review',
          'message': 'Jane Doe left you a 5-star review!',
          'read': true,
          'createdAt': '2026-02-15T16:05:00Z',
          'actionUrl': 'app://profile',
          'metadata': {'reviewId': 'review_001'},
        },
      ]);

  // ── Search ──────────────────────────────────────────────────────────────

  Map<String, dynamic> _searchUsers(RequestOptions options) {
    final query = (options.queryParameters['query'] as String? ?? '')
        .toLowerCase();
    var results = List<Map<String, dynamic>>.from(_otherUsers);
    if (query.isNotEmpty) {
      results = results
          .where((u) =>
              (u['fullName'] as String).toLowerCase().contains(query) ||
              (u['username'] as String).toLowerCase().contains(query))
          .toList();
    }
    return _wrap({
      'users': results,
      'total': results.length,
      'page': 1,
      'pageSize': 20,
    });
  }

  // ── Community ───────────────────────────────────────────────────────────

  Map<String, dynamic> _communityPosts() => _wrap([
        {
          'id': 'post_001',
          'authorId': 'user_002',
          'title': 'Tips for Learning Flutter in 2026',
          'content':
              'Here are my top 5 tips for getting started with Flutter this year:\n\n1. Start with the official codelabs\n2. Build a real project early\n3. Join the Flutter community on Discord\n4. Learn Dart fundamentals first\n5. Practice widget composition',
          'tags': ['flutter', 'beginners', 'tips'],
          'likesCount': 24,
          'commentsCount': 8,
          'isLikedByMe': true,
          'createdAt': '2026-03-05T10:00:00Z',
          'updatedAt': '2026-03-07T14:00:00Z',
          'author': _otherUsers[0],
        },
        {
          'id': 'post_002',
          'authorId': 'user_004',
          'title': 'Design Systems: Why Every Developer Should Learn One',
          'content':
              'A well-crafted design system can save weeks of development time. Here is how to get started with building your own...',
          'tags': ['design', 'ui-ux', 'productivity'],
          'likesCount': 18,
          'commentsCount': 5,
          'isLikedByMe': false,
          'createdAt': '2026-03-03T15:00:00Z',
          'updatedAt': '2026-03-03T15:00:00Z',
          'author': _otherUsers[2],
        },
        {
          'id': 'post_003',
          'authorId': 'user_003',
          'title': 'AWS vs GCP vs Azure: My 2026 Take',
          'content':
              'After working with all three major cloud providers, here is my honest comparison based on real-world projects...',
          'tags': ['cloud', 'aws', 'devops'],
          'likesCount': 31,
          'commentsCount': 12,
          'isLikedByMe': false,
          'createdAt': '2026-03-01T08:00:00Z',
          'updatedAt': '2026-03-02T10:00:00Z',
          'author': _otherUsers[1],
        },
      ]);

  Map<String, dynamic> _createPost(RequestOptions options) {
    final body = options.data as Map<String, dynamic>? ?? {};
    return _wrap({
      'id': 'post_new_${DateTime.now().millisecondsSinceEpoch}',
      'authorId': _demoUserId,
      'title': body['title'] ?? 'New Post',
      'content': body['content'] ?? '',
      'tags': body['tags'] ?? [],
      'likesCount': 0,
      'commentsCount': 0,
      'isLikedByMe': false,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'author': null,
    });
  }

  Map<String, dynamic> _circles() => _wrap([
        {
          'id': 'circle_001',
          'name': 'Flutter Enthusiasts',
          'description':
              'A community for Flutter developers to share tips, tricks, and projects.',
          'creatorId': 'user_003',
          'skillFocus': ['Flutter', 'Dart', 'Mobile'],
          'membersCount': 45,
          'maxMembers': 100,
          'isJoinedByMe': true,
          'createdAt': '2025-08-15T10:00:00Z',
          'updatedAt': '2026-03-07T14:00:00Z',
          'creator': _otherUsers[1],
        },
        {
          'id': 'circle_002',
          'name': 'Cloud Native Club',
          'description':
              'Learn and discuss cloud architecture, Kubernetes, and serverless.',
          'creatorId': 'user_003',
          'skillFocus': ['AWS', 'Docker', 'Kubernetes'],
          'membersCount': 32,
          'maxMembers': 50,
          'isJoinedByMe': false,
          'createdAt': '2025-10-01T12:00:00Z',
          'updatedAt': '2026-03-06T16:00:00Z',
          'creator': _otherUsers[1],
        },
        {
          'id': 'circle_003',
          'name': 'Design Thinkers',
          'description':
              'Explore UI/UX design principles, Figma tips, and portfolio reviews.',
          'creatorId': 'user_004',
          'skillFocus': ['Figma', 'UI Design'],
          'membersCount': 28,
          'maxMembers': 40,
          'isJoinedByMe': true,
          'createdAt': '2025-11-20T09:00:00Z',
          'updatedAt': '2026-03-05T11:00:00Z',
          'creator': _otherUsers[2],
        },
      ]);

  Map<String, dynamic> _createCircle(RequestOptions options) {
    final body = options.data as Map<String, dynamic>? ?? {};
    return _wrap({
      'id': 'circle_new_${DateTime.now().millisecondsSinceEpoch}',
      'name': body['name'] ?? 'New Circle',
      'description': body['description'] ?? '',
      'creatorId': _demoUserId,
      'skillFocus': body['skillFocus'] ?? [],
      'membersCount': 1,
      'maxMembers': body['maxMembers'] ?? 20,
      'isJoinedByMe': true,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'creator': null,
    });
  }

  Map<String, dynamic> _leaderboard() {
    final entries = _otherUsers.asMap().entries.map((e) {
      final rng = Random(e.key);
      return {
        'userId': e.value['id'],
        'rank': e.key + 1,
        'points': 1500 - (e.key * 150) + rng.nextInt(50),
        'sessionsCompleted': 20 - (e.key * 3),
        'reviewsGiven': 15 - (e.key * 2),
        'averageRating': 4.9 - (e.key * 0.1),
        'user': e.value,
      };
    }).toList();

    return _wrap(entries);
  }

  // ── Admin ───────────────────────────────────────────────────────────────

  Map<String, dynamic> _reports() => _wrap([
        {
          'id': 'report_001',
          'reportedUserId': 'user_999',
          'reporterName': null,
          'reason': 'inappropriate_content',
          'description': 'User posted offensive content in community.',
          'status': 'pending',
          'createdAt': '2026-03-06T16:00:00Z',
          'reviewedAt': null,
          'reviewedBy': null,
        },
        {
          'id': 'report_002',
          'reportedUserId': 'user_888',
          'reporterName': null,
          'reason': 'spam',
          'description': 'Excessive promotional posts.',
          'status': 'reviewing',
          'createdAt': '2026-03-05T10:00:00Z',
          'reviewedAt': null,
          'reviewedBy': null,
        },
      ]);

  Map<String, dynamic> _createReport(RequestOptions options) {
    final body = options.data as Map<String, dynamic>? ?? {};
    return _wrap({
      'id': 'report_new_${DateTime.now().millisecondsSinceEpoch}',
      'reportedUserId': body['reportedUserId'] ?? 'user_unknown',
      'reporterName': null,
      'reason': body['reason'] ?? 'other',
      'description': body['description'] ?? '',
      'status': 'pending',
      'createdAt': DateTime.now().toIso8601String(),
      'reviewedAt': null,
      'reviewedBy': null,
    });
  }

  Map<String, dynamic> _updateReport(String path) {
    final id = path.split('/').last;
    return _wrap({
      'id': id,
      'reportedUserId': 'user_999',
      'reporterName': null,
      'reason': 'inappropriate_content',
      'description': 'User posted offensive content.',
      'status': 'resolved',
      'createdAt': '2026-03-06T16:00:00Z',
      'reviewedAt': DateTime.now().toIso8601String(),
      'reviewedBy': _demoUserId,
    });
  }

  // ── Admin Community ─────────────────────────────────────────────────

  Map<String, dynamic> _adminPosts() => _wrap([
        {
          'id': 'apost_001',
          'authorName': 'Jane Doe',
          'authorAvatar': 'https://i.pravatar.cc/150?u=jane',
          'content': 'Tips for Learning Flutter in 2026 — my top 5 recommendations for beginners.',
          'skillTag': 'Flutter',
          'likesCount': 24,
          'repliesCount': 8,
          'isPinned': true,
          'isHidden': false,
          'createdAt': '2026-03-05T10:00:00Z',
        },
        {
          'id': 'apost_002',
          'authorName': 'Alice Williams',
          'authorAvatar': 'https://i.pravatar.cc/150?u=alice',
          'content': 'Design Systems: Why Every Developer Should Learn One.',
          'skillTag': 'Design',
          'likesCount': 18,
          'repliesCount': 5,
          'isPinned': false,
          'isHidden': false,
          'createdAt': '2026-03-03T15:00:00Z',
        },
        {
          'id': 'apost_003',
          'authorName': 'Bob Smith',
          'authorAvatar': 'https://i.pravatar.cc/150?u=bob',
          'content': 'AWS vs GCP vs Azure: My 2026 comparison based on real-world projects.',
          'skillTag': 'Cloud',
          'likesCount': 31,
          'repliesCount': 12,
          'isPinned': false,
          'isHidden': false,
          'createdAt': '2026-03-01T08:00:00Z',
        },
        {
          'id': 'apost_004',
          'authorName': 'Carlos Martinez',
          'authorAvatar': 'https://i.pravatar.cc/150?u=carlos',
          'content': 'Solidity best practices for gas optimization in smart contracts.',
          'skillTag': 'Blockchain',
          'likesCount': 15,
          'repliesCount': 4,
          'isPinned': false,
          'isHidden': true,
          'createdAt': '2026-02-28T14:00:00Z',
        },
        {
          'id': 'apost_005',
          'authorName': 'Priya Sharma',
          'authorAvatar': 'https://i.pravatar.cc/150?u=priya',
          'content': 'React 19 Server Components deep dive — what you need to know.',
          'skillTag': 'React',
          'likesCount': 42,
          'repliesCount': 16,
          'isPinned': true,
          'isHidden': false,
          'createdAt': '2026-02-25T09:00:00Z',
        },
        {
          'id': 'apost_006',
          'authorName': 'Demo User',
          'authorAvatar': null,
          'content': 'Looking for a study partner for Kubernetes certification prep.',
          'skillTag': 'DevOps',
          'likesCount': 7,
          'repliesCount': 3,
          'isPinned': false,
          'isHidden': false,
          'createdAt': '2026-02-22T11:00:00Z',
        },
        {
          'id': 'apost_007',
          'authorName': 'Jane Doe',
          'authorAvatar': 'https://i.pravatar.cc/150?u=jane',
          'content': 'Python data pipelines — from Pandas to Polars.',
          'skillTag': 'Python',
          'likesCount': 29,
          'repliesCount': 9,
          'isPinned': false,
          'isHidden': false,
          'createdAt': '2026-02-20T16:00:00Z',
        },
        {
          'id': 'apost_008',
          'authorName': 'Bob Smith',
          'authorAvatar': 'https://i.pravatar.cc/150?u=bob',
          'content': 'SPAM: Buy cheap followers! Visit our site now!!!',
          'skillTag': '',
          'likesCount': 0,
          'repliesCount': 0,
          'isPinned': false,
          'isHidden': true,
          'createdAt': '2026-02-18T03:00:00Z',
        },
      ]);

  Map<String, dynamic> _adminCircles() => _wrap([
        {
          'id': 'acircle_001',
          'name': 'Flutter Enthusiasts',
          'description': 'A community for Flutter developers.',
          'memberCount': 45,
          'isFeatured': true,
          'isActive': true,
          'createdAt': '2025-08-15T10:00:00Z',
          'imageUrl': null,
        },
        {
          'id': 'acircle_002',
          'name': 'Cloud Native Club',
          'description': 'Learn cloud architecture and Kubernetes.',
          'memberCount': 32,
          'isFeatured': false,
          'isActive': true,
          'createdAt': '2025-10-01T12:00:00Z',
          'imageUrl': null,
        },
        {
          'id': 'acircle_003',
          'name': 'Design Thinkers',
          'description': 'UI/UX design principles and Figma tips.',
          'memberCount': 28,
          'isFeatured': true,
          'isActive': true,
          'createdAt': '2025-11-20T09:00:00Z',
          'imageUrl': null,
        },
        {
          'id': 'acircle_004',
          'name': 'Blockchain Builders',
          'description': 'Smart contracts, DeFi, and Web3 development.',
          'memberCount': 19,
          'isFeatured': false,
          'isActive': true,
          'createdAt': '2025-12-05T14:00:00Z',
          'imageUrl': null,
        },
        {
          'id': 'acircle_005',
          'name': 'Inactive Test Circle',
          'description': 'This circle was deactivated.',
          'memberCount': 3,
          'isFeatured': false,
          'isActive': false,
          'createdAt': '2025-06-01T08:00:00Z',
          'imageUrl': null,
        },
      ]);

  Map<String, dynamic> _analyticsData() => _wrap({
        'overview': {
          'totalUsers': 1250,
          'activeUsers': 340,
          'totalSessions': 2100,
          'completionRate': 0.89,
          'newUsersThisWeek': 47,
          'sessionsThisWeek': 83,
        },
        'popularSkills': [
          {'name': 'Flutter', 'teachCount': 85, 'learnCount': 120},
          {'name': 'React', 'teachCount': 72, 'learnCount': 95},
          {'name': 'Python', 'teachCount': 65, 'learnCount': 110},
          {'name': 'AWS', 'teachCount': 40, 'learnCount': 78},
          {'name': 'Figma', 'teachCount': 35, 'learnCount': 60},
          {'name': 'Docker', 'teachCount': 30, 'learnCount': 55},
          {'name': 'TypeScript', 'teachCount': 28, 'learnCount': 50},
          {'name': 'Node.js', 'teachCount': 25, 'learnCount': 45},
        ],
        'weeklyActivity': [
          {'week': 'Feb 3', 'sessions': 52, 'connections': 30},
          {'week': 'Feb 10', 'sessions': 61, 'connections': 35},
          {'week': 'Feb 17', 'sessions': 58, 'connections': 28},
          {'week': 'Feb 24', 'sessions': 70, 'connections': 42},
          {'week': 'Mar 3', 'sessions': 83, 'connections': 47},
        ],
      });

  Map<String, dynamic> _adminSkills() => _wrap([
        {'id': 'ask_01', 'name': 'Flutter', 'category': 'Mobile', 'usageCount': 205, 'isActive': true, 'createdAt': '2024-01-01T00:00:00Z'},
        {'id': 'ask_02', 'name': 'React', 'category': 'Frontend', 'usageCount': 167, 'isActive': true, 'createdAt': '2024-01-01T00:00:00Z'},
        {'id': 'ask_03', 'name': 'Python', 'category': 'Programming', 'usageCount': 175, 'isActive': true, 'createdAt': '2024-01-01T00:00:00Z'},
        {'id': 'ask_04', 'name': 'Dart', 'category': 'Programming', 'usageCount': 140, 'isActive': true, 'createdAt': '2024-01-15T00:00:00Z'},
        {'id': 'ask_05', 'name': 'AWS', 'category': 'Cloud', 'usageCount': 118, 'isActive': true, 'createdAt': '2024-02-01T00:00:00Z'},
        {'id': 'ask_06', 'name': 'Docker', 'category': 'DevOps', 'usageCount': 85, 'isActive': true, 'createdAt': '2024-02-01T00:00:00Z'},
        {'id': 'ask_07', 'name': 'Figma', 'category': 'Design', 'usageCount': 95, 'isActive': true, 'createdAt': '2024-03-01T00:00:00Z'},
        {'id': 'ask_08', 'name': 'TypeScript', 'category': 'Frontend', 'usageCount': 78, 'isActive': true, 'createdAt': '2024-03-01T00:00:00Z'},
        {'id': 'ask_09', 'name': 'Node.js', 'category': 'Backend', 'usageCount': 70, 'isActive': true, 'createdAt': '2024-04-01T00:00:00Z'},
        {'id': 'ask_10', 'name': 'Solidity', 'category': 'Blockchain', 'usageCount': 32, 'isActive': true, 'createdAt': '2024-05-01T00:00:00Z'},
        {'id': 'ask_11', 'name': 'Web3', 'category': 'Blockchain', 'usageCount': 28, 'isActive': false, 'createdAt': '2024-05-01T00:00:00Z'},
        {'id': 'ask_12', 'name': 'COBOL', 'category': 'Programming', 'usageCount': 2, 'isActive': false, 'createdAt': '2024-06-01T00:00:00Z'},
      ]);

  Map<String, dynamic> _announcements() => _wrap([
        {
          'id': 'ann_001',
          'title': 'Platform Maintenance',
          'body': 'Scheduled maintenance on March 15, 2026 from 2-4 AM UTC. Expect brief downtime.',
          'priority': 'warning',
          'isActive': true,
          'createdAt': '2026-03-07T10:00:00Z',
          'expiresAt': '2026-03-16T00:00:00Z',
        },
        {
          'id': 'ann_002',
          'title': 'New Feature: Skill Circles',
          'body': 'Join topic-based circles to connect with learners and teachers in your area of interest!',
          'priority': 'info',
          'isActive': true,
          'createdAt': '2026-03-01T08:00:00Z',
          'expiresAt': null,
        },
        {
          'id': 'ann_003',
          'title': 'Security Update Required',
          'body': 'Please update your password if you have not done so in the last 90 days.',
          'priority': 'critical',
          'isActive': true,
          'createdAt': '2026-02-20T12:00:00Z',
          'expiresAt': '2026-04-01T00:00:00Z',
        },
        {
          'id': 'ann_004',
          'title': 'Community Guidelines Updated',
          'body': 'We have updated our community guidelines. Please review the changes.',
          'priority': 'info',
          'isActive': false,
          'createdAt': '2026-01-15T09:00:00Z',
          'expiresAt': '2026-02-15T00:00:00Z',
        },
      ]);

  Map<String, dynamic> _activityLogs() => _wrap([
        {'id': 'log_01', 'adminName': 'Admin User', 'action': 'ban_user', 'targetType': 'user', 'targetId': 'user_999', 'details': 'Banned for violating community guidelines', 'timestamp': '2026-03-07T16:30:00Z'},
        {'id': 'log_02', 'adminName': 'Admin User', 'action': 'resolve_report', 'targetType': 'report', 'targetId': 'report_001', 'details': 'Resolved inappropriate content report', 'timestamp': '2026-03-07T16:00:00Z'},
        {'id': 'log_03', 'adminName': 'Admin User', 'action': 'hide_post', 'targetType': 'post', 'targetId': 'apost_008', 'details': 'Hidden spam post', 'timestamp': '2026-03-07T15:30:00Z'},
        {'id': 'log_04', 'adminName': 'Admin User', 'action': 'feature_circle', 'targetType': 'circle', 'targetId': 'acircle_001', 'details': 'Featured Flutter Enthusiasts circle', 'timestamp': '2026-03-07T14:00:00Z'},
        {'id': 'log_05', 'adminName': 'Admin User', 'action': 'create_announcement', 'targetType': 'announcement', 'targetId': 'ann_001', 'details': 'Created maintenance announcement', 'timestamp': '2026-03-07T10:00:00Z'},
        {'id': 'log_06', 'adminName': 'Admin User', 'action': 'delete_skill', 'targetType': 'skill', 'targetId': 'ask_99', 'details': 'Removed deprecated skill', 'timestamp': '2026-03-06T18:00:00Z'},
        {'id': 'log_07', 'adminName': 'Admin User', 'action': 'unban_user', 'targetType': 'user', 'targetId': 'user_777', 'details': 'Unbanned after appeal review', 'timestamp': '2026-03-06T14:00:00Z'},
        {'id': 'log_08', 'adminName': 'Admin User', 'action': 'pin_post', 'targetType': 'post', 'targetId': 'apost_001', 'details': 'Pinned Flutter tips post', 'timestamp': '2026-03-06T12:00:00Z'},
        {'id': 'log_09', 'adminName': 'Admin User', 'action': 'create_skill', 'targetType': 'skill', 'targetId': 'ask_12', 'details': 'Added COBOL skill', 'timestamp': '2026-03-05T16:00:00Z'},
        {'id': 'log_10', 'adminName': 'Admin User', 'action': 'delete_post', 'targetType': 'post', 'targetId': 'post_deleted', 'details': 'Deleted offensive content', 'timestamp': '2026-03-05T11:00:00Z'},
        {'id': 'log_11', 'adminName': 'Admin User', 'action': 'update_circle', 'targetType': 'circle', 'targetId': 'acircle_005', 'details': 'Deactivated inactive circle', 'timestamp': '2026-03-04T15:00:00Z'},
        {'id': 'log_12', 'adminName': 'Admin User', 'action': 'resolve_report', 'targetType': 'report', 'targetId': 'report_old', 'details': 'Dismissed false report', 'timestamp': '2026-03-04T10:00:00Z'},
        {'id': 'log_13', 'adminName': 'Admin User', 'action': 'create_announcement', 'targetType': 'announcement', 'targetId': 'ann_002', 'details': 'Announced skill circles feature', 'timestamp': '2026-03-01T08:00:00Z'},
        {'id': 'log_14', 'adminName': 'Admin User', 'action': 'ban_user', 'targetType': 'user', 'targetId': 'user_888', 'details': 'Banned for spam', 'timestamp': '2026-02-28T09:00:00Z'},
        {'id': 'log_15', 'adminName': 'Admin User', 'action': 'delete_announcement', 'targetType': 'announcement', 'targetId': 'ann_old', 'details': 'Removed expired announcement', 'timestamp': '2026-02-25T14:00:00Z'},
      ]);

  Map<String, dynamic> _platformStats() => _wrap({
        'totalUsers': 1250,
        'activeUsers': 340,
        'totalSessions': 2100,
        'completedSessions': 1890,
        'totalConnections': 3450,
        'totalReviews': 2230,
        'averageRating': 4.3,
        'totalPosts': 567,
        'totalCircles': 45,
        'pendingReports': 12,
      });
}
