import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_classroom_frontend/core/utils/app_colors.dart';
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
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          floatingLabelStyle: TextStyle(color: AppColors.primary),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color:AppColors.primary, width: 2)),                    
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red)),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent, width: 2))                  
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      getPages: AppRoutes.routes,
      initialRoute: '/register',
    );
  }
}