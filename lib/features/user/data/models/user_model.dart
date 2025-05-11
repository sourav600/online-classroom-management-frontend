import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/role.dart';

part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserModel extends User {

  @JsonKey(includeToJson: false)
  final int id;

  @JsonKey(name: 'roles')
  final Set<String> roleNames;
  final String password;

  UserModel({
    this.id = 0,
    required String firstName,
    required String lastName,
    String? currentInstitute,
    required String country,
    required String gender,
    required this.roleNames,
    String? profilePicture,
    required String username,
    required String email,
    required this.password,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          currentInstitute: currentInstitute,
          country: country,
          gender: gender,
          roles: roleNames.map((role) => Role(id: 0, name: role, authority: role)).toSet(),
          profilePicture: profilePicture,
          username: username,
          email: email,
          password: password
        );


  factory UserModel.fromJson(Map<String, dynamic> json) {
    final rolesJson = json['roles'] as List<dynamic>? ?? [];
    final roleNames = rolesJson.map((role) {
      if (role is String) {
        return role;
      } else if (role is Map<String, dynamic>) {
        return role['name'] as String? ?? role['authority'] as String;
      }
      return '';
    }).where((role) => role.isNotEmpty).toSet();

    return UserModel(
      id: json['id'] as int? ?? 0,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      currentInstitute: json['currentInstitute'] as String?,
      country: json['country'] as String,
      gender: json['gender'] as String,
      roleNames: roleNames,
      profilePicture: json['profilePicture'] as String?,
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}