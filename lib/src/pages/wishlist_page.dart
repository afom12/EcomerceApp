import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wishlist_provider.dart';
import '../widgets/product_card.dart';
import '../theme/app_colors.dart';
import '../config/routes.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        actions: [
          if (wishlistProvider.wishlist.isNotEmpty)
            TextButton(
              onPressed: () {
                wishlistProvider.clearWishlist();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Wishlist cleared'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: const Text('Clear All'),
            ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: wishlistProvider.wishlist.isEmpty
            ? _buildEmptyWishlist(context)
            : GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: wishlistProvider.wishlist.length,
                itemBuilder: (context, index) {
                  final product = wishlistProvider.wishlist[index];
                  return ProductCard(
                    product: product,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.productDetail,
                        arguments: product,
                      );
                    },
                    onFavoriteTap: () {
                      wishlistProvider.toggleWishlist(product);
                    },
                  );
                },
              ),
      ),
    );
  }

  Widget _buildEmptyWishlist(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 100,
            color: AppColors.textLight,
          ),
          const SizedBox(height: 24),
          Text(
            'Your wishlist is empty',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the heart icon to save your favorite items',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

