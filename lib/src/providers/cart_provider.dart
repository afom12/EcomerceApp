import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/cart_item.dart';
import '../model/data.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  static const String _cartKey = 'cart';

  List<CartItem> get items => _items;

  int get itemCount => _items.length;

  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  Future<void> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(_cartKey);
      if (cartJson != null) {
        final List<dynamic> decoded = json.decode(cartJson);
        _items.clear();
        for (final itemJson in decoded) {
          final product = AppData.products.firstWhere(
            (p) => p.id == itemJson['productId'],
            orElse: () => AppData.products.first,
          );
          _items.add(CartItem(
            product: product,
            selectedSize: itemJson['selectedSize'],
            selectedColor: itemJson['selectedColor'],
            quantity: itemJson['quantity'],
          ));
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading cart: $e');
    }
  }

  Future<void> addToCart(CartItem item) async {
    final existingIndex = _items.indexWhere(
      (cartItem) =>
          cartItem.product.id == item.product.id &&
          cartItem.selectedSize == item.selectedSize &&
          cartItem.selectedColor == item.selectedColor,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    await _saveCart();
    notifyListeners();
  }

  Future<void> removeFromCart(String productId, String size, String color) async {
    _items.removeWhere(
      (item) =>
          item.product.id == productId &&
          item.selectedSize == size &&
          item.selectedColor == color,
    );
    await _saveCart();
    notifyListeners();
  }

  Future<void> updateQuantity(String productId, String size, String color, int quantity) async {
    final index = _items.indexWhere(
      (item) =>
          item.product.id == productId &&
          item.selectedSize == size &&
          item.selectedColor == color,
    );

    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      await _saveCart();
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    _items.clear();
    await _saveCart();
    notifyListeners();
  }

  bool isInCart(String productId, String size, String color) {
    return _items.any(
      (item) =>
          item.product.id == productId &&
          item.selectedSize == size &&
          item.selectedColor == color,
    );
  }

  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = json.encode(
        _items.map((item) => {
          'productId': item.product.id,
          'selectedSize': item.selectedSize,
          'selectedColor': item.selectedColor,
          'quantity': item.quantity,
        }).toList(),
      );
      await prefs.setString(_cartKey, cartJson);
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
  }
}

