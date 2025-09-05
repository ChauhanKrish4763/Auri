import 'package:auri_app/features/services/pictogram_assets_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../components/download_progress_indicator.dart';
import '../services/gallery_providers.dart';
import 'wait_screen.dart';
import 'categories_page.dart';

class DownloadAssetsPage extends ConsumerStatefulWidget {
  const DownloadAssetsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<DownloadAssetsPage> createState() => _DownloadAssetsPageState();
}

class _DownloadAssetsPageState extends ConsumerState<DownloadAssetsPage>
    with TickerProviderStateMixin {
  bool _showDownloadUI = false;
  StreamSubscription? _progressSubscription;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  
  // Store actual progress data - only show UI when we have real data
  DownloadProgress? _currentProgress;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // Slide up animation for download UI
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start from bottom
      end: Offset.zero, // End at original position
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    // Fade in animation for download UI
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    
    _handleInitialCheck();
  }

  Future<void> _handleInitialCheck() async {
    // Show WaitScreen for 2 seconds
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;

    final downloader = ref.read(pictogramAssetsDownloaderProvider);
    final isReady = await downloader.isDatasetExtracted();

    if (isReady) {
      // Assets already downloaded - navigate with slide LEFT animation
      _navigateToCategories();
    } else {
      // Assets not ready - start download but DON'T show UI until we have progress data
      _startDownload();
    }
  }

  void _navigateToCategories() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const CategoriesPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // SLIDE LEFT - page slides from right to left
          const begin = Offset(1.0, 0.0); // Start from RIGHT
          const end = Offset.zero; // End at center (slides LEFT)
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  void _startDownload() {
    final downloader = ref.read(pictogramAssetsDownloaderProvider);
    
    // Listen to progress stream for completion
    _progressSubscription = downloader.progressStream.listen((progress) {
      setState(() {
        _currentProgress = progress;
      });
      
      // Only show download UI when we have actual progress data
      if (!_showDownloadUI && _currentProgress != null) {
        setState(() {
          _showDownloadUI = true;
        });
        _animationController.forward();
      }
      
      if (progress.isComplete && mounted) {
        print('Download complete! Navigating to categories...');
        // Navigate to CategoriesPage after completion with slide LEFT animation
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            _navigateToCategories();
          }
        });
      }
    });

    // Start the download
    downloader.downloadPictogramAssets().catchError((error) {
      print('Download error: $error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download failed: $error'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () {
                // Reset state for retry
                setState(() {
                  _showDownloadUI = false;
                  _currentProgress = null;
                });
                _animationController.reset();
                _startDownload();
              },
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _progressSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Always show WaitScreen as background
          const WaitScreen(),
          
          // ONLY show download progress when we have actual progress data
          if (_showDownloadUI && _currentProgress != null)
            Positioned(
              left: 32,
              right: 32,
              bottom: 60,
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: DownloadProgressIndicator(
                    // Pass actual progress data to prevent loading indicators
                    progress: _currentProgress!.percentage / 100,
                    status: _currentProgress!.status,
                    downloadSpeed: _currentProgress!.speed.isNotEmpty ? _currentProgress!.speed : null,
                    timeRemaining: _currentProgress!.timeRemaining.isNotEmpty ? _currentProgress!.timeRemaining : null,
                    downloadedSize: _currentProgress!.downloadedMB,
                    totalSize: _currentProgress!.totalMB,
                    isComplete: _currentProgress!.isComplete,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
