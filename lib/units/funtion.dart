import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

  Widget buildNumberButton(String number,  void Function(String) onNumberPress) {
    return GestureDetector(
      onTap: () => onNumberPress(number),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color.fromARGB(255, 98, 197, 162),
        ),
        alignment: Alignment.center,
        child: Text(
          number,
          style: const TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget buildDeleteButton(VoidCallback onDeletePress) {
    return GestureDetector(
      onTap: onDeletePress,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red.shade100,
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.backspace, size: 24, color: Colors.red),
      ),
    );
  }

  //ตรวจประเภทรูปภาพแล้วแสดง
  Widget resolveImageWidget({required String imagePath}) {
    final isAsset1 = imagePath.startsWith('data:image/png;base64,');
    return isAsset1
      ? Image.memory(
        Uint8List.fromList(base64Decode(imagePath.split(',').last)),
        fit: BoxFit.contain,
      )
      : Image.asset(
        imagePath,
        width: 45,
        height: 45,
        fit: BoxFit.contain,
    );
  }