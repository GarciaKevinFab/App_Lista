import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/product.dart';
import '../screens/product_detail_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductItem extends StatelessWidget {
  final String name;
  final String price;
  final Product product;
  final int stock;

  ProductItem(
      {required this.name,
      required this.price,
      required this.product,
      required this.stock});

  void _showToast(BuildContext context, String message) {
    FToast fToast = FToast();
    fToast.init(context);

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.green, // Cambiamos el color a verde para indicar éxito
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 6.0,
            offset:
                Offset(0, 2), // Añade sombreado al toast para darle profundidad
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check,
              color: Colors
                  .white), // Cambiamos el ícono a "check" y lo hacemos blanco
          SizedBox(
            width: 12.0,
          ),
          Text(
            message,
            style: TextStyle(
                color: Colors
                    .white), // Hacemos el texto blanco para que contraste con el fondo verde
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity
          .BOTTOM, // Cambiamos la posición a la parte inferior para mayor visibilidad
      toastDuration: Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => ProductDetailScreen(product: product),
          ));
        },
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          // Aquí debes añadir la imagen del producto. Puedes usar Image.network(product.imageUrl) si tienes URLs de imágenes, por ejemplo.
          child: Container(
            color: Colors.grey[
                300], // Este es un placeholder hasta que agregues una imagen.
            width: 50,
            height: 50,
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              "\$$price",
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.add, color: Colors.red),
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false)
                    .addItem(product, context);
                _showToast(context, 'Producto añadido al carrito!');
              },
            ),
          ],
        ),
      ),
    );
  }
}
