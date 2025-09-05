import 'package:hive/hive.dart';
import '../models/image_model.dart';
import 'pictogram_assets_downloader.dart';  // Changed from archive_service.dart

class ImageItem {
  final String name;
  final String? filePath;
  final String category;
  final String meaning;

  const ImageItem({
    required this.name,
    this.filePath,
    required this.category,
    required this.meaning,
  });
}

class ImageService {
  late Box<ImageModel> _imageBox;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _imageBox = await PictogramAssetsDownloader.getImageBox();  // Changed from ArchiveService
    _initialized = true;
    print('ImageService initialized. Total images in box: ${_imageBox.length}');
  }

  Future<List<String>> getCategories() async {
    if (!_initialized) await initialize();
    final categories = <String>{};
    for (final image in _imageBox.values) {
      categories.add(image.category);
    }
    final sortedCategories = categories.toList()..sort();
    print('Found categories: $sortedCategories');
    return sortedCategories;
  }

  Future<List<ImageItem>> getImagesByCategory(String category) async {
    if (!_initialized) await initialize();
    final filteredImages = _imageBox.values
        .where((model) => model.category == category)
        .toList();
    print('Fetching images for category $category: ${filteredImages.length} found');
    return filteredImages.map((model) => ImageItem(
      name: model.name,
      filePath: model.filePath,
      category: model.category,
      meaning: model.meaning,
    )).toList();
  }

  Future<List<ImageItem>> searchImages(String query) async {
    if (!_initialized) await initialize();
    final filteredImages = _imageBox.values
        .where((model) =>
            model.name.toLowerCase().contains(query.toLowerCase()) ||
            model.meaning.toLowerCase().contains(query.toLowerCase()))
        .toList();
    print('Searching for "$query": ${filteredImages.length} images found');
    return filteredImages.map((model) => ImageItem(
      name: model.name,
      filePath: model.filePath,
      category: model.category,
      meaning: model.meaning,
    )).toList();
  }
}
