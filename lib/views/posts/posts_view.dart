import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_controller.dart';
import '../../core/app_theme.dart';
import '../../models/post_model.dart';

class PostsView extends StatelessWidget {
  const PostsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is found
    final AdminController controller = Get.find<AdminController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 3;
        double aspectRatio = 0.75; // Adjusted a bit for content

        if (constraints.maxWidth < 600) {
          crossAxisCount = 1;
          aspectRatio = 1.1; // Wider on mobile
        } else if (constraints.maxWidth < 1100) {
          crossAxisCount = 2;
          aspectRatio = 0.85;
        }

        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Post Moderation',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Review global moments and remove inappropriate content.',
                        style: TextStyle(color: AppTheme.textSecondaryColor),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => controller.loadRecentPosts(),
                    tooltip: 'Refresh Posts',
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Grid of Posts
              Expanded(
                child: Obx(() {
                  if (controller.recentPosts.isEmpty) {
                    return const Center(child: Text("No posts found."));
                  }

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: aspectRatio,
                    ),
                    itemCount: controller.recentPosts.length,
                    itemBuilder: (context, index) {
                      final post = controller.recentPosts[index];
                      return _buildPostCard(post);
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPostCard(AdminPostModel post) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Image
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                post.imageUrl.isNotEmpty
                    ? Image.network(
                        post.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.white10,
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.white24,
                              size: 32,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.white10,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.white24,
                            size: 32,
                          ),
                        ),
                      ),

                // Professional Live Badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppTheme.successColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'LIVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Header
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white10,
                      child: ClipOval(
                        child:
                            (post.profileImage != null &&
                                post.profileImage!.isNotEmpty)
                            ? Image.network(
                                post.profileImage!,
                                width: 32,
                                height: 32,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => const Icon(
                                  Icons.person,
                                  size: 18,
                                  color: Colors.white70,
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                size: 18,
                                color: Colors.white70,
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.username,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            withCampus(post),
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Caption
                Text(
                  post.caption.isNotEmpty ? post.caption : "No caption",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.visibility_outlined, size: 16),
                        label: const Text(
                          'View',
                          style: TextStyle(fontSize: 12),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.1),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.delete_outline, size: 16),
                        label: const Text(
                          'Remove',
                          style: TextStyle(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: AppTheme.errorColor.withOpacity(
                            0.15,
                          ),
                          foregroundColor: AppTheme.errorColor,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String withCampus(AdminPostModel post) {
    final timeStr = _formatDate(post.createdAt);
    if (post.campus.isNotEmpty && post.campus != 'Unknown') {
      return '$timeStr • ${post.campus}';
    }
    return timeStr;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
