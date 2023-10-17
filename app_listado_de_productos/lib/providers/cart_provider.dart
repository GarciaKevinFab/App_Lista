import 'package:flutter/foundation.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;
}

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((item) {
      total += item.totalPrice;
    });
    return total;
  }

  void addItem(Product product) {
    final existingItem = _items.firstWhere(
        (item) => item.product.id == product.id,
        orElse: () => CartItem(
            product: Product(id: '', name: '', description: '', price: 0.0)));

    if (existingItem.product.id != '') {
      existingItem.quantity += 1;
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
