import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice {
    return product.price * quantity;
  }
}

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((item) {
      total += item.product.price * item.quantity;
    });
    return total;
  }

  void addItem(Product product, BuildContext context) {
    final existingItem = _items.firstWhere(
        (item) => item.product.id == product.id,
        orElse: () => CartItem(
            product: Product(
                id: '', name: '', description: '', price: 0.0, stock: 0)));

    if (existingItem.product.id != '') {
      if (existingItem.quantity < existingItem.product.stock) {
        existingItem.quantity += 1;
      } else {
        // Mostrar una alerta si se alcanzó el stock disponible.
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              'Límite alcanzado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            content: Text(
              'Ya ha alcanzado la cantidad máxima en stock para este producto.',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Aceptar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.red, width: 2.0),
              borderRadius: BorderRadius.circular(8),
            ),
            titleTextStyle: TextStyle(
              color: Colors.black,
            ),
            contentTextStyle: TextStyle(
              color: Colors.black,
            ),
          ),
        );
      }
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeSingleItem(Product product) {
    final existingItem =
        _items.firstWhere((item) => item.product.id == product.id);

    if (existingItem.quantity > 1) {
      existingItem.quantity -= 1;
    } else {
      _items.remove(existingItem);
    }
    notifyListeners();
  }

  void removeItem(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  void clearCart() {
    _items = [];
    notifyListeners();
  }
}
