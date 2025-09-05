import 'dart:io';
import 'package:auri_app/features/components/custom_appbar.dart';
import 'package:auri_app/features/components/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/gallery_providers.dart';
import '../services/image_service.dart';
import 'categories_images_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoriesPage extends ConsumerStatefulWidget {
  const CategoriesPage({super.key});

  @override
  ConsumerState<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends ConsumerState<CategoriesPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final initialization = ref.watch(initializationProvider);
    
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: const CustomAppbar(title: "Pictogram Category"),
      body: initialization.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          print('Initialization error: $error');
          return _buildErrorUI(error.toString());
        },
        data: (_) => _buildMainContent(),
      ),
    );
  }

  Widget _buildErrorUI(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 24),
            Text(
              'Failed to initialize gallery',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => ref.invalidate(initializationProvider),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            onChanged: (value) => ref.read(searchQueryProvider.notifier).state = value,
            decoration: InputDecoration(
              hintText: 'Search pictograms...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(searchQueryProvider.notifier).state = '';
                      },
                    )
                  : null,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        // Content
        Expanded(
          child: Consumer(
            builder: (context, ref, child) {
              final query = ref.watch(searchQueryProvider);
              if (query.trim().isNotEmpty) {
                return _buildSearchResults();
              } else {
                return _buildCategoriesGrid();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesGrid() {
    final categoriesAsync = ref.watch(categoriesProvider);
    return categoriesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error loading categories: $error'),
            ElevatedButton(
              onPressed: () => ref.invalidate(categoriesProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (categories) => GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1, // Single column as requested
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.0,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _CategoryTile(category: category);
        },
      ),
    );
  }

  Widget _buildSearchResults() {
    final searchResultsAsync = ref.watch(searchResultsProvider);
    return searchResultsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (results) {
        if (results.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No pictograms found'),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final item = results[index];
            return _SearchResultTile(item: item);
          },
        );
      },
    );
  }
}

// Keep your existing _CategoryTile and _SearchResultTile classes exactly the same
class _CategoryTile extends StatelessWidget {
  final String category;
  const _CategoryTile({required this.category});

  String _getCategoryImagePath(String category) {
    switch (category.toLowerCase()) {
      case 'home & family':
        return 'assets/pictogram-logos/hf.webp';
      case 'food & drink':
        return 'assets/pictogram-logos/fd.webp';
      case 'emotions & feelings':
        return 'assets/pictogram-logos/ef.webp';
      case 'actions & verbs':
        return 'assets/pictogram-logos/av.webp';
      case 'objects & things':
        return 'assets/pictogram-logos/ot.webp';
      case 'people & relationships':
        return 'assets/pictogram-logos/pr.webp';
      case 'places & buildings':
        return 'assets/pictogram-logos/pb.webp';
      case 'body & health':
        return 'assets/pictogram-logos/bh.webp';
      case 'time & calendar':
        return 'assets/pictogram-logos/tc.webp';
      case 'nature & weather':
        return 'assets/pictogram-logos/nw.webp';
      case 'colors & shapes':
        return 'assets/pictogram-logos/cs.webp';
      case 'numbers & math':
        return 'assets/pictogram-logos/nm.webp';
      case 'communication':
        return 'assets/pictogram-logos/c.webp';
      case 'transportation':
        return 'assets/pictogram-logos/t.webp';
      default:
        return 'assets/pictogram-logos/ot.webp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  CategoryImagesPage(category: category),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(position: offsetAnimation, child: child);
              },
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primaryContainer,
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8),
              ],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                flex: 92,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white.withOpacity(0.9),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      _getCategoryImagePath(category),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.category,
                          size: 40,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Center(
                  child: Text(
                    category,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final ImageItem item;
  const _SearchResultTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
              child: _buildPictogramImage(context, item.filePath),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.meaning,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item.category,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPictogramImage(BuildContext context, String? path) {
    if (path == null || !File(path).existsSync()) {
      return const Icon(Icons.image, size: 40);
    }

    if (path.toLowerCase().endsWith('.svg')) {
      return SvgPicture.file(
        File(path),
        fit: BoxFit.cover,
        placeholderBuilder: (context) => const Icon(Icons.image, size: 40),
        height: double.infinity,
        width: double.infinity,
      );
    } else {
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, size: 40),
      );
    }
  }
}
