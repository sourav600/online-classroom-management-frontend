import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
  // External services
  Get.lazyPut(() => http.Client());
  Get.lazyPut(() => const FlutterSecureStorage());
  Get.lazyPut(() => Connectivity());

  // Core
  Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl(Get.find<Connectivity>()));

  // Data sources
  Get.lazyPut<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(Get.find<http.Client>()));
  Get.lazyPut<UserLocalDataSource>(() => UserLocalDataSourceImpl(Get.find()));

  // Repository
  Get.lazyPut<UserRepository>(() => UserRepositoryImpl(
        remoteDataSource: Get.find(),
        localDataSource: Get.find(),
        networkInfo: Get.find<NetworkInfo>(),
      ));

  // Use cases
  Get.lazyPut(() => RegisterUser(Get.find<UserRepository>()));
  Get.lazyPut(() => LoginUser(Get.find()));
  Get.lazyPut(() => RefreshToken(Get.find()));
  Get.lazyPut(() => GetUserProfile(Get.find()));
  Get.lazyPut(() => GetUserProfileById(Get.find()));
  Get.lazyPut(() => UploadPhoto(Get.find()));
  Get.lazyPut(() => GetPhoto(Get.find()));
  Get.lazyPut(() => SearchByImage(Get.find()));

  // Controllers
  Get.lazyPut(() => AuthController(
      registerUser: Get.find<RegisterUser>(),
      loginUser: Get.find(),
      refreshToken: Get.find()));

  Get.lazyPut(() => UserController(
        localDataSource: Get.find(),
        getUserProfile: Get.find<GetUserProfile>(),
        getUserProfileById: Get.find(),
        uploadPhoto: Get.find(),
        getPhoto: Get.find(),
        searchByImage: Get.find(),
      ));

  // Eager initialization
  Get.put(UserRemoteDataSourceImpl(Get.find<http.Client>()));
  Get.put(UserLocalDataSourceImpl(Get.find()));
}
