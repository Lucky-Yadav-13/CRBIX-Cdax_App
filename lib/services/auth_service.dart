/// Authentication Service
/// Handles user authentication with Spring Boot backend
import '../constants/api_endpoints.dart';
import 'http_service.dart';
import 'storage_service.dart';

class AuthService {
  final HttpService _httpService = HttpService();
  final StorageService _storageService = StorageService();
  
  // Login user
  Future<ApiResponse<AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _httpService.post<AuthResponse>(
        ApiEndpoints.login,
        (data) => AuthResponse.fromJson(data),
        body: {
          'email': email,
          'password': password,
        },
      );
      
      if (response.isSuccess && response.data != null) {
        final authResponse = response.data!;
        
        // Store tokens and user data
        await _storageService.setString('auth_token', authResponse.token);
        if (authResponse.refreshToken != null) {
          await _storageService.setString('refresh_token', authResponse.refreshToken!);
        }
        await _storageService.setString('user_data', authResponse.user.toJson().toString());
        
        // Set token in HTTP service
        _httpService.setAuthToken(authResponse.token);
      }
      
      return response;
    } catch (e) {
      return ApiResponse.error('Login failed: ${e.toString()}');
    }
  }
  
  // Register user
  Future<ApiResponse<AuthResponse>> register({
    required String fullName,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    try {
      final response = await _httpService.post<AuthResponse>(
        ApiEndpoints.register,
        (data) => AuthResponse.fromJson(data),
        body: {
          'fullName': fullName,
          'email': email,
          'password': password,
          if (phoneNumber != null) 'phoneNumber': phoneNumber,
        },
      );
      
      if (response.isSuccess && response.data != null) {
        final authResponse = response.data!;
        
        // Store tokens and user data
        await _storageService.setString('auth_token', authResponse.token);
        if (authResponse.refreshToken != null) {
          await _storageService.setString('refresh_token', authResponse.refreshToken!);
        }
        await _storageService.setString('user_data', authResponse.user.toJson().toString());
        
        // Set token in HTTP service
        _httpService.setAuthToken(authResponse.token);
      }
      
      return response;
    } catch (e) {
      return ApiResponse.error('Registration failed: ${e.toString()}');
    }
  }
  
  // Logout user
  Future<ApiResponse<Map<String, dynamic>>> logout() async {
    try {
      final response = await _httpService.post<Map<String, dynamic>>(
        ApiEndpoints.logout,
        (data) => data as Map<String, dynamic>,
      );
      
      // Clear local storage regardless of API response
      await _clearLocalData();
      
      return response;
    } catch (e) {
      // Clear local data even if API call fails
      await _clearLocalData();
      return ApiResponse.error('Logout failed: ${e.toString()}');
    }
  }
  
  // Refresh token
  Future<ApiResponse<AuthResponse>> refreshToken() async {
    try {
      final refreshToken = _storageService.getString('refresh_token');
      if (refreshToken == null) {
        return ApiResponse.error('No refresh token found');
      }
      
      final response = await _httpService.post<AuthResponse>(
        ApiEndpoints.refreshToken,
        (data) => AuthResponse.fromJson(data),
        body: {
          'refreshToken': refreshToken,
        },
      );
      
      if (response.isSuccess && response.data != null) {
        final authResponse = response.data!;
        
        // Update stored tokens
        await _storageService.setString('auth_token', authResponse.token);
        if (authResponse.refreshToken != null) {
          await _storageService.setString('refresh_token', authResponse.refreshToken!);
        }
        
        // Update token in HTTP service
        _httpService.setAuthToken(authResponse.token);
      }
      
      return response;
    } catch (e) {
      return ApiResponse.error('Token refresh failed: ${e.toString()}');
    }
  }
  
  // Forgot password
  Future<ApiResponse<Map<String, dynamic>>> forgotPassword({
    required String email,
  }) async {
    try {
      return await _httpService.post<Map<String, dynamic>>(
        ApiEndpoints.forgotPassword,
        (data) => data as Map<String, dynamic>,
        body: {
          'email': email,
        },
      );
    } catch (e) {
      return ApiResponse.error('Forgot password failed: ${e.toString()}');
    }
  }
  
  // Reset password
  Future<ApiResponse<Map<String, dynamic>>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      return await _httpService.post<Map<String, dynamic>>(
        ApiEndpoints.resetPassword,
        (data) => data as Map<String, dynamic>,
        body: {
          'token': token,
          'newPassword': newPassword,
        },
      );
    } catch (e) {
      return ApiResponse.error('Password reset failed: ${e.toString()}');
    }
  }
  
  // Change password
  Future<ApiResponse<Map<String, dynamic>>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      return await _httpService.post<Map<String, dynamic>>(
        ApiEndpoints.changePassword,
        (data) => data as Map<String, dynamic>,
        body: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
    } catch (e) {
      return ApiResponse.error('Password change failed: ${e.toString()}');
    }
  }
  
  // Verify email
  Future<ApiResponse<Map<String, dynamic>>> verifyEmail({
    required String token,
  }) async {
    try {
      return await _httpService.post<Map<String, dynamic>>(
        ApiEndpoints.verifyEmail,
        (data) => data as Map<String, dynamic>,
        body: {
          'token': token,
        },
      );
    } catch (e) {
      return ApiResponse.error('Email verification failed: ${e.toString()}');
    }
  }
  
  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = _storageService.getString('auth_token');
    return token != null && token.isNotEmpty;
  }
  
  // Get current user from storage
  Future<User?> getCurrentUser() async {
    try {
      final userDataString = _storageService.getString('user_data');
      if (userDataString != null) {
        // Note: This is a simplified version. In real implementation,
        // you'd parse the JSON string back to User object
        // return User.fromJson(jsonDecode(userDataString));
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  // Initialize auth service (call this at app startup)
  Future<void> initialize() async {
    final token = _storageService.getString('auth_token');
    if (token != null) {
      _httpService.setAuthToken(token);
    }
  }
  
  // Clear local authentication data
  Future<void> _clearLocalData() async {
    await _storageService.remove('auth_token');
    await _storageService.remove('refresh_token');
    await _storageService.remove('user_data');
    _httpService.clearAuthToken();
  }
}

// Placeholder classes - these will be replaced with your actual models
class AuthResponse {
  final String token;
  final String? refreshToken;
  final User user;
  
  AuthResponse({
    required this.token,
    this.refreshToken,
    required this.user,
  });
  
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? '',
      refreshToken: json['refreshToken'],
      user: User.fromJson(json['user'] ?? {}),
    );
  }
}

class User {
  final String id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  
  User({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }
}