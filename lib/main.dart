import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/theme/app_theme.dart';
import 'src/config/routes.dart';
import 'src/providers/cart_provider.dart';
import 'src/providers/wishlist_provider.dart';
import 'src/providers/order_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()..loadCart()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()..loadWishlist()),
        ChangeNotifierProvider(create: (_) => OrderProvider()..loadOrders()),
      ],
      child: MaterialApp(
        title: 'Women\'s Fashion Store',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}

