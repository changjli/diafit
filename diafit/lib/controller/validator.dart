class Validator {
  Validator();

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'this field is required';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'this field is required';
    }
    return null;
  }

  static String? foodValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'this field is required';
    }
    return null;
  }

  static String? servingValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'this field is required';
    }
    return null;
  }

  static String? passwordConfirmationValidator(String? value1, String? value2) {
    if (value1 != value2) {
      return 'mismatch';
    }
    return null;
  }
}
