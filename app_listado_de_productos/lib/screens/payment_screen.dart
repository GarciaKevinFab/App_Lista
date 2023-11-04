import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart' as loc;
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:io';
import '../providers/newOrder_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/direction_widget.dart';
import '../widgets/photo_widget.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedPaymentMethod;
  String? _userName;
  String? _userPhone;
  double? _userLat;
  double? _userLng;
  File? _pickedImage;
  String? _address;

  final _picker = ImagePicker();
  NewOrderProvider? newOrderProvider;
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Inicializa newOrderProvider aquí
    newOrderProvider = Provider.of<NewOrderProvider>(context, listen: false);
  }

  // Función para validar el formulario
  bool isFormValid() {
    return _selectedPaymentMethod != null &&
        _userName != null &&
        _userPhone != null &&
        _userLat != null &&
        _userLng != null &&
        _pickedImage != null &&
        _address != null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    if (!RegExp(r"^[a-zA-Z ]+$").hasMatch(value)) {
      // Asegúrate de permitir espacios para nombres compuestos
      return 'Ingresa un nombre válido (solo letras y espacios)';
    }
    return null; // Debes retornar null para indicar que no hay error
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    if (!RegExp(r"^\d{9}$").hasMatch(value)) {
      return 'Ingresa un número de teléfono válido de 9 dígitos';
    }
    return null; // Debes retornar null para indicar que no hay error
  }

  Future<void> _takePicture() async {
    final imageFile = await _picker.pickImage(source: ImageSource.camera);
    if (imageFile == null) return;

    setState(() {
      _pickedImage = File(imageFile.path);
    });
  }

  Future<void> _getLocation() async {
    final location = loc.Location();
    final currentLocation = await location.getLocation();
    _userLat = currentLocation.latitude;
    _userLng = currentLocation.longitude;
    _getAddress(currentLocation.latitude!, currentLocation.longitude!)
        .then((address) {
      setState(() {
        _address = address;
      });
    });
  }

  Future<String> _getAddress(double lat, double lon) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
    if (placemarks.isNotEmpty) {
      final place = placemarks[0];
      return "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
    }
    return "Dirección no encontrada";
  }

  InputDecoration getDecor(String hint) {
    return InputDecoration(
      labelText: hint,
      labelStyle: TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.grey[100],
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 2.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      backgroundColor: Colors.red[50],
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("PAGAR", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            // This is added to integrate the Form widget
            key: _formKey, // Assign the global key to the form

            child: Column(
              children: [
                // Voucher de Resumen de Compra
                Card(
                  color: Colors.white,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resumen de Compra',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Divider(),
                        ...List.generate(
                          cart.items.length,
                          (index) => Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    cart.items[index].product.name,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    '${cart.items[index].quantity} x \$${cart.items[index].product.price}',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey[800]),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                            ],
                          ),
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${cart.totalAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Formulario de Datos de Compra
                Card(
                  elevation: 8,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        15), // Aumento del radio para suavizar las esquinas
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(
                        20.0), // Aumento del padding para más espacio interior
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Datos de Compra',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 20),
                        Divider(color: Colors.grey[400], thickness: 1.0),
                        DropdownButtonFormField<String>(
                          decoration: getDecor('Método de pago'),
                          items: [
                            DropdownMenuItem(
                                child: Text('Cash'), value: 'cash'),
                            DropdownMenuItem(
                                child: Text('Credit Card'),
                                value: 'credit-card'),
                            DropdownMenuItem(
                                child: Text('Debit Card'), value: 'debit-card'),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentMethod = value;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: getDecor('Nombre'),
                          onChanged: (value) {
                            setState(() {
                              _userName = value;
                            });
                          },
                          validator: _validateName, // Agrega la validación
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: getDecor('Teléfono'),
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
                            setState(() {
                              _userPhone = value;
                            });
                          },
                          validator:
                              _validatePhoneNumber, // Agrega la validación
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey[800] ?? Colors.grey,
                                  ), // Color más claro para el borde
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: PhotoWidget(
                                  image: _pickedImage,
                                  onTap: _takePicture,
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey[800] ?? Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(10.0),
                                child: DirectionWidget(
                                  address: _address,
                                  onTap: _getLocation,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Esto activará la validación
                                final orderData = {
                                  'paymentMethod': _selectedPaymentMethod,
                                  'userName': _userName,
                                  'userPhone': _userPhone,
                                  'userAddress': _address,
                                  'userLat': _userLat,
                                  'userLng': _userLng,
                                  'userPhoto': _pickedImage?.path,
                                  'products': cart.items
                                      .map((cartItem) => {
                                            'id': cartItem.product.id,
                                            'amount': cartItem.quantity,
                                          })
                                      .toList(),
                                  // Otros datos que necesites enviar
                                };
                                print('Datos de la orden: $orderData');
                                if (newOrderProvider != null) {
                                  newOrderProvider!
                                      .sendOrder(context, orderData);
                                }
                              }
                            },
                            // Deshabilita el botón si el formulario no es válido
                            child:
                                Text('Comprar', style: TextStyle(fontSize: 20)),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              textStyle: TextStyle(color: Colors.white),
                              padding: EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 70.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
