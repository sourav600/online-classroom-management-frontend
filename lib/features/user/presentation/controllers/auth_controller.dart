import 'package:get/get.dart';
import '../../domain/usecases/register_user.dart';
import '../../domain/entities/user.dart';

class AuthController extends GetxController {
  final RegisterUser registerUser;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<User?> currentUser = Rx<User?>(null);

  AuthController({
    required this.registerUser
  });

  Future<void> register(User user) async {
    isLoading.value = true;
    errorMessage.value = '';
    final result = await registerUser(RegisterParams(user: user));
    result.fold(
      (failure) => errorMessage.value = failure.errorMessage,
      (user) {
        currentUser.value = user;
        Get.offNamed('/register');
      },
    );
    isLoading.value = false;
  }

  }