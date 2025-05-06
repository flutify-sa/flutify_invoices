import 'package:flutter/material.dart';
import 'first_invoice_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Static Flutify details
    final String flutifyDetails = '''
Flutify (Pty) Ltd
Registration Number: 2025/326018/07
Taxpayer Ref No: 9470850224''';

    return Scaffold(backgroundColor: Colors.indigo.shade100,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Text(
                'flutify.co.za',
                style: const TextStyle(fontSize: 32), 
                textAlign: TextAlign.center, 
              ),
              const SizedBox(height: 20),
  Text(
                'Invoice Generator',
                style: const TextStyle(fontSize: 24), 
                textAlign: TextAlign.center, 
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/valknut.png',
                height: 150,
              ),
              const SizedBox(height: 20),

              // Display Flutify details
              Text(
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
    backgroundColor: Colors.indigo.shade200,
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

