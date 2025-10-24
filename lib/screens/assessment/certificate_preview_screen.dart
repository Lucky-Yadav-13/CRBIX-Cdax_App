import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import 'widgets/certificate_card.dart';

class CertificatePreviewScreen extends StatefulWidget {
  final String assessmentId;

  const CertificatePreviewScreen({
    super.key,
    required this.assessmentId,
  });

  @override
  State<CertificatePreviewScreen> createState() => _CertificatePreviewScreenState();
}

class _CertificatePreviewScreenState extends State<CertificatePreviewScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificate'),
        backgroundColor: theme.colorScheme.primaryContainer,
        foregroundColor: theme.colorScheme.onPrimaryContainer,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _shareCertificate,
            icon: const Icon(Icons.share),
            tooltip: 'Share Certificate',
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(_slideAnimation),
              child: _buildContent(theme),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Celebration header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primaryContainer,
                  theme.colorScheme.secondaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.celebration,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  'Congratulations!',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You have successfully completed the assessment and earned your certificate!',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Certificate preview
          CertificateCard(
            assessmentId: widget.assessmentId,
            userName: 'John Doe', // Replace with actual user name
            assessmentTitle: _getAssessmentTitle(widget.assessmentId),
            completionDate: DateTime.now(),
            score: 85, // Replace with actual score
          ),
          
          const SizedBox(height: 32),
          
          // Action buttons
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isDownloading ? null : _downloadCertificate,
                  icon: _isDownloading 
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.download),
                  label: Text(_isDownloading ? 'Downloading...' : 'Download Certificate'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _shareCertificate,
                  icon: const Icon(Icons.share),
                  label: const Text('Share Achievement'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () => context.go('/dashboard'),
                  icon: const Icon(Icons.home),
                  label: const Text('Go to Dashboard'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Certificate info
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Certificate Information',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Certificate ID', 'CERT-${widget.assessmentId.toUpperCase()}-${DateTime.now().millisecondsSinceEpoch}', theme),
                const SizedBox(height: 8),
                _buildInfoRow('Issue Date', _formatDate(DateTime.now()), theme),
                const SizedBox(height: 8),
                _buildInfoRow('Valid Until', 'Lifetime', theme),
                const SizedBox(height: 8),
                _buildInfoRow('Verification', 'Available Online', theme),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Footer note
          Text(
            'This certificate is digitally signed and can be verified online. Share it on LinkedIn or add it to your resume to showcase your skills!',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _downloadCertificate() async {
    setState(() => _isDownloading = true);
    
    try {
      // Simulate download process
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.download_done, color: Colors.white),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('Certificate downloaded successfully!'),
                ),
              ],
            ),
            backgroundColor: AppColors.success,
            action: SnackBarAction(
              label: 'Open',
              textColor: Colors.white,
              onPressed: () {
                // Open the downloaded certificate
                // This would typically open the file manager or PDF viewer
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download certificate: $e'),
            backgroundColor: AppColors.error,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: _downloadCertificate,
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDownloading = false);
      }
    }
  }

  void _shareCertificate() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share Your Achievement',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.work, color: AppColors.info),
              title: const Text('LinkedIn'),
              subtitle: const Text('Share on professional network'),
              onTap: () {
                Navigator.pop(context);
                _shareOnLinkedIn();
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: AppColors.success),
              title: const Text('Social Media'),
              subtitle: const Text('Share on social platforms'),
              onTap: () {
                Navigator.pop(context);
                _shareOnSocial();
              },
            ),
            ListTile(
              leading: const Icon(Icons.email, color: AppColors.warning),
              title: const Text('Email'),
              subtitle: const Text('Send via email'),
              onTap: () {
                Navigator.pop(context);
                _shareViaEmail();
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy, color: Colors.purple),
              title: const Text('Copy Link'),
              subtitle: const Text('Copy certificate link'),
              onTap: () {
                Navigator.pop(context);
                _copyCertificateLink();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _shareOnLinkedIn() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('LinkedIn sharing feature coming soon!')),
    );
  }

  void _shareOnSocial() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Social media sharing feature coming soon!')),
    );
  }

  void _shareViaEmail() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email sharing feature coming soon!')),
    );
  }

  void _copyCertificateLink() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Certificate link copied to clipboard!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  String _getAssessmentTitle(String assessmentId) {
    switch (assessmentId) {
      case 'flutter_basics':
        return 'Flutter Fundamentals';
      case 'dart_advanced':
        return 'Advanced Dart Programming';
      case 'ui_ux_design':
        return 'UI/UX Design Principles';
      case 'state_management':
        return 'State Management in Flutter';
      case 'api_integration':
        return 'API Integration & Networking';
      default:
        return 'Assessment Certificate';
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
