import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../config/routes.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.secondary,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Profile picture
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Sarah Johnson',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'sarah.johnson@email.com',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // Menu items
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildMenuItem(
                      context,
                      icon: Icons.shopping_bag_outlined,
                      title: 'My Orders',
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.orderHistory);
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.favorite_border,
                      title: 'Wishlist',
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.wishlist);
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.location_on_outlined,
                      title: 'Addresses',
                      onTap: () {
                        // Navigate to addresses page
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.payment_outlined,
                      title: 'Payment Methods',
                      onTap: () {
                        // Navigate to payment methods page
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      onTap: () {
                        // Navigate to notifications page
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.settings_outlined,
                      title: 'Settings',
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.settings);
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      onTap: () {
                        // Navigate to help page
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.logout,
                      title: 'Logout',
                      isDestructive: true,
                      onTap: () {
                        _showLogoutDialog(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDestructive
                ? AppColors.error.withOpacity(0.1)
                : AppColors.primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isDestructive ? AppColors.error : AppColors.primary,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? AppColors.error : AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle logout
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

