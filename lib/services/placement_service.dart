import 'dart:math';
import '../models/job_model.dart';
import '../models/profile_model.dart';

/// Mock Placement Service that simulates Supabase operations
/// This service is designed to be easily replaceable with actual Supabase calls
class PlacementService {
  static final PlacementService _instance = PlacementService._internal();
  factory PlacementService() => _instance;
  PlacementService._internal();

  // Mock current user ID (replace with actual authentication)
  static const String _mockUserId = 'current_user_id';

  // Mock data storage
  final List<JobModel> _mockJobs = _generateMockJobs();
  final List<JobApplication> _mockApplications = <JobApplication>[];
  final List<SavedJob> _mockSavedJobs = <SavedJob>[];
  ProfileModel? _mockProfile;

  /// Check if user is eligible for placement module
  /// Simulates: SELECT * FROM user_completions WHERE user_id = ? AND course_completed = true AND assessment_passed = true
  Future<bool> checkEligibility(String userId) async {
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate network delay
    
    // Simulate occasional network error (2% chance)
    if (Random().nextInt(100) < 2) {
      throw Exception('Failed to check eligibility. Please check your internet connection.');
    }

    // Mock logic: User is eligible if they have completed at least one course and passed assessment
    // In real implementation, this would query course completions and assessment results
    return true; // For demo purposes, always return true
  }

  /// Save or update user's placement profile
  /// Simulates: INSERT INTO placement_profiles (...) ON CONFLICT (user_id) DO UPDATE SET ...
  Future<void> savePlacementProfile(ProfileModel profile) async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay
    
    // Simulate occasional save error (3% chance)
    if (Random().nextInt(100) < 3) {
      throw Exception('Failed to save profile. Please try again.');
    }

    final now = DateTime.now();
    _mockProfile = profile.copyWith(
      id: profile.id.isEmpty ? 'profile_${now.millisecondsSinceEpoch}' : profile.id,
      updatedAt: now,
      createdAt: profile.id.isEmpty ? now : profile.createdAt,
    );
  }

  /// Get user's placement profile
  /// Simulates: SELECT * FROM placement_profiles WHERE user_id = ?
  Future<ProfileModel?> getPlacementProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    
    // Simulate occasional fetch error (2% chance)
    if (Random().nextInt(100) < 2) {
      throw Exception('Failed to load profile. Please try again.');
    }

    return _mockProfile ?? ProfileModel.empty(userId);
  }

  /// Fetch jobs with optional skill matching
  /// Simulates: SELECT * FROM jobs WHERE status = 'active' ORDER BY match_score DESC
  Future<List<JobModel>> fetchJobs(String userSkills) async {
    await Future.delayed(const Duration(milliseconds: 900)); // Simulate network delay
    
    // Simulate occasional fetch error (3% chance)
    if (Random().nextInt(100) < 3) {
      throw Exception('Failed to load jobs. Please check your internet connection.');
    }

    // Simple skill matching for demo
    final skillsList = userSkills.toLowerCase().split(',').map((e) => e.trim()).toList();
    final jobs = List<JobModel>.from(_mockJobs);
    
    if (userSkills.isNotEmpty) {
      // Sort by skill match relevance
      jobs.sort((a, b) {
        int aMatches = a.techStack.fold(0, (sum, tech) => 
            sum + (skillsList.any((skill) => tech.toLowerCase().contains(skill)) ? 1 : 0));
        int bMatches = b.techStack.fold(0, (sum, tech) => 
            sum + (skillsList.any((skill) => tech.toLowerCase().contains(skill)) ? 1 : 0));
        return bMatches.compareTo(aMatches);
      });
    }

    return jobs;
  }

  /// Get best matched job for user
  /// Simulates: SELECT * FROM jobs WHERE ... ORDER BY match_score DESC LIMIT 1
  Future<JobModel?> getBestMatchedJob(String userSkills) async {
    final jobs = await fetchJobs(userSkills);
    return jobs.isNotEmpty ? jobs.first : null;
  }

  /// Apply for a job
  /// Simulates: INSERT INTO job_applications (job_id, user_id, applied_date, status, cover_letter)
  Future<void> applyForJob(String jobId, {String? coverLetter}) async {
    await Future.delayed(const Duration(milliseconds: 700)); // Simulate network delay
    
    // Simulate occasional application error (4% chance)
    if (Random().nextInt(100) < 4) {
      throw Exception('Failed to submit application. Please try again.');
    }

    // Check if already applied
    final existingApplication = _mockApplications.any(
      (app) => app.jobId == jobId && app.userId == _mockUserId,
    );
    
    if (existingApplication) {
      throw Exception('You have already applied for this job.');
    }

    final application = JobApplication(
      id: 'app_${DateTime.now().millisecondsSinceEpoch}',
      jobId: jobId,
      userId: _mockUserId,
      appliedDate: DateTime.now(),
      status: 'Applied',
      coverLetter: coverLetter,
    );

    _mockApplications.add(application);
  }

  /// Save a job to user's saved list
  /// Simulates: INSERT INTO saved_jobs (job_id, user_id, saved_date) ON CONFLICT DO NOTHING
  Future<void> saveJob(String jobId) async {
    await Future.delayed(const Duration(milliseconds: 400)); // Simulate network delay
    
    // Simulate occasional save error (2% chance)
    if (Random().nextInt(100) < 2) {
      throw Exception('Failed to save job. Please try again.');
    }

    // Check if already saved
    final alreadySaved = _mockSavedJobs.any(
      (saved) => saved.jobId == jobId && saved.userId == _mockUserId,
    );
    
    if (!alreadySaved) {
      final savedJob = SavedJob(
        id: 'saved_${DateTime.now().millisecondsSinceEpoch}',
        jobId: jobId,
        userId: _mockUserId,
        savedDate: DateTime.now(),
      );
      _mockSavedJobs.add(savedJob);
    }
  }

  /// Remove job from saved list
  /// Simulates: DELETE FROM saved_jobs WHERE job_id = ? AND user_id = ?
  Future<void> unsaveJob(String jobId) async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate network delay
    
    _mockSavedJobs.removeWhere(
      (saved) => saved.jobId == jobId && saved.userId == _mockUserId,
    );
  }

  /// Check if user has applied for a job
  /// Simulates: SELECT COUNT(*) FROM job_applications WHERE job_id = ? AND user_id = ?
  Future<bool> hasAppliedForJob(String jobId) async {
    await Future.delayed(const Duration(milliseconds: 200)); // Simulate network delay
    
    return _mockApplications.any(
      (app) => app.jobId == jobId && app.userId == _mockUserId,
    );
  }

  /// Check if job is saved by user
  /// Simulates: SELECT COUNT(*) FROM saved_jobs WHERE job_id = ? AND user_id = ?
  Future<bool> isJobSaved(String jobId) async {
    await Future.delayed(const Duration(milliseconds: 200)); // Simulate network delay
    
    return _mockSavedJobs.any(
      (saved) => saved.jobId == jobId && saved.userId == _mockUserId,
    );
  }

  /// Get user's job applications
  /// Simulates: SELECT * FROM job_applications WHERE user_id = ? ORDER BY applied_date DESC
  Future<List<JobApplication>> getUserApplications(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    
    return _mockApplications.where((app) => app.userId == userId).toList()
      ..sort((a, b) => b.appliedDate.compareTo(a.appliedDate));
  }

  /// Get user's saved jobs
  /// Simulates: SELECT * FROM saved_jobs WHERE user_id = ? ORDER BY saved_date DESC
  Future<List<SavedJob>> getUserSavedJobs(String userId) async {
    await Future.delayed(const Duration(milliseconds: 400)); // Simulate network delay
    
    return _mockSavedJobs.where((saved) => saved.userId == userId).toList()
      ..sort((a, b) => b.savedDate.compareTo(a.savedDate));
  }

  /// Generate mock job data
  static List<JobModel> _generateMockJobs() {
    final companies = [
      {'name': 'TechCorp Inc.', 'logo': ''},
      {'name': 'InnovateLab', 'logo': ''},
      {'name': 'StartupXYZ', 'logo': ''},
      {'name': 'DigitalSoft', 'logo': ''},
      {'name': 'CloudNine Systems', 'logo': ''},
      {'name': 'FutureTech Solutions', 'logo': ''},
      {'name': 'AlgoMind AI', 'logo': ''},
      {'name': 'DevCraft Studio', 'logo': ''},
    ];

    const roles = [
      {
        'title': 'Flutter Developer',
        'tech': ['Flutter', 'Dart', 'Firebase', 'REST APIs'],
        'experience': '1-3 years',
      },
      {
        'title': 'React Native Developer',
        'tech': ['React Native', 'JavaScript', 'Redux', 'TypeScript'],
        'experience': '2-4 years',
      },
      {
        'title': 'iOS Developer',
        'tech': ['Swift', 'UIKit', 'SwiftUI', 'Core Data'],
        'experience': '2-5 years',
      },
      {
        'title': 'Android Developer',
        'tech': ['Kotlin', 'Java', 'Android SDK', 'Room'],
        'experience': '1-4 years',
      },
      {
        'title': 'Full Stack Developer',
        'tech': ['React', 'Node.js', 'MongoDB', 'Express.js'],
        'experience': '2-6 years',
      },
      {
        'title': 'Frontend Developer',
        'tech': ['React', 'Vue.js', 'JavaScript', 'CSS3'],
        'experience': '1-3 years',
      },
      {
        'title': 'Backend Developer',
        'tech': ['Node.js', 'Python', 'PostgreSQL', 'Docker'],
        'experience': '2-5 years',
      },
      {
        'title': 'UI/UX Designer',
        'tech': ['Figma', 'Sketch', 'Adobe XD', 'Prototyping'],
        'experience': '1-4 years',
      },
    ];

    final locations = ['Bangalore', 'Mumbai', 'Delhi', 'Hyderabad', 'Pune', 'Chennai', 'Remote'];
    final ctcRanges = ['₹3-6 LPA', '₹5-8 LPA', '₹6-12 LPA', '₹8-15 LPA', '₹10-18 LPA'];

    final jobs = <JobModel>[];
    final random = Random(42); // Fixed seed for consistent data

    for (int i = 0; i < 20; i++) {
      final company = companies[i % companies.length];
      final role = roles[i % roles.length];
      final location = locations[random.nextInt(locations.length)];
      final ctc = ctcRanges[random.nextInt(ctcRanges.length)];
      
      jobs.add(JobModel(
        id: 'job_${i + 1}',
        companyName: company['name']!,
        companyLogo: company['logo']!,
        role: role['title']! as String,
        location: location,
        ctc: ctc,
        experience: role['experience']! as String,
        techStack: List<String>.from(role['tech']! as List),
        responsibilities: [
          'Develop and maintain ${(role['title']! as String).toLowerCase()} applications',
          'Collaborate with cross-functional teams',
          'Write clean, maintainable code',
          'Participate in code reviews and testing',
          'Stay updated with latest technologies',
        ],
        requirements: [
          'Bachelor\'s degree in Computer Science or related field',
          '${role['experience']! as String} of relevant experience',
          'Strong knowledge of ${(role['tech']! as List<String>).join(', ')}',
          'Good problem-solving skills',
          'Excellent communication skills',
        ],
        perks: [
          'Competitive salary',
          'Health insurance',
          'Flexible working hours',
          'Learning and development opportunities',
          'Team outings and events',
        ],
        isRemote: location == 'Remote',
        jobType: 'Full-time',
        postedDate: DateTime.now().subtract(Duration(days: random.nextInt(30))),
        description: 'We are looking for a talented ${role['title']! as String} to join our dynamic team at ${company['name']!}. You will be responsible for developing high-quality applications and working with cutting-edge technologies.',
      ));
    }

    return jobs;
  }
}