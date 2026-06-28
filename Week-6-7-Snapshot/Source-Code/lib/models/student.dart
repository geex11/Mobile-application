class Student {
  final String name;
  final String email;
  final String regNumber;
  final String password;

  Student({
    required this.name,
    required this.email,
    required this.regNumber,
    required this.password,
  });

  // Convert to Map to save locally
  Map<String, String> toMap() {
    return {
      'name': name,
      'email': email,
      'regNumber': regNumber,
      'password': password,
    };
  }
}