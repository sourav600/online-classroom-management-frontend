import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_classroom_frontend/routes/app_routes.dart';
import '../controllers/auth_controller.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authController.logout(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Classroom Management!',
                style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.toNamed(AppRoutes.PROFILE),
              child: const Text('View Profile'),
            ),
            ElevatedButton(
              onPressed: () => Get.toNamed(AppRoutes.UPLOAD_PHOTO),
              child: const Text('Upload Photo'),
            ),
            ElevatedButton(
              onPressed: () => Get.toNamed(AppRoutes.IMAGE_SEARCH),
              child: const Text('Search by Image'),
            ),
          ],
        ),
      ),
    );
  }
}
