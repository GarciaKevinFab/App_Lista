import 'package:flutter/material.dart';
import 'product_list_screen.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red, // Cambio de color para el ícono
              size: 100.0,
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                'Oops ocurrió un problema',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Por favor, intenta de nuevo',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.normal,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/paymentScreen');
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // Cambio de color de fondo para el botón
                onPrimary: Colors.white, // color del texto
                padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              child: Text(
                'Volver a intentar',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Navegar a ProductListScreen al pulsar el botón.
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductListScreen()));
              },
              style: ElevatedButton.styleFrom(
                primary: Colors
                    .grey, // Cambio de color de fondo para el botón de regreso
                onPrimary: Colors.white, // color del texto
                padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              child: Text(
                'Regresar al inicio',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
