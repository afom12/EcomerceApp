class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final List<String> images;
  final String category;
  final List<String> sizes;
  final List<String> colors;
  final double rating;
  final int reviewCount;
  final bool isNew;
  final bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.images,
    required this.category,
    required this.sizes,
    required this.colors,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isNew = false,
    this.isFavorite = false,
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > price;
  
  double get discountPercentage {
    if (!hasDiscount) return 0;
    return ((originalPrice! - price) / originalPrice!) * 100;
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    List<String>? images,
    String? category,
    List<String>? sizes,
    List<String>? colors,
    double? rating,
    int? reviewCount,
    bool? isNew,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      images: images ?? this.images,
      category: category ?? this.category,
      sizes: sizes ?? this.sizes,
      colors: colors ?? this.colors,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isNew: isNew ?? this.isNew,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

