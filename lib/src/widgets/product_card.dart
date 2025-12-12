import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/product.dart';
import '../theme/app_colors.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: AspectRatio(
                    aspectRatio: 0.85,
                    child: CachedNetworkImage(
                      imageUrl: product.images.first,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.primaryLight,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.primaryLight,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        product.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: product.isFavorite ? AppColors.secondary : AppColors.textSecondary,
                      ),
                      onPressed: onFavoriteTap,
                    ),
                  ),
                ),
                if (product.isNew)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'NEW',
                        style: TextStyle(
                          color: AppColors.textWhite,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (product.hasDiscount)
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '-${product.discountPercentage.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: AppColors.textWhite,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (product.rating > 0) ...[
                        const Icon(
                          Icons.star,
                          color: AppColors.warning,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${product.reviewCount})',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          if (product.hasDiscount)
                            Text(
                              '\$${product.originalPrice!.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: AppColors.textLight,
                                  ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

