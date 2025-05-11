import './role.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable{
  final int id;
  final String firstName;
  final String lastName;
  final String? currentInstitute;
  final String country;
  final String gender;
  final Set<Role> roles;
  final String? profilePicture;
  final String username;
  final String email;
  final String password;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.currentInstitute,
    required this.country,
    required this.gender,
    required this.roles,
    this.profilePicture,
    required this.username,
    required this.email,
    required this.password
  });

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        currentInstitute,
        country,
        gender,
        roles,
        profilePicture,
        username,
        email,
        password
      ];
}