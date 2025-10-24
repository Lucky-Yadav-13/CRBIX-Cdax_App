import 'package:flutter/foundation.dart';
import '../models/job_model.dart';
import '../models/profile_model.dart';
import '../services/placement_service.dart';

class PlacementProvider extends ChangeNotifier {
  final PlacementService _service = PlacementService();

  // State variables
  bool _isEligible = false;
  bool _isLoading = false;
  String? _error;
  ProfileModel? _profile;
  List<JobModel> _jobs = [];
  JobModel? _bestMatchedJob;
  String _searchQuery = '';
  Set<String> _appliedJobs = {};
  Set<String> _savedJobs = {};

  // Getters
  bool get isEligible => _isEligible;
  bool get isLoading => _isLoading;
  String? get error => _error;
  ProfileModel? get profile => _profile;
  List<JobModel> get jobs => List.unmodifiable(_jobs);
  JobModel? get bestMatchedJob => _bestMatchedJob;
  String get searchQuery => _searchQuery;
  bool get hasProfile => _profile != null && _profile!.isComplete;

  // Check eligibility and initialize data
  Future<void> initializePlacement() async {
    _setLoading(true);
    _clearError();

    try {
      // Check eligibility
      _isEligible = await _service.checkEligibility('current_user');
      
      if (_isEligible) {
        // Load existing profile if available
        _profile = await _service.getPlacementProfile('current_user');
        
        // Load jobs and best match if profile exists
        if (_profile != null && _profile!.isComplete) {
          await _loadJobs();
          await _loadBestMatch();
          await _loadUserJobStatus();
        }
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Save placement profile
  Future<bool> saveProfile(ProfileModel profile) async {
    _setLoading(true);
    _clearError();

    try {
      await _service.savePlacementProfile(profile);
      _profile = profile;
      
      // After saving profile, load jobs
      await _loadJobs();
      await _loadBestMatch();
      await _loadUserJobStatus();
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Load jobs with search/filter
  Future<void> loadJobs({String? searchQuery}) async {
    if (searchQuery != null) {
      _searchQuery = searchQuery;
    }

    _setLoading(true);
    _clearError();

    try {
      final userSkills = _profile?.skills.join(',') ?? '';
      _jobs = await _service.fetchJobs(userSkills);
      
      // Apply search filter if provided
      if (_searchQuery.isNotEmpty) {
        _jobs = _jobs.where((job) {
          final query = _searchQuery.toLowerCase();
          return job.role.toLowerCase().contains(query) ||
                 job.companyName.toLowerCase().contains(query) ||
                 job.techStack.any((tech) => tech.toLowerCase().contains(query));
        }).toList();
      }
      
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Load best matched job
  Future<void> _loadBestMatch() async {
    try {
      final userSkills = _profile?.skills.join(',') ?? '';
      _bestMatchedJob = await _service.getBestMatchedJob(userSkills);
    } catch (e) {
      debugPrint('Error loading best match: $e');
    }
  }

  // Load jobs without changing loading state (internal)
  Future<void> _loadJobs() async {
    try {
      final userSkills = _profile?.skills.join(',') ?? '';
      _jobs = await _service.fetchJobs(userSkills);
    } catch (e) {
      debugPrint('Error loading jobs: $e');
    }
  }

  // Load user job status (applied/saved)
  Future<void> _loadUserJobStatus() async {
    try {
      // Load applied jobs
      final applications = await _service.getUserApplications('current_user');
      _appliedJobs = applications.map((app) => app.jobId).toSet();
      
      // Load saved jobs
      final savedJobs = await _service.getUserSavedJobs('current_user');
      _savedJobs = savedJobs.map((saved) => saved.jobId).toSet();
    } catch (e) {
      debugPrint('Error loading user job status: $e');
    }
  }

  // Apply for a job
  Future<bool> applyForJob(String jobId, {String? coverLetter}) async {
    _clearError();

    try {
      await _service.applyForJob(jobId, coverLetter: coverLetter);
      _appliedJobs.add(jobId);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Save a job
  Future<bool> saveJob(String jobId) async {
    _clearError();

    try {
      if (_savedJobs.contains(jobId)) {
        await _service.unsaveJob(jobId);
        _savedJobs.remove(jobId);
      } else {
        await _service.saveJob(jobId);
        _savedJobs.add(jobId);
      }
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Check if user has applied for a job
  bool hasAppliedForJob(String jobId) {
    return _appliedJobs.contains(jobId);
  }

  // Check if job is saved by user
  bool isJobSaved(String jobId) {
    return _savedJobs.contains(jobId);
  }

  // Filter jobs by search query
  void searchJobs(String query) {
    _searchQuery = query;
    if (_jobs.isEmpty) return;

    loadJobs(searchQuery: query);
  }

  // Clear search and reload all jobs
  void clearSearch() {
    _searchQuery = '';
    loadJobs();
  }

  // Reset provider state
  void reset() {
    _isEligible = false;
    _isLoading = false;
    _error = null;
    _profile = null;
    _jobs.clear();
    _bestMatchedJob = null;
    _searchQuery = '';
    _appliedJobs.clear();
    _savedJobs.clear();
    notifyListeners();
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    // Clean up any resources if needed
    super.dispose();
  }
}
