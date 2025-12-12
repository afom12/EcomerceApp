import '../model/product.dart';
import '../model/data.dart';

class SearchFilters {
  final String? category;
  final double? minPrice;
  final double? maxPrice;
  final String? color;
  final String? size;
  final double? minRating;
  final bool? onlyNew;
  final bool? onlyOnSale;

  SearchFilters({
    this.category,
    this.minPrice,
    this.maxPrice,
    this.color,
    this.size,
    this.minRating,
    this.onlyNew,
    this.onlyOnSale,
  });

  SearchFilters copyWith({
    String? category,
    double? minPrice,
    double? maxPrice,
    String? color,
    String? size,
    double? minRating,
    bool? onlyNew,
    bool? onlyOnSale,
  }) {
    return SearchFilters(
      category: category ?? this.category,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      color: color ?? this.color,
      size: size ?? this.size,
      minRating: minRating ?? this.minRating,
      onlyNew: onlyNew ?? this.onlyNew,
      onlyOnSale: onlyOnSale ?? this.onlyOnSale,
    );
  }

  bool get hasFilters =>
      category != null ||
      minPrice != null ||
      maxPrice != null ||
      color != null ||
      size != null ||
      minRating != null ||
      onlyNew == true ||
      onlyOnSale == true;
}

class SearchService {
  /// Search products by query string
  static List<Product> searchProducts(String query) {
    if (query.isEmpty) return [];

    final lowerQuery = query.toLowerCase();
    return AppData.products.where((product) {
      return product.name.toLowerCase().contains(lowerQuery) ||
          product.description.toLowerCase().contains(lowerQuery) ||
          product.category.toLowerCase().contains(lowerQuery) ||
          product.colors.any((color) => color.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  /// Get autocomplete suggestions
  static List<String> getAutocompleteSuggestions(String query) {
    if (query.isEmpty) return [];

    final lowerQuery = query.toLowerCase();
    final suggestions = <String>{};

    for (final product in AppData.products) {
      if (product.name.toLowerCase().contains(lowerQuery)) {
        suggestions.add(product.name);
      }
      if (product.category.toLowerCase().contains(lowerQuery)) {
        suggestions.add(product.category);
      }
      for (final color in product.colors) {
        if (color.toLowerCase().contains(lowerQuery)) {
          suggestions.add(color);
        }
      }
    }

    return suggestions.take(5).toList();
  }

  /// Filter products based on search filters
  static List<Product> filterProducts(
    List<Product> products,
    SearchFilters filters,
  ) {
    return products.where((product) {
      // Category filter
      if (filters.category != null && product.category != filters.category) {
        return false;
      }

      // Price filters
      if (filters.minPrice != null && product.price < filters.minPrice!) {
        return false;
      }
      if (filters.maxPrice != null && product.price > filters.maxPrice!) {
        return false;
      }

      // Color filter
      if (filters.color != null && !product.colors.contains(filters.color)) {
        return false;
      }

      // Size filter
      if (filters.size != null && !product.sizes.contains(filters.size)) {
        return false;
      }

      // Rating filter
      if (filters.minRating != null && product.rating < filters.minRating!) {
        return false;
      }

      // New products filter
      if (filters.onlyNew == true && !product.isNew) {
        return false;
      }

      // Sale products filter
      if (filters.onlyOnSale == true && !product.hasDiscount) {
        return false;
      }

      return true;
    }).toList();
  }

  /// Get all available colors from products
  static List<String> getAvailableColors() {
    final colors = <String>{};
    for (final product in AppData.products) {
      colors.addAll(product.colors);
    }
    return colors.toList()..sort();
  }

  /// Get all available sizes from products
  static List<String> getAvailableSizes() {
    final sizes = <String>{};
    for (final product in AppData.products) {
      sizes.addAll(product.sizes);
    }
    return sizes.toList()..sort();
  }

  /// Get price range from all products
  static Map<String, double> getPriceRange() {
    if (AppData.products.isEmpty) {
      return {'min': 0.0, 'max': 0.0};
    }

    final prices = AppData.products.map((p) => p.price).toList();
    return {
      'min': prices.reduce((a, b) => a < b ? a : b),
      'max': prices.reduce((a, b) => a > b ? a : b),
    };
  }
}

