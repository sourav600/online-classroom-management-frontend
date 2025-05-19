import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_classroom_frontend/core/utils/app_colors.dart';
import '../controllers/user_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String getGatewayPhotoUrl(String originalUrl) {
    return originalUrl.replaceFirst(':5001', ':5000');
  }

  Future<void> _callUploadPhoto(
      XFile? pickedFile, UserController controller) async {
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final user = controller.userProfile.value;

      if (user != null) {
        await controller.uploadUserPhoto(user.id, file);
      } else {
        Get.snackbar('Error', 'User not logged in');
      }
    }
  }

  Future<void> _showPhotoOptions(
      BuildContext context, UserController controller) async {
    final picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take a photo'),
            onTap: () async {
              Navigator.pop(context);
              final pickedFile =
                  await picker.pickImage(source: ImageSource.camera);

              _callUploadPhoto(pickedFile, controller);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from gallery'),
            onTap: () async {
              Navigator.pop(context);
              final pickedFile =
                  await picker.pickImage(source: ImageSource.gallery);
              _callUploadPhoto(pickedFile, controller);
            },
          ),
          ListTile(
            leading: const Icon(Icons.close),
            title: const Text('Cancel'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.offNamed('/dashboard');
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Obx(() {
        if (userController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (userController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Text(
              userController.errorMessage.value,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final user = userController.userProfile.value;
        if (user == null) {
          return const Center(child: Text('No profile data'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Profile Picture with upload icon
              GestureDetector(
                onTap: () => _showPhotoOptions(context, userController),
                child: Stack(children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.primary,
                    backgroundImage: user.profilePicture != null &&
                            user.profilePicture!.isNotEmpty
                        ? NetworkImage(
                            '${getGatewayPhotoUrl(user.profilePicture!)}?t=${DateTime.now().millisecondsSinceEpoch}',
                            headers: {
                              'Authorization':
                                  'Bearer ${userController.jwtToken.value}',
                            },
                          )
                        : null,
                    child: user.profilePicture == null ||
                            user.profilePicture!.isEmpty
                        ? const Icon(Icons.person,
                            size: 50, color: AppColors.background)
                        : null,
                  ),
                  Positioned(
                      bottom: 0,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border:
                              Border.all(color: AppColors.primary, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ))
                ]),
              ),

              const SizedBox(height: 20),
              // Info Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.only(top: 10),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildProfileRow(Icons.person, 'Name',
                          '${user.firstName} ${user.lastName}'),
                      _buildProfileRow(
                          Icons.account_circle, 'Username', user.username),
                      _buildProfileRow(Icons.email, 'Email', user.email),
                      _buildProfileRow(Icons.flag, 'Country', user.country),
                      _buildProfileRow(Icons.male, 'Gender', user.gender),
                      if (user.currentInstitute != null)
                        _buildProfileRow(Icons.school, 'Institute',
                            user.currentInstitute ?? 'N/A'),
                      _buildProfileRow(Icons.security, 'Roles',
                          user.roles.map((r) => r.name).join(', ')),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Refresh button
              ElevatedButton.icon(
                onPressed: () => userController.fetchUserProfile(),
                icon: const Icon(Icons.refresh),
                label: const Text("Refresh Profile"),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.background,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$title:',
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
