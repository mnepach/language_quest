class Validators {
  // Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  // Password validation
  static String? password(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }

    // Check for at least one letter
    if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
      return 'Password must contain at least one letter';
    }

    // Check for at least one number
    if (!RegExp(r'\d').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  // Confirm password validation
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  // Username validation
  static String? username(String? value, {int minLength = 3, int maxLength = 20}) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }

    if (value.length < minLength) {
      return 'Username must be at least $minLength characters';
    }

    if (value.length > maxLength) {
      return 'Username must be less than $maxLength characters';
    }

    // Only allow letters, numbers, and underscores
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }

    return null;
  }

  // Required field validation
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  // Minimum length validation
  static String? minLength(String? value, int min, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value.length < min) {
      return '${fieldName ?? 'This field'} must be at least $min characters';
    }

    return null;
  }

  // Maximum length validation
  static String? maxLength(String? value, int max, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value.length > max) {
      return '${fieldName ?? 'This field'} must be less than $max characters';
    }

    return null;
  }

  // Number validation
  static String? number(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (int.tryParse(value) == null) {
      return 'Please enter a valid number';
    }

    return null;
  }

  // Phone number validation (basic)
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove all non-digits
    final digits = value.replaceAll(RegExp(r'\D'), '');

    if (digits.length < 10) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  // URL validation
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }

    return null;
  }
}
