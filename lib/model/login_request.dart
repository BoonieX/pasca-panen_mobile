class LoginRequest {
  final String identifier; // untuk username atau email
  final String password;

  LoginRequest({
    required this.identifier,
    required this.password,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'login': identifier,
      'password': password,
    };
  }
}
