import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/data.dart';
import '../model/product.dart';
import '../model/category.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chip.dart';
import '../providers/wishlist_provider.dart';
import '../services/recommendation_service.dart';
import '../theme/app_colors.dart';
import '../config/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  List<Product> get filteredProducts {
    if (selectedCategory == 'All') {
      return AppData.products;
    }
    return AppData.products.where((p) => p.category == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello, Welcome!',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Find Your Style',
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.notifications_outlined),
                            color: AppColors.primary,
                            onPressed: () {
                              // Handle notifications
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowLight,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search for products...',
                          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.search);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Categories Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categories',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 50,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          CategoryChip(
                            category: Category(
                              id: 'all',
                              name: 'All',
                              icon: '✨',
                            ),
                            isSelected: selectedCategory == 'All',
                            onTap: () {
                              setState(() {
                                selectedCategory = 'All';
                              });
                            },
                          ),
                          ...AppData.categories.map(
                            (category) => CategoryChip(
                              category: category,
                              isSelected: selectedCategory == category.name,
                              onTap: () {
                                setState(() {
                                  selectedCategory = category.name;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Featured Products Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Featured Products',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'See All',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Products Grid
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = filteredProducts[index];
                    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
                    final isWishlisted = wishlistProvider.isWishlisted(product.id);
                    return ProductCard(
                      product: product.copyWith(isFavorite: isWishlisted),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.productDetail,
                          arguments: product,
                        );
                      },
                      onFavoriteTap: () {
                        wishlistProvider.toggleWishlist(product);
                        setState(() {}); // Refresh to update heart icon
                      },
                    );
                  },
                  childCount: filteredProducts.length,
                ),
              ),
            ),

            // Recommended Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recommended for You',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: RecommendationService.getRecommendedProducts().length,
                        itemBuilder: (context, index) {
                          final product = RecommendationService.getRecommendedProducts()[index];
                          final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
                          final isWishlisted = wishlistProvider.isWishlisted(product.id);
                          return SizedBox(
                            width: 200,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: ProductCard(
                                product: product.copyWith(isFavorite: isWishlisted),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.productDetail,
                                    arguments: product,
                                  );
                                },
                                onFavoriteTap: () {
                                  wishlistProvider.toggleWishlist(product);
                                  setState(() {}); // Refresh to update heart icon
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom padding for bottom navigation
            const SliverToBoxAdapter(
              child: SizedBox(height: 80),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
