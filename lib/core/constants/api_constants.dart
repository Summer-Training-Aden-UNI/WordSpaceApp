class ApiConstants {
  // Android emulator -> your PC. For a real phone use your PC's LAN IP.
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // Auth
  static const String register = '/register';
  static const String login = '/login';
  static const String logout = '/logout';
  static const String user = '/user';

  // Posts
  static const String posts = '/posts';
  static String post(int id) => '/posts/$id';
  static String postComments(int id) => '/posts/$id/comments';
  static String postLikes(int id) => '/posts/$id/likes';

  // Comments
  static String comment(int id) => '/comments/$id';

  // Profile
  static const String profile = '/profile';

  // Users / follow
  static String userById(int id) => '/users/$id';
  static String userPosts(int id) => '/users/$id/posts';
  static String userFollowers(int id) => '/users/$id/followers';
  static String userFollowing(int id) => '/users/$id/following';
  static String follow(int id) => '/users/$id/follow';

  // Search / users list
  static const String search = '/search';
  static const String users = '/users';

  // Admin
  static const String adminDashboard = '/admin/dashboard';
  static const String adminUsers = '/admin/users';
  static String adminUser(int id) => '/admin/users/$id';
}
