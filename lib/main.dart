import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/app_theme.dart';
import 'controllers/admin_controller.dart';
import 'views/auth/signin_view.dart';
import 'views/main_screen.dart';

void main() {
  runApp(const YollrAdminApp());
}

class YollrAdminApp extends StatelessWidget {
  const YollrAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize Auth Controller
    final controller = Get.put(AdminController());

    return GetMaterialApp(
      title: 'Yollr Admin Panel',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: Obx(() {
        return controller.isLoggedIn.value
            ? const AdminMainScreen()
            : const SignInView();
      }),
    );
  }
}
