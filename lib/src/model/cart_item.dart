import 'product.dart';

class CartItem {
  final Product product;
  final String selectedSize;
  final String selectedColor;
  int quantity;

  CartItem({
    required this.product,
    required this.selectedSize,
    required this.selectedColor,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    Product? product,
    String? selectedSize,
    String? selectedColor,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
      quantity: quantity ?? this.quantity,
    );
  }
}

