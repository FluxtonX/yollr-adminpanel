import 'package:get/get.dart';
import '../models/user_model.dart';
import '../core/user_service.dart';

class UserController extends GetxController {
  var users = <AdminUserModel>[].obs;
  var isLoading = true.obs;
  final AdminUserService _userService = AdminUserService();

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      isLoading.value = true;
      final fetchedUsers = await _userService.fetchAllUsers();
      users.assignAll(fetchedUsers);
    } finally {
      isLoading.value = false;
    }
  }
}
