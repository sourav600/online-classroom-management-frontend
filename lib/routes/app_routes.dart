import 'package:get/get.dart';
import 'package:online_classroom_frontend/features/user/presentation/pages/splash_screen.dart';
import '../features/user/presentation/pages/login_screen.dart';
import '../features/user/presentation/pages/register_screen.dart';
import '../features/user/presentation/pages/dashboard_screen.dart';
import '../features/user/presentation/pages/profile_screen.dart';
import '../features/user/presentation/pages/photo_upload_screen.dart';
import '../features/user/presentation/pages/image_search_screen.dart';

class AppRoutes {
  static const String SPLASH = '/splash-screen';
  static const String LOGIN = '/login';
  static const String REGISTER = '/register';
  static const String DASHBOARD = '/dashboard';
  static const String PROFILE = '/profile';
  static const String UPLOAD_PHOTO = '/upload-photo';
  static const String IMAGE_SEARCH = '/image-search';

  static final routes = [
    GetPage(name: SPLASH, page: () => const SplashScreen()),
    GetPage(name: LOGIN, page: () => const LoginScreen()),
    GetPage(name: REGISTER, page: () => RegisterScreen()),
    GetPage(name: DASHBOARD, page: () => const DashboardScreen()),
    GetPage(name: PROFILE, page: () => const ProfileScreen()),
    GetPage(name: UPLOAD_PHOTO, page: () => const PhotoUploadScreen()),
    GetPage(name: IMAGE_SEARCH, page: () => const ImageSearchScreen()),
  ];
}
