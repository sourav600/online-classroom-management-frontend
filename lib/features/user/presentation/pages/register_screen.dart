import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_classroom_frontend/core/utils/app_colors.dart';
import 'package:online_classroom_frontend/features/user/data/models/user_model.dart';
import '../controllers/auth_controller.dart';
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
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => Form(
                key: formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: firstNameController,
                        label: 'First Name',
                        validator: (value) {
                          if (value?.isEmpty ?? true)
                            return 'First name is required';
                          if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value!)) {
                            return 'Only letters allowed';
                          }
                          if (value.length < 2 || value.length > 10) {
                            return '2-10 characters required';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        controller: lastNameController,
                        label: 'Last Name',
                        validator: (value) {
                          if (value?.isEmpty ?? true)
                            return 'Last name is required';
                          if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value!)) {
                            return 'Only letters allowed';
                          }
                          if (value.length < 3 || value.length > 15) {
                            return '3-15 characters required';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        controller: instituteController,
                        label: 'Institute (Optional)',
                      ),
                      DropdownButtonFormField<String>(
                        value: selectedGender.value.isEmpty
                            ? null
                            : selectedGender.value,
                        onChanged: (value) => selectedGender.value = value!,
                        items: ['Male', 'Female', 'Other']
                            .map((gender) => DropdownMenuItem(
                                value: gender, child: Text(gender)))
                            .toList(),
                        decoration: const InputDecoration(labelText: 'Gender'),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Gender is required'
                            : null,
                      ),
                      CustomTextField(
                        controller: countryController,
                        label: 'Country',
                        validator: (value) => value?.isEmpty ?? true
                            ? 'Country is required'
                            : null,
                      ),
                      Obx(() => DropdownButtonFormField<String>(
                            value: selectedRole.value.isEmpty
                                ? null
                                : selectedRole.value,
                            decoration: const InputDecoration(
                              labelText: 'Role',
                              border: OutlineInputBorder(),
                            ),
                            items: ['ADMIN', 'TEACHER', 'STUDENT']
                                .map((role) => DropdownMenuItem(
                                    value: role, child: Text(role)))
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
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Username is required';
                          }
                          if (value!.length < 4 || value.length > 20) {
                            return '4-20 characters required';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        controller: emailController,
                        label: 'Email',
                        validator: (value) {
                          if (value?.isEmpty ?? true)
                            return 'Email is required';
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value!)) {
                            return 'Invalid email format';
                          }
                          return null;
                        },
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
                                  isPasswordHidden.value =
                                      !isPasswordHidden.value;
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Password is required';
                              }
                              if (value!.length < 6) {
                                return 'Password must be at least 6 characters long';
                              }
                              if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])')
                                  .hasMatch(value)) {
                                return 'Must include both uppercase and lowercase letters';
                              }
                              if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                                  .hasMatch(value)) {
                                return 'At least one special character is required';
                              }
                              return null;
                            },
                          )),
                      const SizedBox(height: 20),
                      Obx(() => SizedBox(
                            width: double.infinity,
                            child: authController.isLoading.value
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: () {
                                      if (formKey.currentState?.validate() ??
                                          false) {
                                        final roleName = selectedRole.value;
                                        final user = UserModel(
                                          firstName: firstNameController.text,
                                          lastName: lastNameController.text,
                                          currentInstitute:
                                              instituteController.text.isEmpty
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
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text('REGISTER',
                                        style: TextStyle(
                                            color: AppColors.background)),
                                  ),
                          )),
                      Obx(() => authController.errorMessage.value.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                authController.errorMessage.value,
                                style: const TextStyle(color: Colors.red),
                              ),
                            )
                          : const SizedBox()),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => Get.toNamed('/login'),
                        child: const Text(
                          'Already have an account? Login',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ))),
    );
  }
}
