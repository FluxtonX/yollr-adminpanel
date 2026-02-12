import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/user_service.dart';
import '../core/post_service.dart';
import '../models/post_model.dart';
import '../core/app_theme.dart';
import 'dart:async';

enum AdminPage { dashboard, users, posts, events, analytics, settings }

class AdminController extends GetxController {
  var currentPage = AdminPage.dashboard.obs;
  var isSidebarCollapsed = false.obs;
  var activeUsers = 0.obs;
  var totalUsers = 0.obs;
  var isLoggedIn = false.obs;
  var recentPosts = <AdminPostModel>[].obs;

  final AdminUserService _userService = AdminUserService();
  final AdminPostService _postService = AdminPostService();
  Timer? _statsTimer;

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
    _statsTimer?.cancel();
    currentPage.value = AdminPage.dashboard;
  }

  void _initServices() {
    // Initial fetch
    fetchStats();
    loadRecentPosts();

    // Set up periodic polling for stats (every 30 seconds)
    _statsTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      fetchStats();
    });
  }

  Future<void> fetchStats() async {
    final stats = await _userService.fetchStats();
    totalUsers.value = stats['totalUsers'] ?? 0;
    activeUsers.value = stats['activeUsers'] ?? 0;
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

  Future<void> approveModerationItem(AdminPostModel item) async {
    bool success = false;
    if (item.type == PostType.post) {
      success = await _postService.approvePost(item.id);
    } else {
      success = await _postService.approveSubmission(item.id);
    }

    if (success) {
      // Update the item's status in the list
      final index = recentPosts.indexWhere((p) => p.id == item.id);
      if (index != -1) {
        recentPosts[index] = AdminPostModel(
          id: item.id,
          uid: item.uid,
          username: item.username,
          profileImage: item.profileImage,
          imageUrl: item.imageUrl,
          videoUrl: item.videoUrl,
          caption: item.caption,
          campus: item.campus,
          createdAt: item.createdAt,
          type: item.type,
          status: 'approved',
        );
        recentPosts.refresh();
      }
      Get.snackbar(
        'Success',
        'Item approved successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.successColor.withOpacity(0.8),
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to approve item',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorColor.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> rejectModerationItem(AdminPostModel item) async {
    bool success = false;
    if (item.type == PostType.post) {
      success = await _postService.rejectPost(item.id);
    } else {
      success = await _postService.rejectSubmission(item.id);
    }

    if (success) {
      // Update the item's status in the list
      final index = recentPosts.indexWhere((p) => p.id == item.id);
      if (index != -1) {
        recentPosts[index] = AdminPostModel(
          id: item.id,
          uid: item.uid,
          username: item.username,
          profileImage: item.profileImage,
          imageUrl: item.imageUrl,
          videoUrl: item.videoUrl,
          caption: item.caption,
          campus: item.campus,
          createdAt: item.createdAt,
          type: item.type,
          status: 'rejected',
        );
        recentPosts.refresh();
      }
      Get.snackbar(
        'Success',
        'Item rejected successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.successColor.withOpacity(0.8),
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to reject item',
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
    _statsTimer?.cancel();
    super.onClose();
  }
}
