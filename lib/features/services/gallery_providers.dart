import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'image_service.dart';
import 'pictogram_assets_downloader.dart';

final pictogramAssetsDownloaderProvider = Provider((ref) => PictogramAssetsDownloader());
final imageServiceProvider = Provider((ref) => ImageService());
final searchQueryProvider = StateProvider<String>((ref) => '');

// Check if assets are downloaded
final assetsDownloadedProvider = FutureProvider<bool>((ref) async {
  final downloader = ref.read(pictogramAssetsDownloaderProvider);
  return await downloader.isDatasetExtracted();
});

// Initialize only if assets are downloaded
final initializationProvider = FutureProvider((ref) async {
  final downloader = ref.read(pictogramAssetsDownloaderProvider);
  final imageService = ref.read(imageServiceProvider);
  
  print('Starting initialization...');
  await downloader.downloadPictogramAssets();
  await imageService.initialize();
  print('Initialization completed!');
});

final categoriesProvider = FutureProvider<List<String>>((ref) async {
  await ref.watch(initializationProvider.future);
  final service = ref.read(imageServiceProvider);
  return service.getCategories();
});

final categoryImagesProvider = FutureProvider.family<List<ImageItem>, String>((ref, category) async {
  await ref.watch(initializationProvider.future);
  final service = ref.read(imageServiceProvider);
  return service.getImagesByCategory(category);
});

final searchResultsProvider = FutureProvider<List<ImageItem>>((ref) async {
  await ref.watch(initializationProvider.future);
  final query = ref.watch(searchQueryProvider);
  
  if (query.trim().isEmpty) {
    return [];
  }
  
  final service = ref.read(imageServiceProvider);
  return service.searchImages(query);
});

final progressStreamProvider = StreamProvider<DownloadProgress>((ref) {
  final downloader = ref.read(pictogramAssetsDownloaderProvider);
  return downloader.progressStream;
});
