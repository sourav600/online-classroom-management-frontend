import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_classroom_frontend/core/utils/app_colors.dart';
import 'package:online_classroom_frontend/features/user/data/models/user_model.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final instituteController = TextEditingController();
  final countryController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? _validateInput() {
    if (firstNameController.text.length < 2 || firstNameController.text.length > 10) {
      return 'First name must be 2-10 characters';
    }
    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(firstNameController.text)) {
      return 'First name must contain only letters';
    }
    if (lastNameController.text.length < 3 || lastNameController.text.length > 15) {
      return 'Last name must be 3-15 characters';
    }
    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(lastNameController.text)) {
      return 'Last name must contain only letters';
    }
    if (countryController.text.isEmpty) {
      return 'Country is required';
    }
    if (usernameController.text.length < 4 || usernameController.text.length > 20) {
      return 'Username must be 4-20 characters';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailController.text)) {
      return 'Invalid email format';
    }
    if (passwordController.text.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final formKey = GlobalKey<FormState>();
    final RxString selectedRole = ''.obs;
    final RxString selectedGender = ''.obs;
    final isPasswordHidden = true.obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              controller: firstNameController,
              label: 'First Name',
            ),
            CustomTextField(
              controller: lastNameController,
              label: 'Last Name',
            ),
            CustomTextField(
              controller: instituteController,
              label: 'Current Institute (Optional)',
            ),
            DropdownButtonFormField<String>(
              value: selectedGender.value.isEmpty ? null : selectedGender.value,
              onChanged: (value) => selectedGender.value = value!,
              items: ['Male', 'Female', 'Other']
                .map((gender) =>
                DropdownMenuItem(value: gender, child: Text(gender)))
                .toList(),
              decoration: const InputDecoration(labelText: 'Gender'),
              validator: (value) =>
                value == null || value.isEmpty ? 'Gender is required' : null,
            ),
              
            CustomTextField(
              controller: countryController,
              label: 'Country',
            ),
          
            Obx(() => DropdownButtonFormField<String>(
                  value: selectedRole.value.isEmpty ? null : selectedRole.value,
                  decoration: const InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(),
                  ),
                  items: ['ADMIN', 'TEACHER', 'STUDENT']
                        .map((role) =>
                          DropdownMenuItem(value: role, child: Text(role)))
                          .toList(),
                  onChanged: (value) {
                    if (value != null) selectedRole.value = value;
                  },
                  validator: (value) =>
                              value == null ? 'Role is required' : null,
                )),
          
            CustomTextField(
              controller: usernameController,
              label: 'Username',
            ),
            CustomTextField(
              controller: emailController,
              label: 'Email',
            ),
            Obx(() => TextFormField(
              controller: passwordController,
              obscureText: isPasswordHidden.value,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordHidden.value
                    ? Icons.visibility
                    : Icons.visibility_off,
                  ),
                  onPressed: () {
                    isPasswordHidden.value = !isPasswordHidden.value;
                  },
                ),
              ),
            )),

            const SizedBox(height: 20),
            Obx(() => SizedBox(
              width: double.infinity,
              child: authController.isLoading.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        final error = _validateInput();
                        if(error != null){
                          authController.errorMessage.value = error;
                          return;
                        }
                        final roleName = selectedRole.value;
                        final user = UserModel(
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          currentInstitute: instituteController.text.isEmpty
                              ? null
                              : instituteController.text,
                          country: countryController.text,
                          gender: selectedGender.value,
                          roleNames: {roleName},
                          profilePicture: null,
                          username: usernameController.text,
                          email: emailController.text, 
                          password: passwordController.text,
                        );
                        authController.register(user);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                   child: const Text('REGISTER', style: TextStyle(color: AppColors.background)),              
                  ),
            )
              ),
            Obx(() => authController.errorMessage.value.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      authController.errorMessage.value,
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