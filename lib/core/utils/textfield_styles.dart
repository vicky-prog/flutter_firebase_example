import 'package:flutter/material.dart';

BoxDecoration textfiledBackground() {
    return BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(10));
  }

InputDecoration customInputDecoration({
  String hintText = '',
  Widget? prefixIcon,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    hintText: hintText,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
  );
}