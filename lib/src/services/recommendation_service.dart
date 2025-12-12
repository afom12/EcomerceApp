import '../model/product.dart';
import '../model/data.dart';

class RecommendationService {
  /// Get recommended products based on user's browsing/viewing history
  static List<Product> getRecommendedProducts({
    List<String>? viewedProductIds,
    List<String>? favoriteCategories,
  }) {
    List<Product> recommendations = [];

    // If user has viewed products, recommend similar products
    if (viewedProductIds != null && viewedProductIds.isNotEmpty) {
      final viewedProducts = AppData.products
          .where((p) => viewedProductIds.contains(p.id))
          .toList();

      // Get products from same categories
      final categories = viewedProducts.map((p) => p.category).toSet();
      recommendations.addAll(
        AppData.products.where((p) =>
            categories.contains(p.category) &&
            !viewedProductIds.contains(p.id)),
      );

      // Get products with similar price range
      if (viewedProducts.isNotEmpty) {
        final avgPrice = viewedProducts
            .map((p) => p.price)
            .reduce((a, b) => a + b) /
            viewedProducts.length;
        recommendations.addAll(
          AppData.products.where((p) =>
              (p.price >= avgPrice * 0.7 && p.price <= avgPrice * 1.3) &&
              !viewedProductIds.contains(p.id) &&
              !recommendations.contains(p)),
        );
      }
    }

    // If user has favorite categories, recommend from those
    if (favoriteCategories != null && favoriteCategories.isNotEmpty) {
      recommendations.addAll(
        AppData.products.where((p) =>
            favoriteCategories.contains(p.category) &&
            !recommendations.contains(p)),
      );
    }

    // If no preferences, recommend new arrivals and highly rated products
    if (recommendations.isEmpty) {
      recommendations.addAll(
        AppData.products.where((p) => p.isNew || p.rating >= 4.5),
      );
    }

    // Remove duplicates and limit to 8 products
    return recommendations.toSet().take(8).toList();
  }

  /// Get "You may also like" products based on a specific product
  static List<Product> getSimilarProducts(Product product) {
    return AppData.products
        .where((p) =>
            p.id != product.id &&
            (p.category == product.category ||
                p.price >= product.price * 0.8 &&
                    p.price <= product.price * 1.2))
        .take(4)
        .toList();
  }

  /// Get trending products (high rating + recent)
  static List<Product> getTrendingProducts() {
    return AppData.products
        .where((p) => p.rating >= 4.0 && p.reviewCount >= 50)
        .toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));
  }

  /// Get best sellers (high review count)
  static List<Product> getBestSellers() {
    return List.from(AppData.products)
      ..sort((a, b) => b.reviewCount.compareTo(a.reviewCount))
      ..take(8);
  }
}

