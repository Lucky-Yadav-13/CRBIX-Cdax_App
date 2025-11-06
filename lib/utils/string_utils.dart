/// String Utilities
/// Helper functions for string manipulation and formatting
class StringUtils {
  // Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
  
  // Capitalize each word
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }
  
  // Convert to camelCase
  static String toCamelCase(String text) {
    if (text.isEmpty) return text;
    final words = text.split(RegExp(r'[\s_-]+'));
    if (words.isEmpty) return text;
    
    String result = words[0].toLowerCase();
    for (int i = 1; i < words.length; i++) {
      result += capitalize(words[i]);
    }
    return result;
  }
  
  // Convert to snake_case
  static String toSnakeCase(String text) {
    if (text.isEmpty) return text;
    return text
        .replaceAll(RegExp(r'([A-Z])'), '_\$1')
        .toLowerCase()
        .replaceAll(RegExp(r'^_'), '');
  }
  
  // Convert to kebab-case
  static String toKebabCase(String text) {
    if (text.isEmpty) return text;
    return text
        .replaceAll(RegExp(r'([A-Z])'), '-\$1')
        .toLowerCase()
        .replaceAll(RegExp(r'^-'), '');
  }
  
  // Truncate string with ellipsis
  static String truncate(String text, int maxLength, {String ellipsis = '...'}) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength - ellipsis.length) + ellipsis;
  }
  
  // Remove all whitespace
  static String removeWhitespace(String text) {
    return text.replaceAll(RegExp(r'\s+'), '');
  }
  
  // Normalize whitespace (multiple spaces to single space)
  static String normalizeWhitespace(String text) {
    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
  
  // Check if string is null or empty
  static bool isNullOrEmpty(String? text) {
    return text == null || text.isEmpty;
  }
  
  // Check if string is null, empty, or whitespace
  static bool isNullOrWhitespace(String? text) {
    return text == null || text.trim().isEmpty;
  }
  
  // Get initials from name
  static String getInitials(String name, {int maxInitials = 2}) {
    if (name.isEmpty) return '';
    
    final words = name.trim().split(RegExp(r'\s+'));
    final initials = words
        .take(maxInitials)
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .where((initial) => initial.isNotEmpty)
        .join();
    
    return initials;
  }
  
  // Format phone number
  static String formatPhoneNumber(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    
    if (cleanPhone.length == 10) {
      return '(${cleanPhone.substring(0, 3)}) ${cleanPhone.substring(3, 6)}-${cleanPhone.substring(6)}';
    } else if (cleanPhone.length == 11 && cleanPhone.startsWith('1')) {
      return '+1 (${cleanPhone.substring(1, 4)}) ${cleanPhone.substring(4, 7)}-${cleanPhone.substring(7)}';
    }
    
    return phone; // Return original if can't format
  }
  
  // Mask email
  static String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    
    final username = parts[0];
    final domain = parts[1];
    
    if (username.length <= 2) {
      return '$username@$domain';
    }
    
    final maskedUsername = username[0] + '*' * (username.length - 2) + username[username.length - 1];
    return '$maskedUsername@$domain';
  }
  
  // Mask phone number
  static String maskPhoneNumber(String phone) {
    if (phone.length <= 4) return phone;
    
    final visibleDigits = 4;
    final maskedPart = '*' * (phone.length - visibleDigits);
    final visiblePart = phone.substring(phone.length - visibleDigits);
    
    return maskedPart + visiblePart;
  }
  
  // Generate random string
  static String generateRandomString(int length, {bool includeNumbers = true, bool includeSymbols = false}) {
    const letters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';
    
    String chars = letters;
    if (includeNumbers) chars += numbers;
    if (includeSymbols) chars += symbols;
    
    final random = DateTime.now().millisecondsSinceEpoch;
    String result = '';
    
    for (int i = 0; i < length; i++) {
      result += chars[(random + i) % chars.length];
    }
    
    return result;
  }
  
  // Count words
  static int countWords(String text) {
    if (text.isEmpty) return 0;
    return text.trim().split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
  }
  
  // Extract numbers from string
  static List<String> extractNumbers(String text) {
    final regex = RegExp(r'\d+');
    return regex.allMatches(text).map((match) => match.group(0)!).toList();
  }
  
  // Extract emails from string
  static List<String> extractEmails(String text) {
    final regex = RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b');
    return regex.allMatches(text).map((match) => match.group(0)!).toList();
  }
  
  // Extract URLs from string
  static List<String> extractUrls(String text) {
    final regex = RegExp(r'https?://[^\s]+');
    return regex.allMatches(text).map((match) => match.group(0)!).toList();
  }
  
  // Check if string contains only alphabets
  static bool isAlphaOnly(String text) {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(text);
  }
  
  // Check if string contains only numbers
  static bool isNumericOnly(String text) {
    return RegExp(r'^[0-9]+$').hasMatch(text);
  }
  
  // Check if string is alphanumeric
  static bool isAlphanumeric(String text) {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(text);
  }
  
  // Remove HTML tags
  static String removeHtmlTags(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '');
  }
  
  // Escape HTML
  static String escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;');
  }
  
  // Unescape HTML
  static String unescapeHtml(String html) {
    return html
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#x27;', "'");
  }
  
  // Format file size
  static String formatFileSize(int bytes) {
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    int i = 0;
    double size = bytes.toDouble();
    
    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    
    return '${size.toStringAsFixed(1)} ${suffixes[i]}';
  }
  
  // Format currency
  static String formatCurrency(double amount, {String symbol = '₹', int decimals = 2}) {
    return '$symbol${amount.toStringAsFixed(decimals)}';
  }
  
  // Format percentage
  static String formatPercentage(double value, {int decimals = 1}) {
    return '${value.toStringAsFixed(decimals)}%';
  }
  
  // Pluralize word
  static String pluralize(String word, int count) {
    if (count == 1) return word;
    
    // Simple pluralization rules
    if (word.endsWith('y')) {
      return '${word.substring(0, word.length - 1)}ies';
    } else if (word.endsWith('s') || word.endsWith('sh') || word.endsWith('ch') || word.endsWith('x') || word.endsWith('z')) {
      return '${word}es';
    } else {
      return '${word}s';
    }
  }
  
  // Create slug from string
  static String createSlug(String text) {
    return text
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'[\s_-]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }
}