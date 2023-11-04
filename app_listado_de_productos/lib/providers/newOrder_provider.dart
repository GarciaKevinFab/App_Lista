import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewOrderProvider with ChangeNotifier {
  Future<void> sendOrder(
      BuildContext context, Map<String, dynamic>? orderData) async {
    final url = 'https://shop-api-roan.vercel.app/order';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(orderData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(
            'Order sent successfully. Order ID: ${json.decode(response.body)['id']}');

        Provider.of<CartProvider>(context, listen: false).clearCart();

        Navigator.pushReplacementNamed(context, '/success');
      } else {
        print('Error sending order: ${response.statusCode}');
        print('Error details: ${response.body}');
        Navigator.pushReplacementNamed(context, '/error');
      }
    } on http.ClientException catch (e) {
      print('HTTP Client Exception: ${e.message}');
      Navigator.pushReplacementNamed(context, '/error');
    } on FormatException catch (e) {
      print('Format Exception: ${e.message}');
      Navigator.pushReplacementNamed(context, '/error');
    } catch (e) {
      print('Unexpected error: $e');
      Navigator.pushReplacementNamed(context, '/error');
    }

    notifyListeners();
  }
}
