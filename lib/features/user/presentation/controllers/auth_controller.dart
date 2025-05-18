import 'package:get/get.dart';
import 'package:online_classroom_frontend/features/user/data/datasources/user_local_data_source.dart';
import 'package:online_classroom_frontend/features/user/domain/usecases/login_user.dart';
import 'package:online_classroom_frontend/features/user/domain/usecases/refresh_token.dart';
import '../../domain/usecases/register_user.dart';
import '../../domain/entities/user.dart';

class AuthController extends GetxController {
  final RegisterUser registerUser;
  final LoginUser loginUser;
  final RefreshToken refreshToken;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<User?> currentUser = Rx<User?>(null);

  AuthController(
      {required this.registerUser,
      required this.loginUser,
      required this.refreshToken});

  Future<void> register(User user) async {
    isLoading.value = true;
    errorMessage.value = '';
    final result = await registerUser(RegisterParams(user: user));
    result.fold(
      (failure) => errorMessage.value = failure.errorMessage,
      (user) {
        currentUser.value = user;
        Get.offNamed('/login');
      },
    );
    isLoading.value = false;
  }

  Future<void> login(String username, String password) async {
    isLoading.value = true;
    errorMessage.value = '';
    final result =
        await loginUser(LoginParams(username: username, password: password));
    result.fold(
      (failure) => errorMessage.value = failure.errorMessage,
      (authResponse) {
        Get.offNamed('/dashboard');
      },
    );
    isLoading.value = false;
  }

  Future<bool> refresh() async {
    final refreshTokenValue =
        await Get.find<UserLocalDataSource>().getRefreshToken();
    if (refreshTokenValue == null) return false;

    isLoading.value = true;
    final result =
        await refreshToken(RefreshTokenParams(refreshToken: refreshTokenValue));
    final success = result.fold(
      (failure) {
        errorMessage.value = failure.errorMessage;
        return false;
      },
      (_) => true,
    );
    isLoading.value = false;
    return success;
  }

  void logout() {
    Get.find<UserLocalDataSource>().clearTokens();
    currentUser.value = null;
    Get.offAllNamed('/login');
  }
}
