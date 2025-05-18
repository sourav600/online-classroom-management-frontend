import 'package:get/get.dart';
import '../features/user/presentation/pages/login_screen.dart';
import '../features/user/presentation/pages/register_screen.dart';
import '../features/user/presentation/pages/dashboard_screen.dart';
import '../features/user/presentation/pages/profile_screen.dart';
import '../features/user/presentation/pages/photo_upload_screen.dart';
import '../features/user/presentation/pages/image_search_screen.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/login', page: () => const LoginScreen()),
    GetPage(name: '/register', page: () => RegisterScreen()),
    GetPage(name: '/dashboard', page: () => const DashboardScreen()),
    GetPage(name: '/profile', page: () => const ProfileScreen()),
    GetPage(name: '/photo-upload', page: () => const PhotoUploadScreen()),
    GetPage(name: '/image-search', page: () => const ImageSearchScreen()),
  ];
}
