import 'package:flutter/material.dart';
import 'product_list_screen.dart';

class SuccessfulScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                'Hemos recibido tu pedido.',
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
              'Vuelve pronto!',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.normal,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () {
                // Navegar a ProductListScreen al pulsar el botón.
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductListScreen()));
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // color de fondo
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
