import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'package:image_picker/image_picker.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _products = [];
  int _currentPage = 1;
  final int _itemsPerPage = 7;

  List<Product> get products {
    return [..._products];
  }

  Future<void> fetchAndSetProducts({bool nextPage = false}) async {
    if (nextPage) _currentPage++;

    final url = 'https://shop-api-roan.vercel.app/product?page=$_currentPage';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body) as List<dynamic>;
        final List<Product> loadedProducts = extractedData
            .map((item) => Product(
                  id: item['id'],
                  name: item['name'],
                  description: item['description'],
                  price: item['price'].toDouble(),
                  stock: int.parse(item['stock'].toString()),
                ))
            .toList();
        if (nextPage) {
          _products.addAll(loadedProducts);
        } else {
          _products = loadedProducts;
        }
        notifyListeners();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<String> uploadImageToServer(XFile? pickedImage) async {
    try {
      final url =
          'http://tu-servidor.com/upload'; // Cambia a tu URL de servidor

      if (pickedImage == null) {
        throw Exception('No se seleccionó una imagen');
      }

      final imageBytes = await File(pickedImage.path).readAsBytes();
      final imageBase64 = base64Encode(imageBytes);

      final response = await http.post(
        Uri.parse(url),
        body: {'imageBase64': imageBase64},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final imageUrl = jsonResponse['imageUrl'];
        return imageUrl;
      } else {
        throw Exception('Error al subir la imagen al servidor');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product, XFile? pickedImage) async {
    const url = 'http://10.0.2.2:3000/products';
    try {
      // Sube la imagen a Cloudinary y obtén la URL
      final imageUrl = await uploadImageToServer(pickedImage);

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'imageUrl': imageUrl, // Utiliza la URL de la imagen de Cloudinary
        }),
      );

      final newProduct = Product(
        id: json.decode(response.body)['_id'],
        name: product.name,
        description: product.description,
        price: product.price,
        stock: product.stock,
      );

      // Agrega el nuevo producto a la lista local
      _products.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _products.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = 'http://10.0.2.2:3000/products/$id';
      try {
        final response = await http.put(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'name': newProduct.name,
            'description': newProduct.description,
            'price': newProduct.price,
          }),
        );

        if (response.statusCode != 200) {
          throw Exception(
              'Failed to update product. Status code: ${response.statusCode}');
        }

        // Actualizamos el producto en la lista local después de verificar que la llamada API fue exitosa.
        _products[prodIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        print(error);
        throw error;
      }
    } else {
      print('ID no encontrado');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = 'http://10.0.2.2:3000/products/$id';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 204) {
        // Eliminación exitosa en la base de datos
        _products.removeWhere((product) => product.id == id);
        notifyListeners();
      } else {
        throw Exception(
            'Failed to delete product. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
