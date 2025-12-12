import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../model/review.dart';
import '../theme/app_colors.dart';

class ReviewsWidget extends StatelessWidget {
  final List<Review> reviews;
  final double averageRating;
  final int totalReviews;

  const ReviewsWidget({
    super.key,
    required this.reviews,
    required this.averageRating,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reviews',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: averageRating,
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: AppColors.warning,
                      ),
                      itemCount: 5,
                      itemSize: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$averageRating ($totalReviews reviews)',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                // Show all reviews dialog
                _showAllReviews(context);
              },
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (reviews.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'No reviews yet. Be the first to review!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ),
          )
        else
          ...reviews.take(3).map((review) => _buildReviewCard(context, review)),
      ],
    );
  }

  Widget _buildReviewCard(BuildContext context, Review review) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    review.userName[0].toUpperCase(),
                    style: const TextStyle(color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            review.userName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (review.verifiedPurchase) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Verified',
                                style: TextStyle(
                                  color: AppColors.success,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        _formatDate(review.date),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                RatingBarIndicator(
                  rating: review.rating,
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: AppColors.warning,
                  ),
                  itemCount: 5,
                  itemSize: 16,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              review.comment,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (review.images.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: review.images.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.borderLight,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          review.images[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showAllReviews(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Reviews',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  return _buildReviewCard(context, reviews[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}

