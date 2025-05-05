import 'dart:io';
import 'package:flutter/material.dart';

class AnexoItem extends StatelessWidget {
  final File file;

  const AnexoItem({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Image.file(file, height: 150, fit: BoxFit.cover),
    );
  }
}
