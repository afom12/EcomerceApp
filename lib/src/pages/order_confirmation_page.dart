import 'package:flutter/material.dart';
import '../model/order.dart';
import '../theme/app_colors.dart';
import '../config/routes.dart';

class OrderConfirmationPage extends StatelessWidget {
  final Order order;

  const OrderConfirmationPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 60,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Order Confirmed!',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Thank you for your purchase',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Details',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Order Number', order.id.substring(0, 8)),
                    _buildDetailRow('Order Date', _formatDate(order.orderDate)),
                    _buildDetailRow('Total Items', order.totalItems.toInt().toString()),
                    _buildDetailRow('Total Amount', '\$${order.total.toStringAsFixed(2)}'),
                    _buildDetailRow('Payment Method', order.paymentMethod.displayName),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shipping Address',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(order.shippingAddress.fullAddress),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.main,
                          (route) => false,
                        );
                      },
                      child: const Text('Continue Shopping'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.orderHistory,
                        );
                      },
                      child: const Text('View Orders'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}

