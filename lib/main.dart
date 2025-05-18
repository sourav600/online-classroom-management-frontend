import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_classroom_frontend/core/theme/app_theme.dart';
import 'injection_container.dart';
import 'routes/app_routes.dart';

void main() {
  initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Online Classroom Management',
        getPages: AppRoutes.routes,
        initialRoute: AppRoutes.SPLASH,
        theme: AppTheme.lightTheme);
  }
}
