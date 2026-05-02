class ProductModel {
  final String id;
  final String name;
  final String category; // Anime, Game, Film
  final String subCategory; // e.g., Demon Slayer, Genshin
  final double price;
  final double rating;
  final String imagePath;
  final List<String> availableVersions;
  final List<String> materials;
  final List<String> sizes;
  final String description;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.subCategory,
    required this.price,
    required this.rating,
    required this.imagePath,
    required this.availableVersions,
    required this.materials,
    required this.sizes,
    required this.description,
  });
}
