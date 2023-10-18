import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../widgets/product_item.dart';
import '../widgets/floating_cart_button.dart';
import '../widgets/products_search.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Establecer el estado de carga y llamar al proveedor
    setState(() {
      _isLoading = true;
    });
    Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    }).catchError((error) {
      // Manejo de errores básico, puede ser mejorado
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Ocurrió un error'),
          content: Text('Algo salió mal al cargar los productos.'),
          actions: [
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products = productsData.products;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'ROCKET STORE',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductsSearch(productsData.products),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) => ProductItem(
                  name: products[index].name,
                  price: products[index].price.toString(),
                  product: products[index],
                  stock: products[index].stock),
            ),
      floatingActionButton: FloatingCartButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/cartScreen');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
