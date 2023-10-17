import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../models/product.dart';

class EditProductScreen extends StatefulWidget {
  final Product? product;

  EditProductScreen({this.product});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _form = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();

  var _editedProduct = Product(
    id: null,
    name: '',
    description: '',
    price: 0.0,
  );

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _editedProduct = widget.product!;
      _nameController.text = _editedProduct.name;
      _descriptionController.text = _editedProduct.description;
      _priceController.text = _editedProduct.price.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return; // Si no es válido, simplemente regresamos y no hacemos nada.
    }

    // Esta línea es esencial para actualizar correctamente `_editedProduct` antes de hacer la llamada API.
    _form.currentState!.save();

    Provider.of<ProductsProvider>(context, listen: false).updateProduct(
      _editedProduct.id!,
      _editedProduct,
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red, // Fondo rojo
        title: Text(
          'Editar Producto',
          style: TextStyle(color: Colors.white), // Letras blancas
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save, color: Colors.white), // Ícono blanco
            onPressed: _saveForm,
          )
        ],
        iconTheme: IconThemeData(
            color: Colors
                .white), // Esto asegura que todos los íconos en la AppBar sean blancos
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nombre'),
                textInputAction: TextInputAction.next,
                onSaved: (value) {
                  _editedProduct = Product(
                    name: _nameController.text,
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    id: _editedProduct.id,
                  );
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingrese un nombre.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                textInputAction: TextInputAction.next,
                onSaved: (value) {
                  _editedProduct = Product(
                    name: _editedProduct.name,
                    description: _descriptionController.text,
                    price: _editedProduct.price,
                    id: _editedProduct.id,
                  );
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingrese una descripción.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Precio'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _editedProduct = Product(
                    name: _editedProduct.name,
                    description: _editedProduct.description,
                    price: double.parse(_priceController.text),
                    id: _editedProduct.id,
                  );
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingrese un precio.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor, ingrese un número válido.';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
