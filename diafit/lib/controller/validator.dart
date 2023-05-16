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
}
