// ASSUMPTION: Minimal profile state; integrate with backend later.

import 'package:flutter/foundation.dart';

@immutable
class UserProfile {
  final String name;
  final String email;
  final String phone;
  final int enrolledCoursesCount;
  final bool subscribed;

  const UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.enrolledCoursesCount,
    required this.subscribed,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    int? enrolledCoursesCount,
    bool? subscribed,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      enrolledCoursesCount: enrolledCoursesCount ?? this.enrolledCoursesCount,
      subscribed: subscribed ?? this.subscribed,
    );
  }
}

class ProfileProvider extends ChangeNotifier {
  UserProfile _profile = const UserProfile(
    name: 'Jane Doe',
    email: 'jane@example.com',
    phone: '+1 555 0100',
    enrolledCoursesCount: 2,
    subscribed: true,
  );

  bool _isLoading = false;

  UserProfile get profile => _profile;
  bool get isLoading => _isLoading;

  Future<void> updateProfile(UserProfile updated) async {
    _isLoading = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 400));
    
    _profile = updated;
    _isLoading = false;
    notifyListeners();
  }
}


