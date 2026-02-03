import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_controller.dart';
import '../../core/app_theme.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminController controller = Get.find<AdminController>();
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 4;
        if (constraints.maxWidth < 600) {
          crossAxisCount = 1;
        } else if (constraints.maxWidth < 1000) {
          crossAxisCount = 2;
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dashboard Overview',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Welcome back, here is what\'s happening on Yollr today.',
                          style: TextStyle(color: AppTheme.textSecondaryColor),
                        ),
                      ],
                    ),
                  ),
                  if (constraints.maxWidth > 600)
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.download, size: 20),
                      label: const Text('Export Report'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 40),
              // Stats Grid
              GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.6,
                children: [
                  Obx(
                    () => _buildStatCard(
                      title: 'Total Users',
                      value: controller.totalUsers.value.toString(),
                      change: 'Total registered accounts',
                      icon: Icons.people,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  Obx(
                    () => _buildStatCard(
                      title: 'Active Now',
                      value: controller.activeUsers.value.toString(),
                      change: 'Current live connections',
                      icon: Icons.online_prediction,
                      color: AppTheme.successColor,
                    ),
                  ),
                  _buildStatCard(
                    title: 'New Moments',
                    value: '3,245',
                    change: '+8% since morning',
                    icon: Icons.photo_library,
                    color: Colors.blueAccent,
                  ),
                  _buildStatCard(
                    title: 'Pending Moderation',
                    value: '24',
                    change: 'Requires immediate action',
                    icon: Icons.warning_amber_rounded,
                    color: AppTheme.errorColor,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Recent Activity Table Placeholder
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Global Activity',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh, size: 20),
                          onPressed: () => controller.loadRecentPosts(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Obx(() {
                      if (controller.recentPosts.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text('No recent activity found.'),
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.recentPosts.length > 10
                            ? 10
                            : controller.recentPosts.length,
                        separatorBuilder: (context, index) =>
                            const Divider(color: Colors.white10),
                        itemBuilder: (context, index) {
                          final post = controller.recentPosts[index];
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white10,
                              child: ClipOval(
                                child:
                                    (post.profileImage != null &&
                                        post.profileImage!.isNotEmpty)
                                    ? Image.network(
                                        post.profileImage!,
                                        fit: BoxFit.cover,
                                        width: 40,
                                        height: 40,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.person,
                                                color: Colors.white70,
                                                size: 20,
                                              );
                                            },
                                      )
                                    : const Icon(
                                        Icons.person,
                                        color: Colors.white70,
                                        size: 20,
                                      ),
                              ),
                            ),
                            title: Text('${post.username} posted a new moment'),
                            subtitle: Text(
                              '${post.caption.isNotEmpty ? post.caption : "No caption"} • ${post.campus}',
                            ),
                            trailing: constraints.maxWidth > 500
                                ? TextButton(
                                    onPressed: () {},
                                    child: const Text('View Post'),
                                  )
                                : null,
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String change,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Icon(icon, color: color, size: 20),
            ],
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            change,
            style: TextStyle(
              color: change.contains('+')
                  ? AppTheme.successColor
                  : AppTheme.errorColor,
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
