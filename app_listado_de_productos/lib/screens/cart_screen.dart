import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/confirmation_dialog.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Colors.red[50],
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("CARRITO", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    title: Text(
                      cart.items[index].product.name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${cart.items[index].quantity} x \$${cart.items[index].product.price}',
                      style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Total: \$${cart.items[index].totalPrice}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red[800])),
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.add, color: Colors.green),
                                onPressed: () {
                                  cart.addItem(
                                      cart.items[index].product, context);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.remove, color: Colors.red),
                                onPressed: () {
                                  // Suponiendo que tienes una manera de saber la cantidad actual del producto
                                  int currentQuantity =
                                      cart.items[index].quantity;
                                  // Verificar si la cantidad actual es 1 antes de quitar
                                  if (currentQuantity == 1) {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => ConfirmationDialog(
                                        title: 'Quitar producto',
                                        message:
                                            'Este es el último elemento. ¿Estás seguro de que quieres eliminar este producto del carrito?',
                                        onConfirm: (bool value) {
                                          if (value) {
                                            cart.removeSingleItem(
                                                cart.items[index].product);
                                          }
                                        },
                                      ),
                                    );
                                  } else {
                                    cart.removeSingleItem(
                                        cart.items[index].product);
                                  }
                                },
                              ),
                              IconButton(
                                icon:
                                    Icon(Icons.delete, color: Colors.grey[700]),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => ConfirmationDialog(
                                      title: 'Eliminar producto',
                                      message:
                                          '¿Estás seguro de que quieres eliminar este producto del carrito?',
                                      onConfirm: (bool value) {
                                        if (value) {
                                          cart.removeItem(
                                              cart.items[index].product);
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (cart.items.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red[400]!, Colors.red[600]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '\$${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    // Esta es la línea divisoria que he agregado
                    color: Colors.white,
                    thickness: 2.0,
                    height: 20.0,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.red[600],
                      textStyle: TextStyle(fontSize: 20),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.red[600]!, width: 2),
                      ),
                    ),
                    child: Text('PAGAR'),
                    onPressed: () {
                      // Logic for payment processing
                      Navigator.of(context).pushNamed('/paymentScreen');
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
