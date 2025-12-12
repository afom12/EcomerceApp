import 'cart_item.dart';

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
}

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double subtotal;
  final double shipping;
  final double tax;
  final double total;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final OrderStatus status;
  final ShippingAddress shippingAddress;
  final PaymentMethod paymentMethod;
  final String? trackingNumber;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.total,
    required this.orderDate,
    this.deliveryDate,
    required this.status,
    required this.shippingAddress,
    required this.paymentMethod,
    this.trackingNumber,
  });

  double get totalItems => items.fold(0.0, (sum, item) => sum + item.quantity);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => {
        'productId': item.product.id,
        'productName': item.product.name,
        'selectedSize': item.selectedSize,
        'selectedColor': item.selectedColor,
        'quantity': item.quantity,
        'price': item.product.price,
      }).toList(),
      'subtotal': subtotal,
      'shipping': shipping,
      'tax': tax,
      'total': total,
      'orderDate': orderDate.toIso8601String(),
      'deliveryDate': deliveryDate?.toIso8601String(),
      'status': status.toString().split('.').last,
      'shippingAddress': shippingAddress.toJson(),
      'paymentMethod': paymentMethod.toJson(),
      'trackingNumber': trackingNumber,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['userId'],
      items: [], // Will need to reconstruct from product data
      subtotal: json['subtotal'].toDouble(),
      shipping: json['shipping'].toDouble(),
      tax: json['tax'].toDouble(),
      total: json['total'].toDouble(),
      orderDate: DateTime.parse(json['orderDate']),
      deliveryDate: json['deliveryDate'] != null
          ? DateTime.parse(json['deliveryDate'])
          : null,
      status: OrderStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      shippingAddress: ShippingAddress.fromJson(json['shippingAddress']),
      paymentMethod: PaymentMethod.fromJson(json['paymentMethod']),
      trackingNumber: json['trackingNumber'],
    );
  }
}

class ShippingAddress {
  final String fullName;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String? phoneNumber;

  ShippingAddress({
    required this.fullName,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'phoneNumber': phoneNumber,
    };
  }

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      fullName: json['fullName'],
      street: json['street'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      country: json['country'],
      phoneNumber: json['phoneNumber'],
    );
  }

  String get fullAddress => '$street, $city, $state $zipCode, $country';
}

enum PaymentType {
  creditCard,
  debitCard,
  paypal,
  applePay,
  googlePay,
}

class PaymentMethod {
  final PaymentType type;
  final String? cardLast4;
  final String? cardBrand;

  PaymentMethod({
    required this.type,
    this.cardLast4,
    this.cardBrand,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'cardLast4': cardLast4,
      'cardBrand': cardBrand,
    };
  }

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      type: PaymentType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => PaymentType.creditCard,
      ),
      cardLast4: json['cardLast4'],
      cardBrand: json['cardBrand'],
    );
  }

  String get displayName {
    switch (type) {
      case PaymentType.creditCard:
        return cardLast4 != null ? 'Card ending in $cardLast4' : 'Credit Card';
      case PaymentType.debitCard:
        return cardLast4 != null ? 'Debit Card ending in $cardLast4' : 'Debit Card';
      case PaymentType.paypal:
        return 'PayPal';
      case PaymentType.applePay:
        return 'Apple Pay';
      case PaymentType.googlePay:
        return 'Google Pay';
    }
  }
}

