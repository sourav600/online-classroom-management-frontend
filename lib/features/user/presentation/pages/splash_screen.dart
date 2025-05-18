import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    _checkLoginStatus();

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  void _checkLoginStatus() async {
    final token = await secureStorage.read(key: 'jwt');

    if (token != null && token.isNotEmpty) {
      Get.offAllNamed('/dashboard');
    } else {
      Get.offAllNamed('/login');
    }
  }
}
