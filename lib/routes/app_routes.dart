import 'package:get/get.dart';
import 'package:online_classroom_frontend/features/user/presentation/pages/dashboard_screen.dart';
import 'package:online_classroom_frontend/features/user/presentation/pages/login_screen.dart';
import '../features/user/presentation/pages/register_screen.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/register', page: () => RegisterScreen()),
    GetPage(name: '/login', page: () => const LoginScreen()),
    GetPage(name: '/dashboard', page: () => const DashboardScreen())
  ];
}
