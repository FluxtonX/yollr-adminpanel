import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/socket_service.dart';
import '../core/user_service.dart';
import '../core/post_service.dart';
import '../models/post_model.dart';
import '../core/app_theme.dart';

enum AdminPage { dashboard, users, posts, events, analytics, settings }

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
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final bool loggedIn = prefs.getBool('admin_is_logged_in') ?? false;
    if (loggedIn) {
      isLoggedIn.value = true;
      _initServices();
    }
  }

  Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('admin_is_logged_in', true);
    isLoggedIn.value = true;
    _initServices();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('admin_is_logged_in', false);
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
    final submissions = await _postService.fetchEventSubmissions();

    // Merge and sort by date descending
    final allContent = [...posts, ...submissions];
    allContent.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    recentPosts.assignAll(allContent);
  }

  Future<void> deleteModerationItem(AdminPostModel item) async {
    bool success = false;
    if (item.type == PostType.post) {
      success = await _postService.deletePost(item.id);
    } else {
      success = await _postService.deleteSubmission(item.id);
    }

    if (success) {
      recentPosts.removeWhere((p) => p.id == item.id);
      Get.snackbar(
        'Success',
        'Item removed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.successColor.withOpacity(0.8),
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to remove item',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorColor.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
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
