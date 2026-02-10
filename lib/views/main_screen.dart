import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_controller.dart';
import '../widgets/sidebar.dart';
import '../core/app_theme.dart';
import '../views/dashboard/dashboard_view.dart';
import '../views/users/users_view.dart';
import '../views/posts/posts_view.dart';
import '../views/analytics/analytics_view.dart';
import '../views/events/events_view.dart';

class AdminMainScreen extends StatelessWidget {
  const AdminMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminController controller = Get.put(AdminController());

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 700;
        final bool isTablet =
            constraints.maxWidth >= 700 && constraints.maxWidth < 1100;

        // Update collapse state based on screen size automatically
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (isTablet && !controller.isSidebarCollapsed.value) {
            controller.isSidebarCollapsed.value = true;
          } else if (!isTablet &&
              !isMobile &&
              controller.isSidebarCollapsed.value) {
            // You might not want to auto-expand if user explicitly collapsed it
            // but for now let's keep it simple
          }
        });

        return Scaffold(
          drawer: isMobile
              ? const Drawer(child: Sidebar(isMobile: true))
              : null,
          appBar: isMobile
              ? AppBar(
                  title: const Text('Yollr Admin'),
                  leading: Builder(
                    builder: (context) {
                      return IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      );
                    },
                  ),
                )
              : null,
          body: Row(
            children: [
              if (!isMobile) const Sidebar(),
              Expanded(
                child: Container(
                  color: AppTheme.darkBgColor,
                  child: Column(
                    children: [
                      if (!isMobile)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.menu),
                                onPressed: () => controller.toggleSidebar(),
                              ),
                              const Spacer(),
                              // Top bar search or notifications could go here
                            ],
                          ),
                        ),
                      Expanded(
                        child: Obx(() {
                          switch (controller.currentPage.value) {
                            case AdminPage.dashboard:
                              return const DashboardView();
                            case AdminPage.users:
                              return const UsersView();
                            case AdminPage.posts:
                              return const PostsView();
                            case AdminPage.events:
                              return const EventsView();
                            case AdminPage.analytics:
                              return const AnalyticsView();
                            case AdminPage.settings:
                              return const Center(child: Text('Settings'));
                          }
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
