import 'package:flutter/material.dart';
import 'invoice_form.dart';

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
    return MaterialApp( 
      title: 'Flutify Invoice',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const InvoiceFormScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}