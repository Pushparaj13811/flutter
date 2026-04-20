class ApiEndpoints {
  ApiEndpoints._();
}

class Auth {
  const Auth._();

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refresh = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';
  static const String changePassword = '/auth/change-password';
  static const String changeEmail = '/auth/change-email';
  static const String google = '/auth/google';
  // Kept for backward compat — auth_remote_source uses this
  static const String signup = '/auth/register';
  static const String me = '/users/me';
}

class Users {
  const Users._();

  static const String me = '/users/me';
}

class Profiles {
  const Profiles._();

  static const String me = '/profiles/me';
  static const String list = '/profiles';
  static const String avatar = '/profiles/me/avatar';
  static const String cover = '/profiles/me/cover';
  static const String preferences = '/profiles/me/preferences';

  static String byId(String id) => '/profiles/$id';
  static String byUsername(String username) => '/profiles/by-username/$username';
  static String userPosts(String id) => '/profiles/$id/posts';
}

class Skills {
  const Skills._();

  static const String list = '/skills';
  static const String categories = '/skills/categories';
  static const String search = '/skills/search';
  static const String popular = '/skills/popular';

  static String byId(String id) => '/skills/$id';
}

class Matching {
  const Matching._();

  static const String suggestions = '/matching/suggestions';
}

class Connections {
  const Connections._();

  static const String list = '/connections';
  static const String request = '/connections/request';
  static const String pending = '/connections/pending';
  static const String sent = '/connections/sent';

  static String accept(String id) => '/connections/$id/accept';
  static String reject(String id) => '/connections/$id/reject';
  static String remove(String id) => '/connections/$id';
}

class Sessions {
  const Sessions._();

  static const String list = '/sessions';
  static const String book = '/sessions/book';
  static const String request = '/sessions/request';

  static String byId(String id) => '/sessions/$id';
  static String cancel(String id) => '/sessions/$id/cancel';
  static String complete(String id) => '/sessions/$id/complete';
  static String reschedule(String id) => '/sessions/$id/reschedule';
  static String availableSlots(String userId) => '/sessions/available-slots/$userId';
}

class Messages {
  const Messages._();

  static const String threads = '/messages/threads';
  static const String send = '/messages/send';
  static const String unreadCount = '/messages/unread-count';

  static String threadById(String threadId) => '/messages/threads/$threadId';
  static String markRead(String threadId) => '/messages/threads/$threadId/read';
}

class Reviews {
  const Reviews._();

  static const String create = '/reviews';

  static String forUser(String userId) => '/reviews/user/$userId';
  static String byUser(String userId) => '/reviews/by/$userId';
}

class Notifications {
  const Notifications._();

  static const String list = '/notifications';
  static const String unreadCount = '/notifications/unread-count';
  static const String readAll = '/notifications/read-all';

  static String markRead(String id) => '/notifications/$id/read';
  static String delete(String id) => '/notifications/$id';
}

class Search {
  const Search._();

  static const String users = '/search/users';
}

class Community {
  const Community._();

  static const String posts = '/community/posts';
  static const String circles = '/community/circles';
  static const String leaderboard = '/community/leaderboard';
  static const String uploadMedia = '/community/posts/upload-media';
  static const String uploadVideo = '/community/posts/upload-video';

  static String postById(String id) => '/community/posts/$id';
  static String likePost(String id) => '/community/posts/$id/like';
  static String hasLiked(String id) => '/community/posts/$id/liked';
  static String postReplies(String id) => '/community/posts/$id/replies';
  static String circleById(String id) => '/community/circles/$id';
  static String joinCircle(String id) => '/community/circles/$id/join';
  static String leaveCircle(String id) => '/community/circles/$id/leave';
  static String circleMembership(String id) => '/community/circles/$id/membership';
  static String circlePosts(String id) => '/community/circles/$id/posts';
}

class Reports {
  const Reports._();

  static const String create = '/reports';
}

class PublicApi {
  const PublicApi._();

  static const String stats = '/public/stats';
  static const String testimonials = '/public/testimonials';
}

class Admin {
  const Admin._();

  static const String stats = '/admin/stats';
  static const String users = '/admin/users';
  static const String circles = '/admin/circles';
  static const String posts = '/admin/posts';
  static const String sessions = '/admin/sessions';
  static const String connections = '/admin/connections';
  static const String reviews = '/admin/reviews';
  static const String reports = '/admin/reports';

  static String userById(String id) => '/admin/users/$id';
  static String userRole(String id) => '/admin/users/$id/role';
  static String banUser(String id) => '/admin/users/$id/ban';
  static String unbanUser(String id) => '/admin/users/$id/unban';
  static String verifySkill(String userId, int skillIndex) =>
      '/admin/users/$userId/verify-skill/$skillIndex';
  static String circleById(String id) => '/admin/circles/$id';
  static String deletePost(String id) => '/admin/posts/$id';
  static String moderatePost(String id) => '/admin/posts/$id/moderate';
  static String cancelSession(String id) => '/admin/sessions/$id/cancel';
  static String deleteConnection(String id) => '/admin/connections/$id';
  static String deleteReview(String id) => '/admin/reviews/$id';
  static String reviewStatus(String id) => '/admin/reviews/$id/status';
  static String reportById(String id) => '/admin/reports/$id';
}

class Uploads {
  const Uploads._();

  static const String avatar = '/profiles/me/avatar';
  static const String cover = '/profiles/me/cover';
}
