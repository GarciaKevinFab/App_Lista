import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewOrderProvider with ChangeNotifier {
  Future<void> sendOrder(Map<String, dynamic> orderData) async {
    try {
      final url =
          'https://shop-api-roan.vercel.app/order'; // Reemplaza con la URL de tu servidor de órdenes

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(orderData),
      );

      if (response.statusCode == 200) {
        // La orden se envió con éxito, puedes realizar acciones adicionales si es necesario.
        // Por ejemplo, limpiar el carrito de compras.
        // Si estás utilizando el patrón Provider, notifica a los escuchadores que la orden se ha enviado.
        notifyListeners();
      } else {
        throw Exception('Error al enviar la orden');
      }
    } catch (error) {
      print('Error al enviar la orden: $error');
      throw error;
    }
  }
}
