import 'package:flutter/material.dart';
import 'invoice_details_screen.dart'; // Import the new file
import 'custom_textfield.dart';

// Main invoice form widget
class InvoiceFormScreen extends StatefulWidget {
  const InvoiceFormScreen({super.key});

  @override
  State<InvoiceFormScreen> createState() => _InvoiceFormScreenState();
}

class _InvoiceFormScreenState extends State<InvoiceFormScreen> {
  // Controllers for customer info
  final _customerNameController = TextEditingController();
  final _customerMobileController = TextEditingController();
  final _customerEmailController = TextEditingController();

  // Lists for invoice items and dates
  List<InvoiceItem> items = [];
  DateTime _invoiceDate = DateTime.now();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  final _taxController = TextEditingController(text: "15");
  final _notesController = TextEditingController();
  final _itemDescController = TextEditingController();
  final _itemAmountController = TextEditingController();

  // Helper method to show a snackbar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Function to add an item to the invoice
  void _addItem() {
    final description = _itemDescController.text.trim();
    final amountText = _itemAmountController.text.trim();
    final amount = double.tryParse(amountText) ?? 0.0;

    if (description.isNotEmpty && amount > 0) {
      setState(() {
        items.add(InvoiceItem(description: description, amount: amount));
        _itemDescController.clear();
        _itemAmountController.clear();
      });
    } else {
      _showSnackBar("Please enter a valid description and amount.");
    }
  }

  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  // Function to pick a date
  Future<void> _pickDate({required bool isDue}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isDue ? _dueDate : _invoiceDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isDue) {
          _dueDate = picked;
        } else {
          _invoiceDate = picked;
        }
      });
    }
  }

  void _navigateToInvoiceDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvoiceDetailsScreen(
          items: items,
          invoiceDate: _invoiceDate,
          dueDate: _dueDate,
          taxController: _taxController,
          onPickDate: _pickDate,
          onRemoveItem: _removeItem,
          notesController: _notesController,
          itemDescController: _itemDescController,
          itemAmountController: _itemAmountController,
          onAddItem: _addItem,
          // Passing the customer info controllers as arguments
          customerNameController: _customerNameController,
          customerEmailController: _customerEmailController,
          customerMobileController: _customerMobileController,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of controllers to prevent memory leaks
    _customerNameController.dispose();
    _customerMobileController.dispose();
    _customerEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutify Invoice"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Customer Info Section
            const Text("Customer Info",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            CustomTextField(
              label: "Customer Name",
              hintText: "e.g. Jane Smith",
              controller: _customerNameController,
            ),
            CustomTextField(
              label: "Customer Mobile",
              hintText: "e.g. +27 82 987 6543",
              controller: _customerMobileController,
              keyboardType: TextInputType.phone,
            ),
            CustomTextField(
              label: "Customer Email",
              hintText: "e.g. jane@clientmail.com",
              controller: _customerEmailController,
              keyboardType: TextInputType.emailAddress,
            ),
            ElevatedButton(
              onPressed: _navigateToInvoiceDetails,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                backgroundColor: Colors.blue.shade200,
                foregroundColor: Colors.black,
              ),
              child: const Text("View Invoice Details"),
            ),
          ],
        ),
      ),
    );
  }
}
