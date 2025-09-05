import 'dart:io';
import 'dart:async';
import 'package:archive/archive_io.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import '../models/image_model.dart';

class DownloadProgress {
  final int downloadedBytes;
  final int totalBytes;
  final double percentage;
  final String downloadedMB;
  final String totalMB;
  final String speed;
  final String timeRemaining;
  final String status;
  final bool isComplete;

  DownloadProgress({
    required this.downloadedBytes,
    required this.totalBytes,
    required this.percentage,
    required this.downloadedMB,
    required this.totalMB,
    required this.speed,
    required this.timeRemaining,
    required this.status,
    this.isComplete = false,
  });
}

class PictogramAssetsDownloader {
  static const String _extractedKey = 'pictogram_extracted';
  static const String _imageBoxName = 'images';
  static const String _zipDownloadUrl = 'https://github.com/ChauhanKrish4763/Auri/releases/download/v1/categorized_symbols.zip';

  final StreamController<DownloadProgress> _progressController =
      StreamController<DownloadProgress>.broadcast();

  Stream<DownloadProgress> get progressStream => _progressController.stream;

  bool get isDisposed => _progressController.isClosed;

  Future<bool> isDatasetExtracted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_extractedKey) ?? false;
  }

  Future<void> downloadPictogramAssets() async {
    try {
      final isExtracted = await isDatasetExtracted();
      
      if (isExtracted) {
        _updateProgress(0, 0, 'Checking existing data...', '', '');
        final isValid = await _validateDatasetIntegrity();
        
        if (isValid) {
          _updateProgress(1, 1, 'Assets ready!', '', '', isComplete: true);
          return;
        } else {
          await _resetExtractionFlag();
        }
      }

      await _cleanupBeforeDownload();
      await _downloadAndExtractArchive();
      await _indexImages();
      await _markAsExtracted();
      
      _updateProgress(1, 1, 'Download complete!', '', '', isComplete: true);
    } catch (e) {
      _updateProgress(0, 0, 'Error: $e', '', '');
      rethrow;
    }
  }

  Future<bool> _validateDatasetIntegrity() async {
    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final extractDir = Directory('${documentsDir.path}/pictogram_images');
      final rootDir = Directory('${extractDir.path}/categorized_symbols');

      if (!extractDir.existsSync() || !rootDir.existsSync()) return false;

      final categories = rootDir.listSync().where((entity) => entity is Directory).toList();
      if (categories.isEmpty) return false;

      bool hasImages = false;
      for (final categoryDir in categories) {
        if (categoryDir is Directory) {
          final images = categoryDir.listSync().where((file) =>
              file is File && _isImageFile(file.path)).toList();
          if (images.isNotEmpty) {
            hasImages = true;
            break;
          }
        }
      }

      if (!hasImages) return false;

      // Check Hive box
      if (Hive.isBoxOpen(_imageBoxName)) {
        final box = Hive.box<ImageModel>(_imageBoxName);
        return box.isNotEmpty;
      } else {
        try {
          final box = await Hive.openBox<ImageModel>(_imageBoxName);
          final result = box.isNotEmpty;
          await box.close();
          return result;
        } catch (e) {
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> _cleanupBeforeDownload() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final extractDir = Directory('${documentsDir.path}/pictogram_images');
    final tempDir = await getTemporaryDirectory();
    final zipFile = File('${tempDir.path}/categorized_symbols.zip');

    if (extractDir.existsSync()) {
      await extractDir.delete(recursive: true);
    }
    if (zipFile.existsSync()) {
      await zipFile.delete();
    }
  }

  Future<void> _downloadAndExtractArchive() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final extractDir = Directory('${documentsDir.path}/pictogram_images');
    await extractDir.create(recursive: true);

    final tempDir = await getTemporaryDirectory();
    final zipFile = File('${tempDir.path}/categorized_symbols.zip');

    try {
      final client = http.Client();
      final request = http.Request('GET', Uri.parse(_zipDownloadUrl));
      request.headers.addAll({
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        'Accept': '*/*',
        'Connection': 'keep-alive',
      });

      final response = await client.send(request);
      if (response.statusCode != 200) {
        throw Exception('Download failed with status: ${response.statusCode}');
      }

      final contentLength = response.contentLength ?? 0;
      int downloadedBytes = 0;
      final sink = zipFile.openWrite();
      
      var lastBytes = 0;
      var lastTime = DateTime.now();

      await for (final chunk in response.stream) {
        sink.add(chunk);
        downloadedBytes += chunk.length;
        
        final now = DateTime.now();
        if (now.difference(lastTime).inMilliseconds > 500) {
          final speed = _calculateSpeed(downloadedBytes - lastBytes, now.difference(lastTime));
          final timeRemaining = _calculateTimeRemaining(downloadedBytes, contentLength, speed);
          
          _updateProgress(downloadedBytes, contentLength, 'Downloading assets...', speed, timeRemaining);
          
          lastBytes = downloadedBytes;
          lastTime = now;
        }
      }

      await sink.close();
      client.close();

      // Extract
      _updateProgress(downloadedBytes, contentLength, 'Extracting files...', '', 'Processing...');
      
      final bytes = await zipFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);
      
      int extractedCount = 0;
      for (final file in archive) {
        if (file.isFile) {
          final data = file.content as List<int>;
          final extractedFile = File('${extractDir.path}/${file.name}');
          await extractedFile.create(recursive: true);
          await extractedFile.writeAsBytes(data, flush: true);
          extractedCount++;

          if (extractedCount % 100 == 0) {
            _updateProgress(
              extractedCount,
              archive.length,
              'Extracting... ($extractedCount/${archive.length})',
              '',
              'Processing...',
            );
          }
        }
      }

      await zipFile.delete();
    } catch (e) {
      throw Exception('Failed to download assets: $e');
    }
  }

  Future<void> _indexImages() async {
    _updateProgress(1, 1, 'Indexing images...', '', 'Finalizing...');
    
    final documentsDir = await getApplicationDocumentsDirectory();
    final rootDir = Directory('${documentsDir.path}/pictogram_images/categorized_symbols');

    if (!rootDir.existsSync()) {
      throw Exception('Extracted folder not found');
    }

    final box = Hive.isBoxOpen(_imageBoxName)
        ? Hive.box<ImageModel>(_imageBoxName)
        : await Hive.openBox<ImageModel>(_imageBoxName);

    await box.clear();
    
    int totalImages = 0;
    for (final categoryDir in rootDir.listSync()) {
      if (categoryDir is Directory) {
        final categoryName = categoryDir.path.split(Platform.pathSeparator).last;
        
        for (final imageFile in categoryDir.listSync()) {
          if (imageFile is File && _isImageFile(imageFile.path)) {
            final imageName = imageFile.path.split(Platform.pathSeparator).last;
            final imageNameWithoutExt = imageName.split('.').first;
            final meaning = _extractMeaning(imageNameWithoutExt);

            final imageModel = ImageModel(
              name: imageNameWithoutExt,
              filePath: imageFile.path,
              category: categoryName,
              meaning: meaning,
            );

            await box.add(imageModel);
            totalImages++;
          }
        }
      }
    }
  }

  String _extractMeaning(String filename) {
    return filename
        .replaceAll(RegExp(r'_\d+[a-z]?$'), '')
        .replaceAll(RegExp(r'_,_to$'), '')
        .replaceAll(RegExp(r'^(country_|flag_|football_kit_|communication_aid_|mobile_phone_)'), '')
        .replaceAll(RegExp(r'_-_lower_case$'), '')
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isEmpty ? word : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
  }

  bool _isImageFile(String path) {
    const extensions = ['.png', '.jpg', '.jpeg', '.gif', '.bmp', '.webp', '.svg'];
    return extensions.any((ext) => path.toLowerCase().endsWith(ext));
  }

  // MISSING METHODS - These were causing the errors:

  Future<void> _resetExtractionFlag() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_extractedKey, false);
  }

  Future<void> _markAsExtracted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_extractedKey, true);
  }

  String _calculateSpeed(int bytes, Duration duration) {
    if (duration.inMilliseconds == 0) return '0 KB/s';
    
    final bytesPerSecond = (bytes * 1000 / duration.inMilliseconds).toDouble();
    if (bytesPerSecond >= 1024 * 1024) {
      return '${(bytesPerSecond / 1024 / 1024).toStringAsFixed(1)} MB/s';
    } else if (bytesPerSecond >= 1024) {
      return '${(bytesPerSecond / 1024).toStringAsFixed(1)} KB/s';
    } else {
      return '${bytesPerSecond.toStringAsFixed(0)} B/s';
    }
  }

  String _calculateTimeRemaining(int downloaded, int total, String speed) {
    if (total <= 0 || downloaded <= 0) return 'Calculating...';
    if (downloaded >= total) return 'Complete';

    final speedMatch = RegExp(r'(\d+\.?\d*)\s*(B|KB|MB)/s').firstMatch(speed);
    if (speedMatch == null) return 'Calculating...';

    final speedValue = double.tryParse(speedMatch.group(1) ?? '0') ?? 0;
    final speedUnit = speedMatch.group(2);

    double bytesPerSecond;
    switch (speedUnit) {
      case 'MB':
        bytesPerSecond = speedValue * 1024 * 1024;
        break;
      case 'KB':
        bytesPerSecond = speedValue * 1024;
        break;
      default:
        bytesPerSecond = speedValue;
    }

    if (bytesPerSecond <= 0) return 'Calculating...';

    final remainingBytes = total - downloaded;
    final remainingSeconds = (remainingBytes / bytesPerSecond).toDouble();

    if (remainingSeconds < 60) {
      return '${remainingSeconds.toStringAsFixed(0)}s';
    } else if (remainingSeconds < 3600) {
      final minutes = remainingSeconds / 60;
      return '${minutes.toStringAsFixed(0)}m';
    } else {
      final hours = remainingSeconds / 3600;
      return '${hours.toStringAsFixed(1)}h';
    }
  }

  void _updateProgress(
    int downloaded,
    int total,
    String status,
    String speed,
    String timeRemaining, {
    bool isComplete = false,
  }) {
    if (_progressController.isClosed) return;

    final percentage = total > 0 ? (downloaded / total * 100) : 0;
    final downloadedMB = (downloaded / 1024 / 1024).toStringAsFixed(1);
    final totalMB = (total / 1024 / 1024).toStringAsFixed(1);

    _progressController.add(
      DownloadProgress(
        downloadedBytes: downloaded,
        totalBytes: total,
        percentage: percentage.clamp(0, 100).toDouble(),
        downloadedMB: downloadedMB,
        totalMB: totalMB,
        speed: speed,
        timeRemaining: timeRemaining,
        status: status,
        isComplete: isComplete,
      ),
    );
  }

  void dispose() {
    if (!_progressController.isClosed) {
      _progressController.close();
    }
  }

  // Static method for getting image box (if needed elsewhere)
  static Future<Box<ImageModel>> getImageBox() async {
    return Hive.isBoxOpen(_imageBoxName)
        ? Hive.box<ImageModel>(_imageBoxName)
        : await Hive.openBox<ImageModel>(_imageBoxName);
  }
}
