import 'package:flutter/material.dart';

class InvoiceItemTile extends StatelessWidget {
  final String description;
  final double amount;

  const InvoiceItemTile({
    super.key,
    required this.description,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(description),
      trailing: Text("R ${amount.toStringAsFixed(2)}"),
    );
  }
}
