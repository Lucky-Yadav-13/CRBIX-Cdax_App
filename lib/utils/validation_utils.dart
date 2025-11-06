/// Validation Utilities
/// Common validation functions for forms and user input
class ValidationUtils {
  // Email validation
  static bool isValidEmail(String email) {
    const emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regex = RegExp(emailPattern);
    return regex.hasMatch(email);
  }
  
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!isValidEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }
  
  // Password validation
  static bool isValidPassword(String password) {
    // At least 8 characters, contains uppercase, lowercase, number, and special character
    const passwordPattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    final regex = RegExp(passwordPattern);
    return regex.hasMatch(password);
  }
  
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!isValidPassword(value)) {
      return 'Password must contain uppercase, lowercase, number and special character';
    }
    return null;
  }
  
  // Confirm password validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
  
  // Phone number validation
  static bool isValidPhoneNumber(String phone) {
    const phonePattern = r'^[+]?[1-9][\d]{0,15}$';
    final regex = RegExp(phonePattern);
    return regex.hasMatch(phone);
  }
  
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!isValidPhoneNumber(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
  
  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    if (value.length > 50) {
      return 'Name must be less than 50 characters';
    }
    return null;
  }
  
  // Username validation
  static bool isValidUsername(String username) {
    const usernamePattern = r'^[a-zA-Z0-9_]{3,20}$';
    final regex = RegExp(usernamePattern);
    return regex.hasMatch(username);
  }
  
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters long';
    }
    if (value.length > 20) {
      return 'Username must be less than 20 characters';
    }
    if (!isValidUsername(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    return null;
  }
  
  // Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
  
  // Numeric validation
  static String? validateNumeric(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    if (double.tryParse(value) == null) {
      return '$fieldName must be a valid number';
    }
    return null;
  }
  
  // URL validation
  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
  
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required';
    }
    if (!isValidUrl(value)) {
      return 'Please enter a valid URL';
    }
    return null;
  }
  
  // Date validation
  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date is required';
    }
    try {
      DateTime.parse(value);
      return null;
    } catch (e) {
      return 'Please enter a valid date';
    }
  }
  
  // Age validation
  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }
    final age = int.tryParse(value);
    if (age == null) {
      return 'Please enter a valid age';
    }
    if (age < 13) {
      return 'Must be at least 13 years old';
    }
    if (age > 120) {
      return 'Please enter a valid age';
    }
    return null;
  }
  
  // File size validation
  static String? validateFileSize(int fileSizeBytes, int maxSizeBytes) {
    if (fileSizeBytes > maxSizeBytes) {
      final maxSizeMB = (maxSizeBytes / (1024 * 1024)).toStringAsFixed(1);
      return 'File size must be less than ${maxSizeMB}MB';
    }
    return null;
  }
  
  // File type validation
  static String? validateFileType(String fileName, List<String> allowedExtensions) {
    final extension = fileName.split('.').last.toLowerCase();
    if (!allowedExtensions.contains(extension)) {
      return 'Only ${allowedExtensions.join(', ')} files are allowed';
    }
    return null;
  }
  
  // Credit card validation (Luhn algorithm)
  static bool isValidCreditCard(String cardNumber) {
    final cleanNumber = cardNumber.replaceAll(RegExp(r'\D'), '');
    if (cleanNumber.length < 13 || cleanNumber.length > 19) {
      return false;
    }
    
    int sum = 0;
    bool isEven = false;
    
    for (int i = cleanNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cleanNumber[i]);
      
      if (isEven) {
        digit *= 2;
        if (digit > 9) {
          digit = digit % 10 + digit ~/ 10;
        }
      }
      
      sum += digit;
      isEven = !isEven;
    }
    
    return sum % 10 == 0;
  }
  
  static String? validateCreditCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'Credit card number is required';
    }
    if (!isValidCreditCard(value)) {
      return 'Please enter a valid credit card number';
    }
    return null;
  }
  
  // CVV validation
  static String? validateCvv(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV is required';
    }
    if (value.length < 3 || value.length > 4) {
      return 'CVV must be 3 or 4 digits';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'CVV must contain only numbers';
    }
    return null;
  }
  
  // Expiry date validation
  static String? validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Expiry date is required';
    }
    
    final parts = value.split('/');
    if (parts.length != 2) {
      return 'Please enter date in MM/YY format';
    }
    
    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);
    
    if (month == null || year == null) {
      return 'Please enter a valid expiry date';
    }
    
    if (month < 1 || month > 12) {
      return 'Please enter a valid month (01-12)';
    }
    
    final currentYear = DateTime.now().year % 100;
    final currentMonth = DateTime.now().month;
    
    if (year < currentYear || (year == currentYear && month < currentMonth)) {
      return 'Card has expired';
    }
    
    return null;
  }
}