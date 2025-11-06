/// Environment Configuration
/// Manages different environments (development, staging, production)
enum Environment { development, staging, production }

class EnvironmentConfig {
  static Environment _currentEnvironment = Environment.development;
  
  static Environment get currentEnvironment => _currentEnvironment;
  
  static void setEnvironment(Environment env) {
    _currentEnvironment = env;
  }
  
  // Development Configuration
  static const Map<String, dynamic> _developmentConfig = {
    'apiBaseUrl': 'http://localhost:8080',
    'enableLogging': true,
    'enableDebugMode': true,
    'socketUrl': 'ws://localhost:8080/ws',
    'enableAnalytics': false,
  };
  
  // Staging Configuration
  static const Map<String, dynamic> _stagingConfig = {
    'apiBaseUrl': 'https://staging-api.cdax.com',
    'enableLogging': true,
    'enableDebugMode': false,
    'socketUrl': 'wss://staging-api.cdax.com/ws',
    'enableAnalytics': true,
  };
  
  // Production Configuration
  static const Map<String, dynamic> _productionConfig = {
    'apiBaseUrl': 'https://api.cdax.com',
    'enableLogging': false,
    'enableDebugMode': false,
    'socketUrl': 'wss://api.cdax.com/ws',
    'enableAnalytics': true,
  };
  
  // Get current configuration
  static Map<String, dynamic> get config {
    switch (_currentEnvironment) {
      case Environment.development:
        return _developmentConfig;
      case Environment.staging:
        return _stagingConfig;
      case Environment.production:
        return _productionConfig;
    }
  }
  
  // Convenient getters
  static String get apiBaseUrl => config['apiBaseUrl'];
  static bool get enableLogging => config['enableLogging'];
  static bool get enableDebugMode => config['enableDebugMode'];
  static String get socketUrl => config['socketUrl'];
  static bool get enableAnalytics => config['enableAnalytics'];
  
  // Initialize environment based on build mode
  static void initializeEnvironment() {
    const bool isProduction = bool.fromEnvironment('dart.vm.product');
    const bool isStaging = bool.fromEnvironment('STAGING');
    
    if (isProduction) {
      _currentEnvironment = Environment.production;
    } else if (isStaging) {
      _currentEnvironment = Environment.staging;
    } else {
      _currentEnvironment = Environment.development;
    }
  }
}