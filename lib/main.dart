import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/auth.dart';
import 'package:shopping_app/screens/edit_products_screen.dart';
import 'package:shopping_app/screens/splash_screen.dart';
import 'package:shopping_app/screens/user_products_screen.dart';

import './screens/cart_screen.dart';
import './providers/cart_provider.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products_provider.dart';
import './providers/orders_provider.dart';
import '../screens/orders_screen.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          create: (context) => ProductsProvider(null, null, []),
          update: (ctx, auth, previousProducts) => ProductsProvider(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          create: (_) => OrdersProvider(null, null, []),
          update: (context, auth, previousOrders) => OrdersProvider(auth.token,
              auth.userId, previousOrders == null ? [] : previousOrders.orders),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authData, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            colorScheme: ColorScheme(
              brightness: Brightness.light,
              primary: const Color.fromARGB(255, 68, 81, 137),
              onPrimary: Colors.white,
              secondary: Colors.pink.shade200,
              onSecondary: Colors.black,
              error: Colors.red,
              onError: Colors.white,
              background: Colors.white,
              onBackground: Colors.black87,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            fontFamily: 'OpenSans',
          ),
          home: authData.isAuth
              ? const ProductsOverviewScreen()
              : FutureBuilder(
                  future: authData.tryAutoLogin(),
                  builder: (context, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (context) =>
                const ProductDetailScreen(),
            CartScreen.routeName: (context) => const CartScreen(),
            OrdersScreen.routeName: (context) => const OrdersScreen(),
            UserProductsScreen.routeName: (context) =>
                const UserProductsScreen(),
            EditProductsScreen.routeName: (context) =>
                const EditProductsScreen(),
          },
        ),
      ),
    );
  }
}
