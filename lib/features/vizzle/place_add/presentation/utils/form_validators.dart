class FormValidators {
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    final phoneRegex = RegExp(r'^[0-9]{10}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid 10-digit phone number';
    }

    return null;
  }

  static String? price(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Price is optional
    }

    final price = double.tryParse(value.trim());
    if (price == null || price < 0) {
      return 'Please enter a valid price';
    }

    return null;
  }

  static String? minLength(String? value, int minLength) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    if (value.trim().length < minLength) {
      return 'Must be at least $minLength characters long';
    }

    return null;
  }

  static String? maxLength(String? value, int maxLength) {
    if (value != null && value.trim().length > maxLength) {
      return 'Must be no more than $maxLength characters long';
    }

    return null;
  }

  static String? Function(String? value) combine(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) {
          return result;
        }
      }
      return null;
    };
  }
}
