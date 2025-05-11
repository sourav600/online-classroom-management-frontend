import 'package:get/get.dart';
import '../features/user/presentation/pages/register_screen.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/register', page: () => RegisterScreen())
  ];
}