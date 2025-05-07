import 'package:flutify_invoice/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const FlutifyInvoiceApp(); // Use FlutifyInvoiceApp as the home
  }
}

class FlutifyInvoiceApp extends StatelessWidget {
  const FlutifyInvoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp( 
      title: 'Flutify Invoice',
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}