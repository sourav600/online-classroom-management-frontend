import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/user_controller.dart';
import '../widgets/custom_button.dart';

class ImageSearchScreen extends StatelessWidget {
  const ImageSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final picker = ImagePicker();

    return Scaffold(
      appBar: AppBar(title: const Text('Search by Image')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomButton(
              text: 'Pick Image',
              onPressed: () async {
                final pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  final file = File(pickedFile.path);
                  await userController.searchUsersByImage(file);
                }
              },
            ),
            Obx(() => userController.isLoading.value
                ? const CircularProgressIndicator()
                : userController.errorMessage.value.isNotEmpty
                    ? Text(
                        userController.errorMessage.value,
                        style: const TextStyle(color: Colors.red),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: userController.searchResults.length,
                          itemBuilder: (context, index) {
                            final user = userController.searchResults[index];
                            return ListTile(
                              title: Text('${user.firstName} ${user.lastName}'),
                              subtitle: Text(user.username),
                              onTap: () =>
                                  Get.toNamed('/profile', arguments: user.id),
                            );
                          },
                        ),
                      )),
          ],
        ),
      ),
    );
  }
}
