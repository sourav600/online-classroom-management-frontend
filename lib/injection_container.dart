import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:online_classroom_frontend/core/utils/logger.dart';
import 'package:online_classroom_frontend/features/user/data/datasources/user_local_data_source.dart';
import 'package:online_classroom_frontend/features/user/domain/repositories/user_repository.dart';
import 'package:online_classroom_frontend/features/user/domain/usecases/get_photo.dart';
import 'package:online_classroom_frontend/features/user/domain/usecases/get_user_profile.dart';
import 'package:online_classroom_frontend/features/user/domain/usecases/get_user_profile_by_id.dart';
import 'package:online_classroom_frontend/features/user/domain/usecases/login_user.dart';
import 'package:online_classroom_frontend/features/user/domain/usecases/refresh_token.dart';
import 'package:online_classroom_frontend/features/user/domain/usecases/search_by_image.dart';
import 'package:online_classroom_frontend/features/user/domain/usecases/upload_photo.dart';
import 'package:online_classroom_frontend/features/user/presentation/controllers/user_controller.dart';
import 'features/user/data/datasources/user_remote_data_source.dart';
import 'features/user/data/repositories/user_repository_impl.dart';
import 'features/user/domain/usecases/register_user.dart';
import 'features/user/presentation/controllers/auth_controller.dart';
import 'core/network/network_info.dart';

void initDependencies() {
  Logger.log("Dependencies initialized");
  // External services
  Get.lazyPut(() => http.Client());
  Get.lazyPut(() => const FlutterSecureStorage(), fenix: true);
  Get.lazyPut(() => Connectivity(), fenix: true);

  // Core
  Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl(Get.find<Connectivity>()),
      fenix: true);

  // Data sources
  Get.lazyPut<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(Get.find<http.Client>()),
      fenix: true);
  Get.lazyPut<UserLocalDataSource>(() => UserLocalDataSourceImpl(Get.find()),
      fenix: true);

  // Repository
  Get.lazyPut<UserRepository>(
      () => UserRepositoryImpl(
            remoteDataSource: Get.find(),
            localDataSource: Get.find(),
            networkInfo: Get.find<NetworkInfo>(),
          ),
      fenix: true);

  // Use cases
  Get.lazyPut(() => RegisterUser(Get.find<UserRepository>()), fenix: true);
  Get.lazyPut(() => LoginUser(Get.find()), fenix: true);
  Get.lazyPut(() => RefreshToken(Get.find()), fenix: true);
  Get.lazyPut(() => GetUserProfile(Get.find()), fenix: true);
  Get.lazyPut(() => GetUserProfileById(Get.find()), fenix: true);
  Get.lazyPut(() => UploadPhoto(Get.find()), fenix: true);
  Get.lazyPut(() => GetPhoto(Get.find()), fenix: true);
  Get.lazyPut(() => SearchByImage(Get.find()), fenix: true);

  // Controllers
  Get.lazyPut(
      () => AuthController(
          registerUser: Get.find(),
          loginUser: Get.find(),
          refreshToken: Get.find()),
      fenix: true);

  Get.lazyPut(
      () => UserController(
            localDataSource: Get.find(),
            getUserProfile: Get.find(),
            getUserProfileById: Get.find(),
            uploadPhoto: Get.find(),
            getPhoto: Get.find(),
            searchByImage: Get.find(),
          ),
      fenix: true);

  // Eager initialization
  Get.put(UserRemoteDataSourceImpl(Get.find<http.Client>()));
  Get.put(UserLocalDataSourceImpl(Get.find()));
}
