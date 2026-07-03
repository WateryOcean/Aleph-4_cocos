class ProductModel {
  final String id;
  final String name;
  final String category; // Anime, Game, Film
  final String subCategory; // contoh: Demon Slayer, Genshin
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

  factory ProductModel.fromJson(Map<String, dynamic> json) {

    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      subCategory: json['subCategory'] as String,
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      imagePath: json['imagePath'] as String,
      availableVersions: List<String>.from(json['availableVersions'] ?? []),
      materials: List<String>.from(json['materials'] ?? []),
      sizes: List<String>.from(json['sizes'] ?? []),
      description: json['description'] as String,
    );
  }
 
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'subCategory': subCategory,
      'price': price,
      'rating': rating,
      'imagePath': imagePath,
      'availableVersions': availableVersions,
      'materials': materials,
      'sizes': sizes,
      'description': description,
    };
  }
}