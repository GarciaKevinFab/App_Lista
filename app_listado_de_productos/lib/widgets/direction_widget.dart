import 'package:flutter/material.dart';

class DirectionWidget extends StatelessWidget {
  final String? address;
  final Function onTap;

  DirectionWidget({required this.address, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: address != null && address!.isNotEmpty
          ? Text(address!)
          : Text("Obtener mi dirección", style: TextStyle(color: Colors.blue)),
    );
  }
}
