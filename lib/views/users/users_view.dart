import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user_controller.dart';
import '../../core/app_theme.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.put(UserController());

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSmall = constraints.maxWidth < 800;

        return Padding(
          padding: EdgeInsets.all(isSmall ? 16.0 : 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User Management',
                style: TextStyle(
                  fontSize: isSmall ? 24 : 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Text(
                    'Search, verify, and moderate users across all campuses.',
                    style: TextStyle(color: AppTheme.textSecondaryColor),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => controller.loadUsers(),
                    tooltip: 'Refresh User List',
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Search and Filters
              if (isSmall)
                Column(
                  children: [
                    _buildSearchField(),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('Verified Only'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Banned Only'),
                          const SizedBox(width: 8),
                          _buildFilterChip('All Campuses', isDropdown: true),
                        ],
                      ),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(child: _buildSearchField()),
                    const SizedBox(width: 16),
                    _buildFilterChip('Verified Only'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Banned Only'),
                    const SizedBox(width: 8),
                    _buildFilterChip('All Campuses', isDropdown: true),
                  ],
                ),
              const SizedBox(height: 24),
              // Users Table
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.users.isEmpty) {
                    return const Center(child: Text('No users found.'));
                  }

                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: isSmall ? 20 : 40,
                          columns: const [
                            DataColumn(
                              label: Text(
                                'USER',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'EMAIL',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'CAMPUS',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'STATUS',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'ACTIONS',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          rows: controller.users
                              .map(
                                (user) => DataRow(
                                  cells: [
                                    DataCell(
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 14,
                                            backgroundColor: Colors.white10,
                                            child: ClipOval(
                                              child:
                                                  (user.profileImage != null &&
                                                      user
                                                          .profileImage!
                                                          .isNotEmpty)
                                                  ? Image.network(
                                                      user.profileImage!,
                                                      fit: BoxFit.cover,
                                                      width: 28,
                                                      height: 28,
                                                      errorBuilder:
                                                          (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) {
                                                            return const Icon(
                                                              Icons.person,
                                                              size: 16,
                                                              color: Colors
                                                                  .white70,
                                                            );
                                                          },
                                                    )
                                                  : const Icon(
                                                      Icons.person,
                                                      size: 16,
                                                      color: Colors.white70,
                                                    ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(user.username),
                                        ],
                                      ),
                                    ),
                                    DataCell(Text(user.email)),
                                    DataCell(Text(user.campus)),
                                    DataCell(
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: user.isOnline
                                              ? Colors.green.withOpacity(0.1)
                                              : Colors.grey.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          user.isOnline ? 'Online' : 'Offline',
                                          style: TextStyle(
                                            color: user.isOnline
                                                ? Colors.greenAccent
                                                : Colors.grey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit_outlined,
                                              size: 18,
                                            ),
                                            onPressed: () {},
                                            tooltip: 'Edit Profile',
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.verified_user_outlined,
                                              size: 18,
                                            ),
                                            onPressed: () {},
                                            tooltip: 'Verify User',
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.block_flipped,
                                              size: 18,
                                              color: AppTheme.errorColor,
                                            ),
                                            onPressed: () {},
                                            tooltip: 'Ban User',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search by username, email or ID...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: AppTheme.secondaryColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isDropdown = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          if (isDropdown) ...[
            const SizedBox(width: 8),
            const Icon(Icons.keyboard_arrow_down, size: 18),
          ],
        ],
      ),
    );
  }
}
