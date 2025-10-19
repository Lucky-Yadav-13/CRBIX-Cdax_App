import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/placement_provider.dart';
import '../../models/profile_model.dart';
import '../../core/theme/app_colors.dart';

class PlacementProfileScreen extends StatefulWidget {
  const PlacementProfileScreen({super.key});

  @override
  State<PlacementProfileScreen> createState() => _PlacementProfileScreenState();
}

class _PlacementProfileScreenState extends State<PlacementProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _jobRoleController = TextEditingController();
  final _skillsController = TextEditingController();
  final _experienceController = TextEditingController();
  
  bool _openToWork = true;
  bool _remotePreference = false;
  bool _isSubmitting = false;
  
  final List<String> _skillChips = [];

  @override
  void initState() {
    super.initState();
    _loadExistingProfile();
  }

  void _loadExistingProfile() {
    final placementProvider = Provider.of<PlacementProvider>(context, listen: false);
    final profile = placementProvider.profile;
    
    if (profile != null) {
      _jobRoleController.text = profile.jobRole;
      _skillChips.addAll(profile.skills);
      _skillsController.text = '';
      _experienceController.text = profile.experienceYears.toString();
      _openToWork = profile.openToWork;
      _remotePreference = profile.remotePreference;
    }
  }

  @override
  void dispose() {
    _jobRoleController.dispose();
    _skillsController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  void _addSkill(String skill) {
    final trimmedSkill = skill.trim();
    if (trimmedSkill.isNotEmpty && !_skillChips.contains(trimmedSkill)) {
      setState(() {
        _skillChips.add(trimmedSkill);
      });
    }
    _skillsController.clear();
  }

  void _removeSkill(String skill) {
    setState(() {
      _skillChips.remove(skill);
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_skillChips.isEmpty) {
      _showErrorSnackBar('Please add at least one skill');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Hide keyboard
    FocusScope.of(context).unfocus();

    try {
      final placementProvider = Provider.of<PlacementProvider>(context, listen: false);
      final existingProfile = placementProvider.profile;
      
      final profile = ProfileModel(
        id: existingProfile?.id ?? '',
        userId: 'current_user', // Replace with actual user ID
        jobRole: _jobRoleController.text.trim(),
        skills: List<String>.from(_skillChips),
        experienceYears: int.parse(_experienceController.text.trim()),
        openToWork: _openToWork,
        remotePreference: _remotePreference,
        bio: existingProfile?.bio,
        resume: existingProfile?.resume,
        portfolioUrl: existingProfile?.portfolioUrl,
        linkedinUrl: existingProfile?.linkedinUrl,
        githubUrl: existingProfile?.githubUrl,
        createdAt: existingProfile?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final success = await placementProvider.saveProfile(profile);
      
      if (success && mounted) {
        _showSuccessSnackBar('Profile saved successfully!');
        // Navigate to job listings
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          context.pushReplacement('/dashboard/placement/jobs');
        }
      } else if (mounted) {
        _showErrorSnackBar(placementProvider.error ?? 'Failed to save profile');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('An error occurred. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Your Profile'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            // Header
            Text(
              'Tell us about yourself',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete your profile to get matched with the best job opportunities.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Job Role Field
            TextFormField(
              controller: _jobRoleController,
              decoration: InputDecoration(
                labelText: 'Job Role *',
                hintText: 'e.g., Flutter Developer, UI/UX Designer',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.work_outline),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Job role is required';
                }
                return null;
              },
              textCapitalization: TextCapitalization.words,
            ),
            
            const SizedBox(height: 24),
            
            // Skills Field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _skillsController,
                  decoration: InputDecoration(
                    labelText: 'Skills *',
                    hintText: 'Enter a skill and press Enter',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.psychology_outlined),
                    suffixIcon: IconButton(
                      onPressed: () => _addSkill(_skillsController.text),
                      icon: const Icon(Icons.add),
                    ),
                  ),
                  onFieldSubmitted: _addSkill,
                  textCapitalization: TextCapitalization.words,
                ),
                
                const SizedBox(height: 12),
                
                // Skills Chips
                if (_skillChips.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _skillChips.map((skill) {
                      return Chip(
                        label: Text(skill),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () => _removeSkill(skill),
                        backgroundColor: theme.colorScheme.primaryContainer,
                        labelStyle: TextStyle(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      );
                    }).toList(),
                  ),
                
                if (_skillChips.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.colorScheme.outline),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'No skills added yet. Add skills to help us match you with relevant jobs.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Experience Field
            TextFormField(
              controller: _experienceController,
              decoration: InputDecoration(
                labelText: 'Experience (Years) *',
                hintText: 'e.g., 2',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.timeline_outlined),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2),
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Experience is required';
                }
                final experience = int.tryParse(value.trim());
                if (experience == null || experience < 0) {
                  return 'Please enter a valid number';
                }
                if (experience > 50) {
                  return 'Experience cannot exceed 50 years';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 32),
            
            // Toggles Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preferences',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Open to Work Toggle
                  SwitchListTile(
                    title: const Text('Open to Work'),
                    subtitle: const Text('Show that you\'re actively looking for opportunities'),
                    value: _openToWork,
                    onChanged: (value) {
                      setState(() {
                        _openToWork = value;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                  
                  // Remote Preference Toggle
                  SwitchListTile(
                    title: const Text('Remote Work'),
                    subtitle: const Text('Prefer remote or work-from-home opportunities'),
                    value: _remotePreference,
                    onChanged: (value) {
                      setState(() {
                        _remotePreference = value;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isSubmitting ? null : _saveProfile,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Save Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Skip Button (if updating existing profile)
            Consumer<PlacementProvider>(
              builder: (context, placementProvider, child) {
                if (placementProvider.profile != null) {
                  return SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.pushReplacement('/dashboard/placement/jobs'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Skip for Now',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}