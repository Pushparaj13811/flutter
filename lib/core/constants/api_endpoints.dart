class ApiEndpoints {
  ApiEndpoints._();

  static const Auth auth = Auth._();
  static const Profiles profiles = Profiles._();
  static const Skills skills = Skills._();
  static const Matching matching = Matching._();
  static const Connections connections = Connections._();
  static const Sessions sessions = Sessions._();
  static const Messages messages = Messages._();
  static const Reviews reviews = Reviews._();
  static const Notifications notifications = Notifications._();
  static const Search search = Search._();
  static const Community community = Community._();
  static const Reports reports = Reports._();
  static const Uploads uploads = Uploads._();
}

class Auth {
  const Auth._();

  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String logout = '/auth/logout';
  static const String refresh = '/auth/refresh';
  static const String me = '/auth/me';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';
  static const String changePassword = '/auth/change-password';
  static const String google = '/auth/google';
}

class Profiles {
  const Profiles._();

  static const String me = '/profiles/me';
  static const String list = '/profiles';

  static String byId(String id) => '/profiles/$id';
}

class Skills {
  const Skills._();

  static const String list = '/skills';
  static const String categories = '/skills/categories';
}

class Matching {
  const Matching._();

  static const String list = '/matching';
  static const String suggestions = '/matching/suggestions';
}

class Connections {
  const Connections._();

  static const String list = '/connections';
  static const String request = '/connections/request';
  static const String pending = '/connections/pending';
  static const String sent = '/connections/sent';

  static String respond(String id) => '/connections/$id/respond';
  static String remove(String id) => '/connections/$id';
  static String status(String userId) => '/connections/$userId/status';
}

class Sessions {
  const Sessions._();

  static const String upcoming = '/sessions/upcoming';
  static const String create = '/sessions';

  static String cancel(String id) => '/sessions/$id/cancel';
  static String complete(String id) => '/sessions/$id/complete';
  static String reschedule(String id) => '/sessions/$id/reschedule';
}

class Messages {
  const Messages._();

  static const String conversations = '/messages/conversations';
  static const String send = '/messages';

  static String conversationMessages(String id) => '/messages/conversations/$id';
  static String markRead(String id) => '/messages/$id/read';
}

class Reviews {
  const Reviews._();

  static const String create = '/reviews';

  static String byUser(String userId) => '/reviews/user/$userId';
  static String statsByUser(String userId) => '/reviews/user/$userId/stats';
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

  static String likePost(String id) => '/community/posts/$id/like';
  static String unlikePost(String id) => '/community/posts/$id/like';
  static String joinCircle(String id) => '/community/circles/$id/join';
  static String leaveCircle(String id) => '/community/circles/$id/leave';
}

class Reports {
  const Reports._();

  static const String list = '/reports';
  static const String create = '/reports';

  static String byId(String id) => '/reports/$id';
}

class Admin {
  const Admin._();

  static const String stats = '/admin/stats';
  static const String communityPosts = '/admin/community/posts';
  static const String communityCircles = '/admin/community/circles';
  static const String analytics = '/admin/analytics';
  static const String skills = '/admin/skills';
  static const String announcements = '/admin/announcements';
  static const String activityLogs = '/admin/activity-logs';

  static String pinPost(String id) => '/admin/community/posts/$id/pin';
  static String hidePost(String id) => '/admin/community/posts/$id/hide';
  static String deletePost(String id) => '/admin/community/posts/$id';
  static String featureCircle(String id) =>
      '/admin/community/circles/$id/feature';
  static String updateCircle(String id) => '/admin/community/circles/$id';
  static String deleteCircle(String id) => '/admin/community/circles/$id';
  static String skillById(String id) => '/admin/skills/$id';
  static String deleteAnnouncement(String id) => '/admin/announcements/$id';
}

class Uploads {
  const Uploads._();

  static const String avatar = '/uploads/avatar';
}
