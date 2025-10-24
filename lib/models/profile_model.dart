import 'package:flutter/foundation.dart';

@immutable
class ProfileModel {
  final String id;
  final String userId;
  final String jobRole;
  final List<String> skills;
  final int experienceYears;
  final bool openToWork;
  final bool remotePreference;
  final String? bio;
  final String? resume;
  final String? portfolioUrl;
  final String? linkedinUrl;
  final String? githubUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProfileModel({
    required this.id,
    required this.userId,
    required this.jobRole,
    required this.skills,
    required this.experienceYears,
    required this.openToWork,
    required this.remotePreference,
    this.bio,
    this.resume,
    this.portfolioUrl,
    this.linkedinUrl,
    this.githubUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      jobRole: json['job_role'] as String,
      skills: List<String>.from(json['skills'] as List),
      experienceYears: json['experience_years'] as int,
      openToWork: json['open_to_work'] as bool,
      remotePreference: json['remote_preference'] as bool,
      bio: json['bio'] as String?,
      resume: json['resume'] as String?,
      portfolioUrl: json['portfolio_url'] as String?,
      linkedinUrl: json['linkedin_url'] as String?,
      githubUrl: json['github_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'job_role': jobRole,
      'skills': skills,
      'experience_years': experienceYears,
      'open_to_work': openToWork,
      'remote_preference': remotePreference,
      'bio': bio,
      'resume': resume,
      'portfolio_url': portfolioUrl,
      'linkedin_url': linkedinUrl,
      'github_url': githubUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ProfileModel copyWith({
    String? id,
    String? userId,
    String? jobRole,
    List<String>? skills,
    int? experienceYears,
    bool? openToWork,
    bool? remotePreference,
    String? bio,
    String? resume,
    String? portfolioUrl,
    String? linkedinUrl,
    String? githubUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      jobRole: jobRole ?? this.jobRole,
      skills: skills ?? this.skills,
      experienceYears: experienceYears ?? this.experienceYears,
      openToWork: openToWork ?? this.openToWork,
      remotePreference: remotePreference ?? this.remotePreference,
      bio: bio ?? this.bio,
      resume: resume ?? this.resume,
      portfolioUrl: portfolioUrl ?? this.portfolioUrl,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      githubUrl: githubUrl ?? this.githubUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Create empty profile for new users
  factory ProfileModel.empty(String userId) {
    final now = DateTime.now();
    return ProfileModel(
      id: '',
      userId: userId,
      jobRole: '',
      skills: [],
      experienceYears: 0,
      openToWork: false,
      remotePreference: false,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Validate profile completeness for placement eligibility
  bool get isComplete {
    return jobRole.isNotEmpty &&
        skills.isNotEmpty &&
        experienceYears >= 0;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProfileModel &&
        other.id == id &&
        other.userId == userId;
  }

  @override
  int get hashCode => Object.hash(id, userId);

  @override
  String toString() => 'ProfileModel(id: $id, userId: $userId, jobRole: $jobRole)';
}

@immutable
class SavedJob {
  final String id;
  final String jobId;
  final String userId;
  final DateTime savedDate;

  const SavedJob({
    required this.id,
    required this.jobId,
    required this.userId,
    required this.savedDate,
  });

  factory SavedJob.fromJson(Map<String, dynamic> json) {
    return SavedJob(
      id: json['id'] as String,
      jobId: json['job_id'] as String,
      userId: json['user_id'] as String,
      savedDate: DateTime.parse(json['saved_date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_id': jobId,
      'user_id': userId,
      'saved_date': savedDate.toIso8601String(),
    };
  }
}
