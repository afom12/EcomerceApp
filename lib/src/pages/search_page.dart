import 'package:flutter/material.dart';
import '../model/product.dart';
import '../model/data.dart';
import '../services/search_service.dart';
import '../widgets/product_card.dart';
import '../theme/app_colors.dart';
import '../config/routes.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<Product> _searchResults = [];
  List<String> _autocompleteSuggestions = [];
  SearchFilters _filters = SearchFilters();
  bool _showFilters = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _searchResults = [];
        _autocompleteSuggestions = [];
      } else {
        _autocompleteSuggestions = SearchService.getAutocompleteSuggestions(query);
        _performSearch();
      }
    });
  }

  void _performSearch() {
    List<Product> results = SearchService.searchProducts(_searchQuery);
    if (_filters.hasFilters) {
      results = SearchService.filterProducts(results, _filters);
    }
    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search for products...',
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _searchFocusNode.requestFocus();
                    },
                  )
                : null,
          ),
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.filter_list),
                if (_filters.hasFilters)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            if (_showFilters) _buildFilters(),
            Expanded(
              child: _searchQuery.isEmpty
                  ? _buildEmptyState()
                  : _autocompleteSuggestions.isNotEmpty && _searchResults.isEmpty
                      ? _buildAutocompleteSuggestions()
                      : _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 80,
            color: AppColors.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            'Search for products',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Find your favorite fashion items',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildAutocompleteSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _autocompleteSuggestions.length,
      itemBuilder: (context, index) {
        final suggestion = _autocompleteSuggestions[index];
        return ListTile(
          leading: const Icon(Icons.search, color: AppColors.textSecondary),
          title: Text(suggestion),
          onTap: () {
            _searchController.text = suggestion;
            _searchFocusNode.unfocus();
          },
        );
      },
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: AppColors.textLight,
            ),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final product = _searchResults[index];
        return ProductCard(
          product: product,
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.productDetail,
              arguments: product,
            );
          },
        );
      },
    );
  }

  Widget _buildFilters() {
    final availableColors = SearchService.getAvailableColors();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _filters = SearchFilters();
                    _performSearch();
                  });
                },
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Category filter
          Text(
            'Category',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              ...AppData.categories.map((category) {
                final isSelected = _filters.category == category.name;
                return FilterChip(
                  label: Text(category.name),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _filters = _filters.copyWith(
                        category: selected ? category.name : null,
                      );
                      _performSearch();
                    });
                  },
                );
              }),
            ],
          ),
          const SizedBox(height: 16),
          // Price range
          Text(
            'Price Range',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Min',
                    prefixText: '\$',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _filters = _filters.copyWith(
                        minPrice: value.isEmpty ? null : double.tryParse(value),
                      );
                      _performSearch();
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Max',
                    prefixText: '\$',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _filters = _filters.copyWith(
                        maxPrice: value.isEmpty ? null : double.tryParse(value),
                      );
                      _performSearch();
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Color filter
          Text(
            'Color',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: availableColors.map((color) {
              final isSelected = _filters.color == color;
              return FilterChip(
                label: Text(color),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _filters = _filters.copyWith(
                      color: selected ? color : null,
                    );
                    _performSearch();
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          // Rating filter
          Text(
            'Minimum Rating',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [1, 2, 3, 4, 5].map((rating) {
              final isSelected = _filters.minRating == rating.toDouble();
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _filters = _filters.copyWith(
                      minRating: isSelected ? null : rating.toDouble(),
                    );
                    _performSearch();
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.star,
                    color: isSelected ? AppColors.warning : AppColors.border,
                    size: 30,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}

