import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../model/order.dart';
import '../theme/app_colors.dart';
import '../config/routes.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _phoneController = TextEditingController();
  PaymentType _selectedPayment = PaymentType.creditCard;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    if (cartProvider.items.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    final subtotal = cartProvider.totalPrice;
    final shipping = 9.99;
    final tax = subtotal * 0.08;
    final total = subtotal + shipping + tax;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shipping Address',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _streetController,
                decoration: const InputDecoration(
                  labelText: 'Street Address',
                  hintText: 'Enter street address',
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter street address' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'City',
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _stateController,
                      decoration: const InputDecoration(
                        labelText: 'State',
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _zipController,
                      decoration: const InputDecoration(
                        labelText: 'ZIP Code',
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'Payment Method',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              ...PaymentType.values.map((type) {
                return RadioListTile<PaymentType>(
                  title: Text(_getPaymentTypeName(type)),
                  value: type,
                  groupValue: _selectedPayment,
                  onChanged: (value) {
                    setState(() {
                      _selectedPayment = value!;
                    });
                  },
                );
              }),
              const SizedBox(height: 32),
              Text(
                'Order Summary',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              _buildOrderSummary(subtotal, shipping, tax, total),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isProcessing
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isProcessing = true;
                            });

                            try {
                              final order = await orderProvider.createOrder(
                                userId: 'user_${const Uuid().v4()}',
                                items: cartProvider.items,
                                shippingAddress: ShippingAddress(
                                  fullName: _nameController.text,
                                  street: _streetController.text,
                                  city: _cityController.text,
                                  state: _stateController.text,
                                  zipCode: _zipController.text,
                                  country: 'USA',
                                  phoneNumber: _phoneController.text.isEmpty
                                      ? null
                                      : _phoneController.text,
                                ),
                                paymentMethod: PaymentMethod(
                                  type: _selectedPayment,
                                ),
                                shipping: shipping,
                                taxRate: 0.08,
                              );

                              cartProvider.clearCart();

                              if (mounted) {
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.orderConfirmation,
                                  arguments: order,
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              }
                            } finally {
                              if (mounted) {
                                setState(() {
                                  _isProcessing = false;
                                });
                              }
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          'Place Order - \$${total.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 18),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary(
    double subtotal,
    double shipping,
    double tax,
    double total,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', subtotal),
          _buildSummaryRow('Shipping', shipping),
          _buildSummaryRow('Tax', tax),
          const Divider(),
          _buildSummaryRow('Total', total, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
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

  String _getPaymentTypeName(PaymentType type) {
    switch (type) {
      case PaymentType.creditCard:
        return 'Credit Card';
      case PaymentType.debitCard:
        return 'Debit Card';
      case PaymentType.paypal:
        return 'PayPal';
      case PaymentType.applePay:
        return 'Apple Pay';
      case PaymentType.googlePay:
        return 'Google Pay';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}

