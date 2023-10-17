import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final String name;
  final String price;
  final Product product;

  ProductItem({
    required this.name,
    required this.price,
    required this.product,
  });

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
                    .addItem(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Producto añadido al carrito!'),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
