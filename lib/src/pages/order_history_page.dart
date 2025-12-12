import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/order_provider.dart';
import '../model/order.dart';
import '../theme/app_colors.dart';
import '../config/routes.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: orderProvider.orders.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orderProvider.ordersByDateDesc.length,
              itemBuilder: (context, index) {
                final order = orderProvider.ordersByDateDesc[index];
                return _buildOrderCard(context, order);
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
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
            'No orders yet',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your order history will appear here',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.orderDetail,
            arguments: order,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order #${order.id.substring(0, 8)}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  _buildStatusChip(order.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat('MMM dd, yyyy').format(order.orderDate),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Text(
                '${order.totalItems.toInt()} items',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '\$${order.total.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
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

  Widget _buildStatusChip(OrderStatus status) {
    Color color;
    String text;

    switch (status) {
      case OrderStatus.pending:
        color = AppColors.warning;
        text = 'Pending';
        break;
      case OrderStatus.confirmed:
        color = AppColors.info;
        text = 'Confirmed';
        break;
      case OrderStatus.processing:
        color = AppColors.info;
        text = 'Processing';
        break;
      case OrderStatus.shipped:
        color = AppColors.primary;
        text = 'Shipped';
        break;
      case OrderStatus.delivered:
        color = AppColors.success;
        text = 'Delivered';
        break;
      case OrderStatus.cancelled:
        color = AppColors.error;
        text = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

