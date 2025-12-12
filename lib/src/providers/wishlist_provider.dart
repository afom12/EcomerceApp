import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/product.dart';

class WishlistProvider with ChangeNotifier {
  final List<Product> _wishlist = [];
  static const String _wishlistKey = 'wishlist';

  List<Product> get wishlist => _wishlist;

  bool isWishlisted(String productId) {
    return _wishlist.any((product) => product.id == productId);
  }

  Future<void> loadWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final wishlistJson = prefs.getString(_wishlistKey);
      if (wishlistJson != null) {
        final List<dynamic> decoded = json.decode(wishlistJson);
        _wishlist.clear();
        _wishlist.addAll(
          decoded.map((json) => Product(
            id: json['id'],
            name: json['name'],
            description: json['description'],
            price: json['price'].toDouble(),
            originalPrice: json['originalPrice']?.toDouble(),
            images: List<String>.from(json['images']),
            category: json['category'],
            sizes: List<String>.from(json['sizes']),
            colors: List<String>.from(json['colors']),
            rating: json['rating']?.toDouble() ?? 0.0,
            reviewCount: json['reviewCount'] ?? 0,
            isNew: json['isNew'] ?? false,
            isFavorite: true,
          )),
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading wishlist: $e');
    }
  }

  Future<void> toggleWishlist(Product product) async {
    final index = _wishlist.indexWhere((p) => p.id == product.id);
    
    if (index >= 0) {
      _wishlist.removeAt(index);
    } else {
      _wishlist.add(product.copyWith(isFavorite: true));
    }
    
    await _saveWishlist();
    notifyListeners();
  }

  Future<void> removeFromWishlist(String productId) async {
    _wishlist.removeWhere((product) => product.id == productId);
    await _saveWishlist();
    notifyListeners();
  }

  Future<void> clearWishlist() async {
    _wishlist.clear();
    await _saveWishlist();
    notifyListeners();
  }

  Future<void> _saveWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final wishlistJson = json.encode(
        _wishlist.map((product) => {
          'id': product.id,
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'originalPrice': product.originalPrice,
          'images': product.images,
          'category': product.category,
          'sizes': product.sizes,
          'colors': product.colors,
          'rating': product.rating,
          'reviewCount': product.reviewCount,
          'isNew': product.isNew,
        }).toList(),
      );
      await prefs.setString(_wishlistKey, wishlistJson);
    } catch (e) {
      debugPrint('Error saving wishlist: $e');
    }
  }
}

