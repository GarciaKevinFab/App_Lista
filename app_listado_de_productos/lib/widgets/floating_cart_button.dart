import 'package:flutter/material.dart';

class FloatingCartButton extends StatelessWidget {
  final VoidCallback onPressed;

  FloatingCartButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: Icon(Icons.shopping_cart),
      backgroundColor: Colors.red,
    );
  }
}
