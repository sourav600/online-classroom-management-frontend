class AuthResponse {
  final String jwt;
  final String refreshToken;

  AuthResponse({
    required this.jwt,
    required this.refreshToken,
  });
}