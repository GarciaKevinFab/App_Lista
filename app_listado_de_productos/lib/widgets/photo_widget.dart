import 'dart:io';
import 'package:flutter/material.dart';

class PhotoWidget extends StatelessWidget {
  final File? image;
  final Function onTap;

  PhotoWidget({required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: image != null
          ? Image.file(image!)
          : Icon(Icons.camera_alt, size: 50, color: Colors.grey),
    );
  }
}
