import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../core/app_theme.dart';
import '../controllers/admin_controller.dart';

class Sidebar extends StatelessWidget {
  final bool isMobile;
  const Sidebar({super.key, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    final AdminController controller = Get.find<AdminController>();

    return Obx(() {
      final bool isCollapsed = controller.isSidebarCollapsed.value && !isMobile;
      final double targetWidth = isCollapsed ? 70 : 250;
      // Consistent animation parameters for all synced elements
      const Duration animDuration = Duration(milliseconds: 300);
      const Curve animCurve = Curves.easeInOutCubic;

      return AnimatedContainer(
        duration: animDuration,
        curve: animCurve,
        width: targetWidth,
        decoration: const BoxDecoration(
          color: AppTheme.secondaryColor,
          border: Border(right: BorderSide(color: Colors.white10, width: 1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(4, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Logo Section
            AnimatedPadding(
              duration: animDuration,
              curve: animCurve,
              padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 12 : 24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Carefully hide text to avoid overflow during transition
                  // We require at least 100px to attempt showing text + gap
                  final bool showText = constraints.maxWidth > 100;

                  return Row(
                    mainAxisAlignment: isCollapsed
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.bolt_rounded,
                          color: Colors.black87,
                          size: 26,
                        ),
                      ),
                      if (showText) ...[
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            'Yollr Admin',
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 50),

            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: [
                  _buildSectionHeader(isCollapsed, "MENU"),
                  _buildMenuItem(
                    context,
                    title: 'Dashboard',
                    icon: Icons.dashboard_rounded,
                    page: AdminPage.dashboard,
                    controller: controller,
                    isCollapsed: isCollapsed,
                  ),
                  _buildMenuItem(
                    context,
                    title: 'User Management',
                    icon: Icons.people_alt_rounded,
                    page: AdminPage.users,
                    controller: controller,
                    isCollapsed: isCollapsed,
                  ),
                  _buildMenuItem(
                    context,
                    title: 'Post Moderation',
                    icon: Icons.article_rounded,
                    page: AdminPage.posts,
                    controller: controller,
                    isCollapsed: isCollapsed,
                  ),
                  _buildMenuItem(
                    context,
                    title: 'Live Analytics',
                    icon: Icons.analytics_rounded,
                    page: AdminPage.analytics,
                    controller: controller,
                    isCollapsed: isCollapsed,
                  ),
                  const SizedBox(height: 20),
                  _buildSectionHeader(isCollapsed, "SYSTEM"),
                  _buildMenuItem(
                    context,
                    title: 'Settings',
                    icon: Icons.settings_rounded,
                    page: AdminPage.settings,
                    controller: controller,
                    isCollapsed: isCollapsed,
                  ),
                  _buildMenuItem(
                    context,
                    title: 'Logout',
                    icon: Icons.logout_rounded,
                    page: AdminPage.settings,
                    controller: controller,
                    isCollapsed: isCollapsed,
                    isLogout: true,
                  ),
                ],
              ),
            ),
            // User Profile Section
            AnimatedContainer(
              duration: animDuration,
              curve: animCurve,
              margin: const EdgeInsets.all(12),
              padding: EdgeInsets.all(isCollapsed ? 4 : 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final bool showDetails = constraints.maxWidth > 100;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: AppTheme.primaryColor,
                        child: Icon(
                          Icons.person,
                          color: Colors.black87,
                          size: 18,
                        ),
                      ),
                      if (showDetails) ...[
                        const SizedBox(width: 12),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Super Admin',
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                softWrap: false,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'admin@yollr.com',
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                softWrap: false,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.more_vert_rounded,
                          color: Colors.white30,
                          size: 18,
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    });
  }

  Widget _buildSectionHeader(bool isCollapsed, String title) {
    if (isCollapsed) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 8, top: 0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white.withOpacity(0.4),
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required AdminPage page,
    required AdminController controller,
    required bool isCollapsed,
    bool isLogout = false,
  }) {
    return Obx(() {
      // Always access the value to avoid "Improper use of GetX" error
      final activePage = controller.currentPage.value;
      final bool isSelected = !isLogout && activePage == page;
      final Color activeColor = AppTheme.primaryColor;
      final Color inactiveColor = Colors.white.withOpacity(0.6);

      // Consistent animation parameters
      const Duration animDuration = Duration(milliseconds: 300);
      const Curve animCurve = Curves.easeInOutCubic;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: () {
              if (isLogout) {
                controller.logout();
              } else {
                controller.setPage(page);
              }
              if (isMobile) Get.back();
            },
            borderRadius: BorderRadius.circular(12),
            hoverColor: Colors.white.withOpacity(0.05),
            child: AnimatedContainer(
              duration: animDuration,
              curve: animCurve,
              padding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: isCollapsed ? 0 : 16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isSelected
                    ? activeColor.withOpacity(0.15)
                    : Colors.transparent,
                border: isSelected
                    ? Border.all(color: activeColor.withOpacity(0.2), width: 1)
                    : Border.all(color: Colors.transparent, width: 1),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Only show text if there's enough room safely
                  final bool showText = constraints.maxWidth > 80;

                  return Row(
                    mainAxisAlignment: isCollapsed
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      Icon(
                        icon,
                        color: isSelected ? activeColor : inactiveColor,
                        size: 22,
                      ),
                      if (showText) ...[
                        const SizedBox(width: 14),
                        Flexible(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: TextStyle(
                              color: isSelected ? Colors.white : inactiveColor,
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: activeColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );
    });
  }
}
