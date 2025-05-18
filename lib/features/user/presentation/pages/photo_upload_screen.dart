import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/user_controller.dart';
import '../widgets/custom_button.dart';

class PhotoUploadScreen extends StatelessWidget {
  const PhotoUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final picker = ImagePicker();

    return Scaffold(
      appBar: AppBar(title: const Text('Upload Photo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() => userController.isLoading.value
                ? const CircularProgressIndicator()
                : CustomButton(
                    text: 'Pick Photo',
                    onPressed: () async {
                      final pickedFile =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        final file = File(pickedFile.path);
                        final user = userController.userProfile.value;
                        if (user != null) {
                          await userController.uploadUserPhoto(user.id, file);
                        } else {
                          Get.snackbar('Error', 'User not logged in');
                        }
                      }
                    },
                  )),
            Obx(() => userController.errorMessage.value.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      userController.errorMessage.value,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : const SizedBox()),
          ],
        ),
      ),
    );
  }
}
