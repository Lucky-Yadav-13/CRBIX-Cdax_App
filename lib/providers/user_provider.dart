/// User Provider
/// Manages user state and user-related operations
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../core/api_response.dart';

class UserProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;
  
  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;
  
  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  // Set error
  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }
  
  // Set current user
  void setCurrentUser(UserModel? user) {
    _currentUser = user;
    _error = null;
    notifyListeners();
  }
  
  // Load current user
  Future<void> loadCurrentUser() async {
    _setLoading(true);
    _setError(null);
    
    final response = await _apiService.getCurrentUser();
    
    if (response.isSuccess && response.data != null) {
      _currentUser = response.data;
    } else {
      _setError(response.getErrorMessage());
    }
    
    _setLoading(false);
  }
  
  // Update user profile
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    _setLoading(true);
    _setError(null);
    
    final response = await _apiService.updateProfile(data);
    
    if (response.isSuccess && response.data != null) {
      _currentUser = response.data;
      _setLoading(false);
      return true;
    } else {
      _setError(response.getErrorMessage());
      _setLoading(false);
      return false;
    }
  }
  
  // Logout user
  void logout() {
    _currentUser = null;
    _error = null;
    notifyListeners();
  }
  
  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}