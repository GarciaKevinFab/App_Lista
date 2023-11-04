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
  ScrollController _scrollController =
      ScrollController(); // Controlador de desplazamiento

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _scrollController.addListener(_onScroll); // Agregar el listener
  }

  void _loadProducts({bool nextPage = false}) async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<ProductsProvider>(context, listen: false)
          .fetchAndSetProducts(nextPage: nextPage);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    // Comprobar si estamos cerca del final de la lista
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      _loadProducts(nextPage: true);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll); // Eliminar el listener
    _scrollController.dispose(); // Limpiar el controlador
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products = productsData.products;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('ROCKET STORE', style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductsSearch(products),
              );
            },
          ),
        ],
      ),
      body: _isLoading && products.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: products.length,
              itemBuilder: (ctx, i) => ProductItem(
                name: products[i].name,
                price: products[i].price.toString(),
                product: products[i],
                stock: products[i].stock,
              ),
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
