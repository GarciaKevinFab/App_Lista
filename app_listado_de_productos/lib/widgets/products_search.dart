import 'package:flutter/material.dart';
import '../providers/products_provider.dart';
import '../models/product.dart';
import '../screens/product_detail_screen.dart';

class ProductsSearch extends SearchDelegate<String> {
  final List<Product> products;

  ProductsSearch(this.products);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggestionList =
        products.where((product) => product.name.contains(query)).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(suggestionList[index].name),
        onTap: () {
          //  definir la acción cuando un producto es seleccionado después de la búsqueda
        },
      ),
    );
  }

  @override
  String get searchFieldLabel => 'Búsqueda';

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? products
        : products.where((product) => product.name.contains(query)).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(suggestionList[index].name),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  ProductDetailScreen(product: suggestionList[index]),
            ),
          );
        },
      ),
    );
  }
}
