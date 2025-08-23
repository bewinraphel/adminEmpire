class Validators {
  static String? validateUsername(String value) {
    if (value.trim().isEmpty) {
      return 'Please enter a name';
    }
    if (!RegExp(r'^[A-Za-z\s]+$').hasMatch(value)) {
      return 'Only letters are allowed in the name';
    }
    return null;
  }

  static String? validateString(String value, String name) {
    if (value.trim().isEmpty || value == 'null') {
      return 'Please enter $name';
    }
    return null;
  }

  static String? validateEmail(String value) {
    if (value.trim().isEmpty) {
      return 'Please enter a your email';
    } else if (!RegExp(
      r'^[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]+$',
    ).hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePhone(String value) {
    if (value.trim().isEmpty) {
      return 'Please enter your phone number';
    }
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Please enter exactly 10 digits';
    }
    return null;
  }

  static String? validatePassword(String value) {
    if (value.trim().isEmpty) {
      return 'Please enter your Password';
    } else if (!RegExp(r'^(?=.*[0-9])(?=.*[!@#\$&*~]).{6,}$').hasMatch(value)) {
      return 'it contain 6 characters, one number and one special character';
    }
    return null;
  }

  static String? validateRepeatPassword(
    String? password,
    String? repeatPassword,
  ) {
    if (repeatPassword == null || repeatPassword.isEmpty)
      return 'Please confirm your password';
    if (password != repeatPassword) return 'Passwords do not match';
    return null;
  }

  static String? validatePrice(String value, String field) {
    if (value.isEmpty) return '$field cannot be empty';
    final price = double.tryParse(value);
    if (price == null || price < 0) return 'Enter a valid $field';
    return null;
  }

  static String? validateSKU(String value) {
    if (value.isEmpty) return 'SKU cannot be empty';
    if (!RegExp(r'^[A-Z0-9-]{6,12}$').hasMatch(value)) {
      return 'SKU must be 6-12 alphanumeric characters or hyphens';
    }
    return null;
  }

  static String? validateQuantity(String value) {
    if (value.isEmpty) return 'Enter quantity';
    final qty = int.tryParse(value);
    if (qty == null || qty < 0) return 'Enter a valid non-negative number';
    return null;
  }

  static String? validateWeight(String value) {
    if (value.isEmpty) return 'Weight cannot be empty';
    final weight = double.tryParse(value);
    if (weight == null || weight < 0) return 'Enter a valid weight';
    return null;
  }

  static String? validateDimension(String value, String field) {
    if (value.isEmpty) return '$field cannot be empty';
    final dim = double.tryParse(value);
    if (dim == null || dim < 0) return 'Enter a valid $field';
    return null;
  }

  static String? validateTaxRate(String value) {
    if (value.isEmpty) return 'Tax rate cannot be empty';
    final tax = double.tryParse(value);
    if (tax == null || tax < 0 || tax > 100)
      return 'Enter a valid tax rate (0-100)';
    return null;
  }
}
