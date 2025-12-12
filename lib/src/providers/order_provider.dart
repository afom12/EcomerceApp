import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import '../model/order.dart';
import '../model/cart_item.dart';

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];
  static const String _ordersKey = 'orders';
  final _uuid = const Uuid();

  List<Order> get orders => _orders;
  List<Order> get ordersByDateDesc => 
      List.from(_orders)..sort((a, b) => b.orderDate.compareTo(a.orderDate));

  Future<void> loadOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersJson = prefs.getString(_ordersKey);
      if (ordersJson != null) {
        final List<dynamic> decoded = json.decode(ordersJson);
        _orders.clear();
        _orders.addAll(
          decoded.map((json) => Order.fromJson(json)),
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading orders: $e');
    }
  }

  Future<Order> createOrder({
    required String userId,
    required List<CartItem> items,
    required ShippingAddress shippingAddress,
    required PaymentMethod paymentMethod,
    double shipping = 9.99,
    double taxRate = 0.08,
  }) async {
    final subtotal = items.fold(0.0, (sum, item) => sum + item.totalPrice);
    final tax = subtotal * taxRate;
    final total = subtotal + shipping + tax;

    final order = Order(
      id: _uuid.v4(),
      userId: userId,
      items: items,
      subtotal: subtotal,
      shipping: shipping,
      tax: tax,
      total: total,
      orderDate: DateTime.now(),
      status: OrderStatus.confirmed,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
    );

    _orders.add(order);
    await _saveOrders();
    notifyListeners();
    return order;
  }

  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  List<Order> getOrdersByStatus(OrderStatus status) {
    return _orders.where((order) => order.status == status).toList();
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    final order = getOrderById(orderId);
    if (order != null) {
      final index = _orders.indexOf(order);
      _orders[index] = Order(
        id: order.id,
        userId: order.userId,
        items: order.items,
        subtotal: order.subtotal,
        shipping: order.shipping,
        tax: order.tax,
        total: order.total,
        orderDate: order.orderDate,
        deliveryDate: newStatus == OrderStatus.delivered ? DateTime.now() : order.deliveryDate,
        status: newStatus,
        shippingAddress: order.shippingAddress,
        paymentMethod: order.paymentMethod,
        trackingNumber: order.trackingNumber,
      );
      await _saveOrders();
      notifyListeners();
    }
  }

  Future<void> _saveOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersJson = json.encode(
        _orders.map((order) => order.toJson()).toList(),
      );
      await prefs.setString(_ordersKey, ordersJson);
    } catch (e) {
      debugPrint('Error saving orders: $e');
    }
  }
}

