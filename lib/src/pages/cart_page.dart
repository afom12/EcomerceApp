import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/cart_provider.dart';
import '../theme/app_colors.dart';
import '../config/routes.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        actions: [
          if (cartProvider.items.isNotEmpty)
            TextButton(
              onPressed: () {
                cartProvider.clearCart();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cart cleared'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: Text(
                'Clear',
                style: TextStyle(color: AppColors.error),
              ),
            ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: cartProvider.items.isEmpty
            ? _buildEmptyCart(context)
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      itemCount: cartProvider.items.length,
                      itemBuilder: (context, index) {
                        final item = cartProvider.items[index];
                        return _buildCartItem(context, item, cartProvider);
                      },
                    ),
                  ),
                  _buildCheckoutBar(context, cartProvider),
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 100,
                color: AppColors.textLight,
              ),
              const SizedBox(height: 24),
              Text(
                'Your cart is empty',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add some products to get started',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.main,
                    (route) => false,
                  );
                },
                child: const Text('Start Shopping'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, cartItem, CartProvider cartProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: cartItem.product.images.first,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 100,
                  height: 100,
                  color: AppColors.primaryLight,
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 100,
                  height: 100,
                  color: AppColors.primaryLight,
                  child: const Icon(Icons.image_not_supported, color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.product.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Size: ${cartItem.selectedSize}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    'Color: ${cartItem.selectedColor}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${cartItem.product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            // Quantity and Delete
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: AppColors.error,
                  onPressed: () {
                    cartProvider.removeFromCart(
                      cartItem.product.id,
                      cartItem.selectedSize,
                      cartItem.selectedColor,
                    );
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 18),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          cartProvider.updateQuantity(
                            cartItem.product.id,
                            cartItem.selectedSize,
                            cartItem.selectedColor,
                            cartItem.quantity - 1,
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '${cartItem.quantity}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 18),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          cartProvider.updateQuantity(
                            cartItem.product.id,
                            cartItem.selectedSize,
                            cartItem.selectedColor,
                            cartItem.quantity + 1,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutBar(BuildContext context, CartProvider cartProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Flexible(
                  child: Text(
                    '\$${cartProvider.totalPrice.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.checkout);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Checkout',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
