import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:provider/provider.dart';
import '../model/product.dart';
import '../model/cart_item.dart';
import '../model/review.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/recommendation_service.dart';
import '../widgets/reviews_widget.dart';
import '../widgets/size_guide_widget.dart';
import '../widgets/ar_try_on_widget.dart';
import '../widgets/product_card.dart';
import '../theme/app_colors.dart';
import '../config/routes.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final PageController _pageController = PageController();
  String? _selectedSize;
  String? _selectedColor;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.product.sizes.isNotEmpty ? widget.product.sizes.first : null;
    _selectedColor = widget.product.colors.isNotEmpty ? widget.product.colors.first : null;
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final isInCart = cartProvider.isInCart(
      widget.product.id,
      _selectedSize ?? '',
      _selectedColor ?? '',
    );
    final isWishlisted = wishlistProvider.isWishlisted(widget.product.id);
    final similarProducts = RecommendationService.getSimilarProducts(widget.product);
    final sampleReviews = _getSampleReviews();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildAppBar(wishlistProvider, isWishlisted),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageCarousel(),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProductInfo(),
                          const SizedBox(height: 24),
                          _buildActionButtons(),
                          const SizedBox(height: 24),
                          _buildSizeSelector(),
                          const SizedBox(height: 24),
                          _buildColorSelector(),
                          const SizedBox(height: 24),
                          _buildQuantitySelector(),
                          const SizedBox(height: 24),
                          _buildDescription(),
                          const SizedBox(height: 24),
                          ReviewsWidget(
                            reviews: sampleReviews,
                            averageRating: widget.product.rating,
                            totalReviews: widget.product.reviewCount,
                          ),
                          if (similarProducts.isNotEmpty) ...[
                            const SizedBox(height: 32),
                            Text(
                              'You May Also Like',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 300,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: similarProducts.length,
                                itemBuilder: (context, index) {
                                  final product = similarProducts[index];
                                  return SizedBox(
                                    width: 200,
                                    child: ProductCard(
                                      product: product,
                                      onTap: () {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          AppRoutes.productDetail,
                                          arguments: product,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomBar(cartProvider, isInCart),
          ],
        ),
      ),
    );
  }

  List<Review> _getSampleReviews() {
    return [
      Review(
        id: '1',
        productId: widget.product.id,
        userId: 'user1',
        userName: 'Sarah M.',
        rating: 5.0,
        comment: 'Absolutely love this dress! Perfect fit and beautiful quality.',
        date: DateTime.now().subtract(const Duration(days: 2)),
        verifiedPurchase: true,
      ),
      Review(
        id: '2',
        productId: widget.product.id,
        userId: 'user2',
        userName: 'Emily R.',
        rating: 4.5,
        comment: 'Great product, fast shipping. Would recommend!',
        date: DateTime.now().subtract(const Duration(days: 5)),
        verifiedPurchase: true,
      ),
    ];
  }

  Widget _buildAppBar(WishlistProvider wishlistProvider, bool isWishlisted) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  isWishlisted ? Icons.favorite : Icons.favorite_border,
                  color: isWishlisted ? AppColors.secondary : AppColors.textSecondary,
                ),
                onPressed: () {
                  wishlistProvider.toggleWishlist(widget.product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isWishlisted
                            ? 'Removed from wishlist'
                            : 'Added to wishlist',
                      ),
                      backgroundColor: AppColors.success,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // Share functionality
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => SizeGuideWidget(category: widget.product.category),
              );
            },
            icon: const Icon(Icons.straighten),
            label: const Text('Size Guide'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => ARTryOnWidget(
                  productImage: widget.product.images.first,
                ),
              );
            },
            icon: const Icon(Icons.camera_alt),
            label: const Text('Try On'),
          ),
        ),
      ],
    );
  }

  Widget _buildImageCarousel() {
    return SizedBox(
      height: 400,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (_) {},
            itemCount: widget.product.images.length,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: widget.product.images[index],
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.primaryLight,
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.primaryLight,
                  child: const Icon(Icons.image_not_supported, color: AppColors.primary),
                ),
              );
            },
          ),
          if (widget.product.images.length > 1)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: widget.product.images.length,
                  effect: const WormEffect(
                    dotColor: AppColors.border,
                    activeDotColor: AppColors.primary,
                    dotHeight: 8,
                    dotWidth: 8,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (widget.product.isNew)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'NEW',
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (widget.product.hasDiscount) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '-${widget.product.discountPercentage.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        Text(
          widget.product.name,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            if (widget.product.rating > 0) ...[
              const Icon(Icons.star, color: AppColors.warning, size: 20),
              const SizedBox(width: 4),
              Text(
                widget.product.rating.toStringAsFixed(1),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(width: 8),
              Text(
                '(${widget.product.reviewCount} reviews)',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              '\$${widget.product.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (widget.product.hasDiscount) ...[
              const SizedBox(width: 12),
              Text(
                '\$${widget.product.originalPrice!.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      decoration: TextDecoration.lineThrough,
                      color: AppColors.textLight,
                    ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildSizeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Size',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: widget.product.sizes.map((size) {
            final isSelected = _selectedSize == size;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedSize = size;
                });
              },
              child: Container(
                width: 60,
                height: 50,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    size,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: widget.product.colors.map((color) {
            final isSelected = _selectedColor == color;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = color;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: 2,
                  ),
                ),
                child: Text(
                  color,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        Text(
          'Quantity',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  if (_quantity > 1) {
                    setState(() {
                      _quantity--;
                    });
                  }
                },
              ),
              Text(
                '$_quantity',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    _quantity++;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Text(
          widget.product.description,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildBottomBar(CartProvider cartProvider, bool isInCart) {
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
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: isInCart
                    ? null
                    : () {
                        cartProvider.addToCart(
                          CartItem(
                            product: widget.product,
                            selectedSize: _selectedSize ?? '',
                            selectedColor: _selectedColor ?? '',
                            quantity: _quantity,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Added to cart!'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  isInCart ? 'Already in Cart' : 'Add to Cart',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.shopping_bag_outlined),
                color: AppColors.primary,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.cart);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

