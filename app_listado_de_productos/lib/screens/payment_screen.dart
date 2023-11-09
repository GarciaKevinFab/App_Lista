import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:io';
import '../providers/newOrder_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/MapScreen .dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../env.dart';

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
  String? _staticMapImageUrl;
  LatLng? _selectedLocation;

  final _picker = ImagePicker();
  NewOrderProvider? newOrderProvider;
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
      return 'Ingresa un nombre válido (solo letras y espacios)';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    if (!RegExp(r"^\d{9}$").hasMatch(value)) {
      return 'Ingresa un número de teléfono válido de 9 dígitos';
    }
    return null;
  }

  Future<void> _takePicture() async {
    final imageFile = await _picker.pickImage(source: ImageSource.camera);
    if (imageFile == null) return;

    setState(() {
      _pickedImage = File(imageFile.path);
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

  String getStaticMapImageUrl(LatLng location) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=${location.latitude},${location.longitude}&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7C${location.latitude},${location.longitude}&key=${Env.GOOGLE_MAPS_API_KEY}';
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
            key: _formKey,
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
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
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
                        //Widgets
                        Container(
                          // El contenedor principal que mantiene tus widgets
                          child: Column(
                            // Columna principal para organizar los widgets verticalmente
                            children: [
                              InkWell(
                                // Widget para capturar la imagen
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                onTap: _takePicture,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: _pickedImage != null
                                      ? Image.file(_pickedImage!)
                                      : Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Icon(
                                              Icons.camera_alt,
                                              size: 50,
                                              color: Colors.grey.shade600,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Foto de la fachada',
                                              style: TextStyle(
                                                color: Colors.grey.shade800,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                              Divider(
                                  height: 20,
                                  thickness: 1), // Separador entre los widgets
                              InkWell(
                                // Widget para seleccionar la ubicación
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                onTap: () async {
                                  final LatLng? selectedLocation =
                                      await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => MapScreen(),
                                    ),
                                  );
                                  if (selectedLocation != null) {
                                    // Realiza la operación asíncrona fuera de setState()
                                    _staticMapImageUrl =
                                        getStaticMapImageUrl(selectedLocation);
                                    double lat = selectedLocation.latitude;
                                    double lon = selectedLocation.longitude;
                                    String address = await _getAddress(lat,
                                        lon); // Espera a que se complete la operación asíncrona

                                    // Luego actualiza el estado con los nuevos valores
                                    setState(() {
                                      _selectedLocation = selectedLocation;
                                      _address =
                                          address; // Actualiza la dirección
                                      _userLat = lat; // Actualiza la latitud
                                      _userLng = lon; // Actualiza la longitud
                                    });
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(
                                        Icons.location_on,
                                        size: 24,
                                        color: Colors.grey.shade600,
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: _selectedLocation != null
                                            ? Image.network(_staticMapImageUrl!)
                                            : Text(
                                                _address ??
                                                    'Obtener mi dirección',
                                                style: TextStyle(
                                                  color: Colors.grey.shade800,
                                                  fontSize: 16,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        //Boton Compra
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
