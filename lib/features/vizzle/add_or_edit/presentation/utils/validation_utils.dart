class ValidationUtils {
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a title';
    }
    if (value.trim().length < 3) {
      return 'Title must be at least 3 characters';
    }
    if (value.trim().length > 100) {
      return 'Title must be less than 100 characters';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a description';
    }
    if (value.trim().length < 10) {
      return 'Description must be at least 10 characters';
    }
    if (value.trim().length > 1000) {
      return 'Description must be less than 1000 characters';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your phone number';
    }

    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length < 10) {
      return 'Phone number must be at least 10 digits';
    }
    if (digitsOnly.length > 15) {
      return 'Phone number must be less than 15 digits';
    }

    return null;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final price = double.tryParse(value.trim());
    if (price == null) {
      return 'Please enter a valid price';
    }
    if (price < 0) {
      return 'Price cannot be negative';
    }
    if (price > 999999999) {
      return 'Price is too high';
    }

    return null;
  }

  static String? validateYear(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final year = int.tryParse(value.trim());
    if (year == null) {
      return 'Please enter a valid year';
    }

    final currentYear = DateTime.now().year;
    if (year < 1900 || year > currentYear + 1) {
      return 'Please enter a valid year between 1900 and $currentYear';
    }

    return null;
  }

  static String? validateKilometers(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final km = double.tryParse(value.trim());
    if (km == null) {
      return 'Please enter valid kilometers';
    }
    if (km < 0) {
      return 'Kilometers cannot be negative';
    }
    if (km > 9999999) {
      return 'Kilometers value is too high';
    }

    return null;
  }
}
