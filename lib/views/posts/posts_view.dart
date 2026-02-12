import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_controller.dart';
import '../../core/app_theme.dart';
import '../../models/post_model.dart';
import '../../widgets/video_preview_widget.dart';
import 'package:url_launcher/url_launcher.dart';

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
                        'Content Moderation',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Review campus posts and event videos, and remove inappropriate content.',
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
                post.type == PostType.submission
                    ? VideoPreviewWidget(
                        videoUrl: post.videoUrl ?? '',
                        autoPlay: false,
                        showControls: false,
                      )
                    : post.imageUrl.isNotEmpty
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

                // Type Badge (LIVE or VIDEO)
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
                          decoration: BoxDecoration(
                            color: post.type == PostType.post
                                ? AppTheme.successColor
                                : Colors.orangeAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          post.type == PostType.post ? 'POST' : 'VIDEO',
                          style: const TextStyle(
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

                // Status Badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(post.status).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Text(
                      post.status.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
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
                if (post.status == 'pending')
                  // Pending: Show Approve and Reject buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final AdminController controller =
                                Get.find<AdminController>();
                            controller.approveModerationItem(post);
                          },
                          icon: const Icon(
                            Icons.check_circle_outline,
                            size: 16,
                          ),
                          label: const Text(
                            'Approve',
                            style: TextStyle(fontSize: 12),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: AppTheme.successColor.withOpacity(
                              0.15,
                            ),
                            foregroundColor: AppTheme.successColor,
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final AdminController controller =
                                Get.find<AdminController>();
                            controller.rejectModerationItem(post);
                          },
                          icon: const Icon(Icons.cancel_outlined, size: 16),
                          label: const Text(
                            'Reject',
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
                  )
                else
                  // Approved/Rejected: Show View and Remove buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            if (post.type == PostType.submission) {
                              Get.dialog(
                                Dialog(
                                  backgroundColor: Colors.black,
                                  insetPadding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AppBar(
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        leading: IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () => Get.back(),
                                        ),
                                        title: const Text('Video Preview'),
                                      ),
                                      Flexible(
                                        child: AspectRatio(
                                          aspectRatio: 16 / 9,
                                          child: VideoPreviewWidget(
                                            videoUrl: post.videoUrl ?? '',
                                            autoPlay: true,
                                            showControls: true,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              );
                              return;
                            }

                            // For regular posts, open in browser or show image dialog
                            final url = post.imageUrl;
                            if (url != null && url.isNotEmpty) {
                              final uri = Uri.parse(url);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              } else {
                                Get.snackbar(
                                  'Error',
                                  'Could not launch content',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: AppTheme.errorColor,
                                  colorText: Colors.white,
                                );
                              }
                            }
                          },
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
                          onPressed: () {
                            Get.dialog(
                              AlertDialog(
                                title: const Text('Delete Post'),
                                content: const Text(
                                  'Are you sure you want to delete this content? This action cannot be undone.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                      final AdminController controller =
                                          Get.find<AdminController>();
                                      controller.deleteModerationItem(post);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.errorColor,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return AppTheme.successColor;
      case 'rejected':
        return AppTheme.errorColor;
      case 'pending':
      default:
        return Colors.orange;
    }
  }
}
