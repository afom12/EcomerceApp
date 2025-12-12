import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/order.dart';
import '../theme/app_colors.dart';

class OrderDetailPage extends StatelessWidget {
  final Order order;

  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${order.id.substring(0, 8)}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(context),
            const SizedBox(height: 24),
            _buildOrderItems(context),
            const SizedBox(height: 24),
            _buildShippingInfo(context),
            const SizedBox(height: 24),
            _buildPaymentInfo(context),
            const SizedBox(height: 24),
            _buildOrderSummary(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (order.status) {
      case OrderStatus.pending:
        statusColor = AppColors.warning;
        statusText = 'Pending';
        statusIcon = Icons.pending;
        break;
      case OrderStatus.confirmed:
        statusColor = AppColors.info;
        statusText = 'Confirmed';
        statusIcon = Icons.check_circle_outline;
        break;
      case OrderStatus.processing:
        statusColor = AppColors.info;
        statusText = 'Processing';
        statusIcon = Icons.settings;
        break;
      case OrderStatus.shipped:
        statusColor = AppColors.primary;
        statusText = 'Shipped';
        statusIcon = Icons.local_shipping;
        break;
      case OrderStatus.delivered:
        statusColor = AppColors.success;
        statusText = 'Delivered';
        statusIcon = Icons.check_circle;
        break;
      case OrderStatus.cancelled:
        statusColor = AppColors.error;
        statusText = 'Cancelled';
        statusIcon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (order.trackingNumber != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Tracking: ${order.trackingNumber}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Items',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        ...order.items.map((item) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.primaryLight,
                  ),
                  child: item.product.images.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.product.images.first,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(Icons.image),
                ),
                title: Text(item.product.name),
                subtitle: Text('Size: ${item.selectedSize} | Color: ${item.selectedColor}'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Qty: ${item.quantity}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      '\$${item.totalPrice.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildShippingInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shipping Address',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.shippingAddress.fullName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(order.shippingAddress.fullAddress),
              if (order.shippingAddress.phoneNumber != null) ...[
                const SizedBox(height: 8),
                Text('Phone: ${order.shippingAddress.phoneNumber}'),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Information',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.paymentMethod.displayName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Icon(Icons.payment, color: AppColors.primary),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildSummaryRow(context, 'Subtotal', order.subtotal),
          _buildSummaryRow(context, 'Shipping', order.shipping),
          _buildSummaryRow(context, 'Tax', order.tax),
          const Divider(),
          _buildSummaryRow(context, 'Total', order.total, isTotal: true),
          const SizedBox(height: 16),
          Text(
            'Order Date: ${DateFormat('MMM dd, yyyy').format(order.orderDate)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    double amount, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  color: isTotal ? AppColors.primary : null,
                ),
          ),
        ],
      ),
    );
  }
}

