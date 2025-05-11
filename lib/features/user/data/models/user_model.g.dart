// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      currentInstitute: json['currentInstitute'] as String?,
      country: json['country'] as String,
      gender: json['gender'] as String,
      roleNames:
          (json['roles'] as List<dynamic>).map((e) => e as String).toSet(),
      profilePicture: json['profilePicture'] as String?,
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'currentInstitute': instance.currentInstitute,
      'country': instance.country,
      'gender': instance.gender,
      'profilePicture': instance.profilePicture,
      'username': instance.username,
      'email': instance.email,
      'roles': instance.roleNames.toList(),
      'password': instance.password,
    };
