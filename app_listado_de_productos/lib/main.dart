import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart';
import 'screens/product_list_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/successful_screen.dart';
import 'screens/error_screen.dart';
import 'providers/products_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/newOrder_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ProductsProvider()),
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
        ChangeNotifierProvider(create: (ctx) => NewOrderProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (ctx) => ProductListScreen(),
        '/cartScreen': (ctx) => CartScreen(),
        '/paymentScreen': (ctx) => PaymentScreen(),
        '/success': (ctx) => SuccessfulScreen(),
        '/error': (ctx) => ErrorScreen(),
      },
      builder: FToastBuilder(),
      navigatorKey: navigatorKey,
    );
  }
}
