import 'dart:io';
import 'package:get/get.dart';
import 'package:online_classroom_frontend/features/user/data/datasources/user_local_data_source.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/get_user_profile_by_id.dart';
import '../../domain/usecases/upload_photo.dart';
import '../../domain/usecases/get_photo.dart';
import '../../domain/usecases/search_by_image.dart';
import '../../domain/entities/user.dart';

class UserController extends GetxController {
  final UserLocalDataSource localDataSource;
  final GetUserProfile getUserProfile;
  final GetUserProfileById getUserProfileById;
  final UploadPhoto uploadPhoto;
  final GetPhoto getPhoto;
  final SearchByImage searchByImage;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<User?> userProfile = Rx<User?>(null);
  final RxList<User> searchResults = <User>[].obs;
  final RxString jwtToken = ''.obs;

  UserController({
    required this.localDataSource,
    required this.getUserProfile,
    required this.getUserProfileById,
    required this.uploadPhoto,
    required this.getPhoto,
    required this.searchByImage,
  });

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
    loadToken();
  }

  Future<void> fetchUserProfile() async {
    isLoading.value = true;
    errorMessage.value = '';
    final result = await getUserProfile(NoParams());
    result.fold(
      (failure) => errorMessage.value = failure.errorMessage,
      (user) => userProfile.value = user,
    );
    isLoading.value = false;
  }

  Future<void> fetchUserProfileById(int id) async {
    isLoading.value = true;
    errorMessage.value = '';
    final result = await getUserProfileById(GetUserProfileByIdParams(id: id));
    result.fold(
      (failure) => errorMessage.value = failure.errorMessage,
      (user) => userProfile.value = user,
    );
    isLoading.value = false;
  }

  Future<void> uploadUserPhoto(int id, File file) async {
    isLoading.value = true;
    errorMessage.value = '';
    final result = await uploadPhoto(UploadPhotoParams(id: id, file: file));
    result.fold(
      (failure) => errorMessage.value = failure.errorMessage,
      (url) {
        userProfile.value = userProfile.value?.copyWith(profilePicture: url);
        Get.snackbar('Success', 'Photo uploaded successfully');
      },
    );
    isLoading.value = false;
  }

  Future<List<int>?> fetchPhoto(String filename) async {
    isLoading.value = true;
    errorMessage.value = '';
    final result = await getPhoto(GetPhotoParams(filename: filename));
    isLoading.value = false;
    return result.fold(
      (failure) {
        errorMessage.value = failure.errorMessage;
        return null;
      },
      (bytes) => bytes,
    );
  }

  Future<void> searchUsersByImage(File image) async {
    isLoading.value = true;
    errorMessage.value = '';
    final result = await searchByImage(SearchByImageParams(image: image));
    result.fold(
      (failure) => errorMessage.value = failure.errorMessage,
      (users) => searchResults.assignAll(users),
    );
    isLoading.value = false;
  }

  Future<void> loadToken() async {
    jwtToken.value = (await localDataSource.getToken())!;
  }
}

extension UserExtension on User {
  User copyWith({String? profilePicture}) {
    return User(
        id: id,
        firstName: firstName,
        lastName: lastName,
        currentInstitute: currentInstitute,
        country: country,
        gender: gender,
        roles: roles,
        profilePicture: profilePicture ?? this.profilePicture,
        username: username,
        email: email,
        password: password);
  }
}
