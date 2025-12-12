import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 60,
            maxHeight: 70,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildNavItem(Icons.home_rounded, 'Home', 0),
              _buildNavItem(Icons.search_rounded, 'Search', 1),
              _buildNavItem(Icons.favorite_border_rounded, 'Wishlist', 2),
              _buildNavItem(Icons.shopping_bag_outlined, 'Cart', 3),
              _buildNavItem(Icons.person_outline_rounded, 'Profile', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryLight : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                size: 22,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
