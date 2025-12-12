import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/product_detail_page.dart';
import '../pages/cart_page.dart';
import '../pages/main_page.dart';
import '../pages/search_page.dart';
import '../pages/wishlist_page.dart';
import '../pages/checkout_page.dart';
import '../pages/order_confirmation_page.dart';
import '../pages/order_history_page.dart';
import '../pages/order_detail_page.dart';
import '../pages/splash_screen.dart';
import '../pages/onboarding_screen.dart';
import '../pages/profile_page.dart';
import '../pages/settings_page.dart';
import '../model/product.dart';
import '../model/order.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String main = '/main';
  static const String productDetail = '/product-detail';
  static const String cart = '/cart';
  static const String search = '/search';
  static const String wishlist = '/wishlist';
  static const String checkout = '/checkout';
  static const String orderConfirmation = '/order-confirmation';
  static const String orderHistory = '/order-history';
  static const String orderDetail = '/order-detail';
  static const String profile = '/profile';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case main:
        return MaterialPageRoute(builder: (_) => const MainPage());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case productDetail:
        final product = routeSettings.arguments as Product?;
        if (product == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(
                child: Text('Product not found'),
              ),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => ProductDetailPage(product: product),
        );
      case cart:
        return MaterialPageRoute(builder: (_) => const CartPage());
      case search:
        return MaterialPageRoute(builder: (_) => const SearchPage());
      case wishlist:
        return MaterialPageRoute(builder: (_) => const WishlistPage());
      case checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutPage());
      case orderConfirmation:
        final order = routeSettings.arguments as Order?;
        if (order == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(
                child: Text('Order not found'),
              ),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => OrderConfirmationPage(order: order),
        );
      case orderHistory:
        return MaterialPageRoute(builder: (_) => const OrderHistoryPage());
      case orderDetail:
        final order = routeSettings.arguments as Order?;
        if (order == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(
                child: Text('Order not found'),
              ),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => OrderDetailPage(order: order),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${routeSettings.name}'),
            ),
          ),
        );
    }
  }
}

