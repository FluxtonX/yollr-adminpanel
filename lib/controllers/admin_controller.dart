import 'package:get/get.dart';
import '../core/socket_service.dart';
import '../core/user_service.dart';
import '../core/post_service.dart';
import '../models/post_model.dart';

enum AdminPage { dashboard, users, posts, analytics, settings }

class AdminController extends GetxController {
  var currentPage = AdminPage.dashboard.obs;
  var isSidebarCollapsed = false.obs;
  var activeUsers = 0.obs;
  var totalUsers = 0.obs;
  var isLoggedIn = false.obs;
  var recentPosts = <AdminPostModel>[].obs;

  final AdminSocketService _socketService = AdminSocketService();
  final AdminUserService _userService = AdminUserService();
  final AdminPostService _postService = AdminPostService();

  @override
  void onInit() {
    super.onInit();
    // In a real app, check persistent storage (GetStorage/SharedPreferences) here
    if (isLoggedIn.value) {
      _initServices();
    }
  }

  void login() {
    isLoggedIn.value = true;
    _initServices();
  }

  void logout() {
    isLoggedIn.value = false;
    _socketService.disconnect();
    currentPage.value = AdminPage.dashboard;
  }

  void _initServices() {
    _socketService.connect(
      onActiveUsersUpdate: (count) {
        activeUsers.value = count;
      },
      onNewPost: (data) {
        final newPost = AdminPostModel.fromJson(data);
        recentPosts.insert(0, newPost);
        // Keep only last 50 for memory efficiency
        if (recentPosts.length > 50) {
          recentPosts.removeLast();
        }
      },
    );
    fetchStats();
    loadRecentPosts();
  }

  Future<void> fetchStats() async {
    final stats = await _userService.fetchStats();
    totalUsers.value = stats['totalUsers'] ?? 0;
  }

  Future<void> loadRecentPosts() async {
    final posts = await _postService.fetchAllPosts();
    recentPosts.assignAll(posts);
  }

  void setPage(AdminPage page) {
    currentPage.value = page;
  }

  void toggleSidebar() {
    isSidebarCollapsed.value = !isSidebarCollapsed.value;
  }

  @override
  void onClose() {
    _socketService.disconnect();
    super.onClose();
  }
}
