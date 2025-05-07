// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutify_invoice/invoice_details_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart'; // Import for date formatting


// Function to save invoice data to a file
Future<void> saveInvoice(
  List<InvoiceItem> items,
  DateTime invoiceDate,
  DateTime dueDate,
  String tax,
  String notes,
  String customerName, // Add customer name
  String customerMobile, // Add customer mobile
  String customerEmail, // Add customer email
) async {
  try {
    // 1. Get the directory:
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/invoice_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.txt');

    // 2. Format the data:
    String formattedInvoice = '';
    formattedInvoice += "Customer Name: $customerName\n";
    formattedInvoice += "Customer Mobile: $customerMobile\n";
    formattedInvoice += "Customer Email: $customerEmail\n";
    formattedInvoice += "Invoice Date: ${DateFormat('yyyy-MM-dd').format(invoiceDate)}\n";
    formattedInvoice += "Due Date: ${DateFormat('yyyy-MM-dd').format(dueDate)}\n";
    formattedInvoice += "--------------------------------------------------------\n";
    formattedInvoice += "Items:\n";
    for (var item in items) {
      formattedInvoice += "  ${item.description} - ${formatCurrency(item.amount)}\n";
    }
    formattedInvoice += "--------------------------------------------------------\n";
    formattedInvoice += "Subtotal: ${formatCurrency(calculateSubtotal(items))}\n";
    formattedInvoice += "Tax ($tax%): ${formatCurrency(calculateTax(items, tax))}\n";
    formattedInvoice += "Total: ${formatCurrency(calculateTotal(items, tax))}\n";
    formattedInvoice += "--------------------------------------------------------\n";
    formattedInvoice += "Notes: $notes\n";

    // 3. Write the data to the file:
    await file.writeAsString(formattedInvoice);

    print('Invoice saved to ${file.path}'); 
  } catch (e) {
    print('Error saving invoice: $e');
    throw Exception('Failed to save invoice: $e'); 
  }
}

// Helper Functions
String formatCurrency(double amount) {
  final currencyFormatter = NumberFormat.currency(locale: 'en_ZA', symbol: 'R');
  return currencyFormatter.format(amount);
}

double calculateSubtotal(List<InvoiceItem> items) {
  double subtotal = 0.0;
  for (var item in items) {
    subtotal += item.amount;
  }
  return subtotal;
}

double calculateTax(List<InvoiceItem> items, String tax) {
  final subtotal = calculateSubtotal(items);
  final taxValue = double.tryParse(tax) ?? 0.0;
  return subtotal * taxValue / 100;
}

double calculateTotal(List<InvoiceItem> items, String tax) {
  return calculateSubtotal(items) + calculateTax(items, tax);
}
