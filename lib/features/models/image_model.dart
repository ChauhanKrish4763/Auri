import 'package:hive/hive.dart';

part 'image_model.g.dart';

@HiveType(typeId: 0)
class ImageModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String filePath;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final String meaning;

  ImageModel({
    required this.name,
    required this.filePath,
    required this.category,
    required this.meaning,
  });
}
