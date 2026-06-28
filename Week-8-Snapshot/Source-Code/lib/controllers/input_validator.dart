class InputValidator {
  String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) return 'Username is required';
    if (value.trim().length < 3) return 'Username too short (min 3 characters)';
    if (value.contains(' ')) return 'Username cannot contain spaces';
    return null;
  }

  String? validateMessage(String? value) {
    if (value == null || value.trim().isEmpty) return 'Message cannot be empty';
    if (value.trim().length > 200) return 'Message too long (max 200 characters)';
    return null;
  }

  String getValidationResult(String username) {
    final error = validateUsername(username);
    return error ?? 'Valid username';
  }
}
