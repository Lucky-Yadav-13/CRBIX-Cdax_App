import 'package:flutter/foundation.dart';

@immutable
class JobModel {
  final String id;
  final String companyName;
  final String companyLogo;
  final String role;
  final String location;
  final String ctc;
  final String experience;
  final List<String> techStack;
  final List<String> responsibilities;
  final List<String> requirements;
  final List<String> perks;
  final bool isRemote;
  final String jobType; // Full-time, Part-time, Contract
  final DateTime postedDate;
  final String description;

  const JobModel({
    required this.id,
    required this.companyName,
    required this.companyLogo,
    required this.role,
    required this.location,
    required this.ctc,
    required this.experience,
    required this.techStack,
    required this.responsibilities,
    required this.requirements,
    required this.perks,
    this.isRemote = false,
    required this.jobType,
    required this.postedDate,
    required this.description,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] as String,
      companyName: json['company_name'] as String,
      companyLogo: json['company_logo'] as String,
      role: json['role'] as String,
      location: json['location'] as String,
      ctc: json['ctc'] as String,
      experience: json['experience'] as String,
      techStack: List<String>.from(json['tech_stack'] as List),
      responsibilities: List<String>.from(json['responsibilities'] as List),
      requirements: List<String>.from(json['requirements'] as List),
      perks: List<String>.from(json['perks'] as List),
      isRemote: json['is_remote'] as bool? ?? false,
      jobType: json['job_type'] as String,
      postedDate: DateTime.parse(json['posted_date'] as String),
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_name': companyName,
      'company_logo': companyLogo,
      'role': role,
      'location': location,
      'ctc': ctc,
      'experience': experience,
      'tech_stack': techStack,
      'responsibilities': responsibilities,
      'requirements': requirements,
      'perks': perks,
      'is_remote': isRemote,
      'job_type': jobType,
      'posted_date': postedDate.toIso8601String(),
      'description': description,
    };
  }

  JobModel copyWith({
    String? id,
    String? companyName,
    String? companyLogo,
    String? role,
    String? location,
    String? ctc,
    String? experience,
    List<String>? techStack,
    List<String>? responsibilities,
    List<String>? requirements,
    List<String>? perks,
    bool? isRemote,
    String? jobType,
    DateTime? postedDate,
    String? description,
  }) {
    return JobModel(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      companyLogo: companyLogo ?? this.companyLogo,
      role: role ?? this.role,
      location: location ?? this.location,
      ctc: ctc ?? this.ctc,
      experience: experience ?? this.experience,
      techStack: techStack ?? this.techStack,
      responsibilities: responsibilities ?? this.responsibilities,
      requirements: requirements ?? this.requirements,
      perks: perks ?? this.perks,
      isRemote: isRemote ?? this.isRemote,
      jobType: jobType ?? this.jobType,
      postedDate: postedDate ?? this.postedDate,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JobModel &&
        other.id == id &&
        other.companyName == companyName &&
        other.role == role;
  }

  @override
  int get hashCode => Object.hash(id, companyName, role);

  @override
  String toString() => 'JobModel(id: $id, companyName: $companyName, role: $role)';
}

@immutable
class JobApplication {
  final String id;
  final String jobId;
  final String userId;
  final DateTime appliedDate;
  final String status; // Applied, Reviewed, Interview, Rejected, Hired
  final String? coverLetter;
  final Map<String, dynamic>? additionalInfo;

  const JobApplication({
    required this.id,
    required this.jobId,
    required this.userId,
    required this.appliedDate,
    required this.status,
    this.coverLetter,
    this.additionalInfo,
  });

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      id: json['id'] as String,
      jobId: json['job_id'] as String,
      userId: json['user_id'] as String,
      appliedDate: DateTime.parse(json['applied_date'] as String),
      status: json['status'] as String,
      coverLetter: json['cover_letter'] as String?,
      additionalInfo: json['additional_info'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_id': jobId,
      'user_id': userId,
      'applied_date': appliedDate.toIso8601String(),
      'status': status,
      'cover_letter': coverLetter,
      'additional_info': additionalInfo,
    };
  }
}
