// Phase 3: Payment Gateway Integration - Secure Storage Service
// Created for CDAX App secure token storage (NOT for card data)

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

/// Secure storage service for non-sensitive tokens and user preferences.
/// IMPORTANT: This should NOT be used for storing PAN, CVV, or other card data.
/// Only use for customer tokens, session tokens, and similar non-card secrets.
class SecureStorageService {
  SecureStorageService._();
  
  static final SecureStorageService _instance = SecureStorageService._();
  static SecureStorageService get instance => _instance;

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      // Additional security options
      keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
    iOptions: IOSOptions(
      // Use more secure accessibility option
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Key constants for stored values
  static const String _customerTokenKey = 'customer_token';
  static const String _sessionTokenKey = 'session_token';
  static const String _userPreferencesKey = 'user_preferences';
  static const String _paymentMethodTokenKey = 'payment_method_token';

  /// Store customer authentication token
  Future<void> storeCustomerToken(String token) async {
    try {
      await _storage.write(key: _customerTokenKey, value: token);
    } catch (e) {
      debugPrint('SecureStorageService: Failed to store customer token: $e');
      rethrow;
    }
  }

  /// Retrieve customer authentication token
  Future<String?> getCustomerToken() async {
    try {
      return await _storage.read(key: _customerTokenKey);
    } catch (e) {
      debugPrint('SecureStorageService: Failed to read customer token: $e');
      return null;
    }
  }

  /// Store session token
  Future<void> storeSessionToken(String token) async {
    try {
      await _storage.write(key: _sessionTokenKey, value: token);
    } catch (e) {
      debugPrint('SecureStorageService: Failed to store session token: $e');
      rethrow;
    }
  }

  /// Retrieve session token
  Future<String?> getSessionToken() async {
    try {
      return await _storage.read(key: _sessionTokenKey);
    } catch (e) {
      debugPrint('SecureStorageService: Failed to read session token: $e');
      return null;
    }
  }

  /// Store payment method token (from gateway, NOT raw card data)
  Future<void> storePaymentMethodToken(String token) async {
    try {
      await _storage.write(key: _paymentMethodTokenKey, value: token);
    } catch (e) {
      debugPrint('SecureStorageService: Failed to store payment method token: $e');
      rethrow;
    }
  }

  /// Retrieve payment method token
  Future<String?> getPaymentMethodToken() async {
    try {
      return await _storage.read(key: _paymentMethodTokenKey);
    } catch (e) {
      debugPrint('SecureStorageService: Failed to read payment method token: $e');
      return null;
    }
  }

  /// Store user preferences as JSON string
  Future<void> storeUserPreferences(String preferencesJson) async {
    try {
      await _storage.write(key: _userPreferencesKey, value: preferencesJson);
    } catch (e) {
      debugPrint('SecureStorageService: Failed to store user preferences: $e');
      rethrow;
    }
  }

  /// Retrieve user preferences JSON string
  Future<String?> getUserPreferences() async {
    try {
      return await _storage.read(key: _userPreferencesKey);
    } catch (e) {
      debugPrint('SecureStorageService: Failed to read user preferences: $e');
      return null;
    }
  }

  /// Store arbitrary secure data (use with caution)
  Future<void> store(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      debugPrint('SecureStorageService: Failed to store data for key $key: $e');
      rethrow;
    }
  }

  /// Retrieve arbitrary secure data
  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      debugPrint('SecureStorageService: Failed to read data for key $key: $e');
      return null;
    }
  }

  /// Delete specific key
  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      debugPrint('SecureStorageService: Failed to delete key $key: $e');
      rethrow;
    }
  }

  /// Clear all stored data (use carefully)
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      debugPrint('SecureStorageService: Failed to clear all data: $e');
      rethrow;
    }
  }

  /// Check if storage contains a specific key
  Future<bool> containsKey(String key) async {
    try {
      return await _storage.containsKey(key: key);
    } catch (e) {
      debugPrint('SecureStorageService: Failed to check key $key: $e');
      return false;
    }
  }

  /// Get all keys (for debugging purposes only)
  Future<Set<String>> getAllKeys() async {
    try {
      final all = await _storage.readAll();
      return all.keys.toSet();
    } catch (e) {
      debugPrint('SecureStorageService: Failed to get all keys: $e');
      return {};
    }
  }

  /// Clear payment-related tokens only
  Future<void> clearPaymentTokens() async {
    try {
      await delete(_paymentMethodTokenKey);
    } catch (e) {
      debugPrint('SecureStorageService: Failed to clear payment tokens: $e');
      rethrow;
    }
  }

  /// Clear authentication tokens only
  Future<void> clearAuthTokens() async {
    try {
      await delete(_customerTokenKey);
      await delete(_sessionTokenKey);
    } catch (e) {
      debugPrint('SecureStorageService: Failed to clear auth tokens: $e');
      rethrow;
    }
  }
}
