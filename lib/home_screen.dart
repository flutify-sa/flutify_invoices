import 'package:flutter/material.dart';
import 'first_invoice_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Static Flutify details
    const String flutifyDetails = '''
Flutify (Pty) Ltd
Registration Number: 2025/326018/07
Taxpayer Ref No: 9470850224''';

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              const Text(
                'flutify.co.za',
                style: TextStyle(fontSize: 32), 
                textAlign: TextAlign.center, 
              ),
              const SizedBox(height: 20),
  const Text(
                'Invoice Generator',
                style: TextStyle(fontSize: 24), 
                textAlign: TextAlign.center, 
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/valknut.png',
                height: 150,
              ),
              const SizedBox(height: 20),

              // Display Flutify details
              const Text(
                flutifyDetails,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

            ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InvoiceFormScreen(),
      ),
    );
  },
  style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    backgroundColor: Colors.blue.shade200,
    foregroundColor: Colors.black,
  ),
  child: const Text(
    "Create Invoice",
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal,),
  ),
),
            ],
          ),
        ),
      ),
    );
  }
}