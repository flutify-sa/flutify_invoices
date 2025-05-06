import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Helper function for currency formatting
String formatCurrency(double amount) {
  final currencyFormatter = NumberFormat.currency(locale: 'en_ZA', symbol: 'R');
  return currencyFormatter.format(amount);
}

// Custom text field widget
class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int? maxLines;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.keyboardType,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hintText,
              border: const OutlineInputBorder(),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// Invoice item tile widget
class InvoiceItemTile extends StatelessWidget {
  final InvoiceItem item;
  final VoidCallback onRemove;

  const InvoiceItemTile({super.key, required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(item.description)),
          const SizedBox(width: 16),
          Text(formatCurrency(item.amount)),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onRemove,
            iconSize: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          )
        ],
      ),
    );
  }
}

// Invoice item data class
class InvoiceItem {
  String description; // Changed to non-final to allow editing
  double amount; // Changed to non-final to allow editing

  InvoiceItem({required this.description, required this.amount});

  @override
  String toString() {
    return 'InvoiceItem{description: $description, amount: $amount}';
  }
}

// Main invoice form widget
class InvoiceFormScreen extends StatefulWidget {
  const InvoiceFormScreen({super.key});

  @override
  State<InvoiceFormScreen> createState() => _InvoiceFormScreenState();
}

class _InvoiceFormScreenState extends State<InvoiceFormScreen> {
  // Static company details


  // Controllers for customer info, tax, and notes
  final _customerNameController = TextEditingController();
  final _customerMobileController = TextEditingController();
  final _customerEmailController = TextEditingController();
  final _taxController = TextEditingController(text: "15");
  final _notesController = TextEditingController();

  // Controllers for item description and amount
  final _itemDescController = TextEditingController();
  final _itemAmountController = TextEditingController();

  // Lists for invoice items and dates
  List<InvoiceItem> items = [];
  DateTime _invoiceDate = DateTime.now();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));

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
      _showSnackBar("Please enter a valid description and amount."); // Show message
    }
  }

  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  // Getters for calculated values
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.amount);
  double get tax => subtotal * (double.tryParse(_taxController.text) ?? 0) / 100;
  double get total => subtotal + tax;

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

  // Function to save the invoice (not implemented)
  void _saveInvoice() {
    _showSnackBar("Invoice saved (not implemented)");
  }

  // Function to share the invoice (not implemented)
  void _shareInvoice() {
    _showSnackBar("Invoice shared (not implemented)");
  }

  @override
  void dispose() {
    // Dispose of controllers to prevent memory leaks
    _customerNameController.dispose();
    _customerMobileController.dispose();
    _customerEmailController.dispose();
    _taxController.dispose();
    _notesController.dispose();
    _itemDescController.dispose();
    _itemAmountController.dispose();
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
            const Text("Customer Info", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
            const SizedBox(height: 16),

            // Invoice Details Section
            const Text("Invoice Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text("Invoice Date"),
                    subtitle: Text(DateFormat('yyyy-MM-dd').format(_invoiceDate)),
                    onTap: () => _pickDate(isDue: false),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text("Due Date"),
                    subtitle: Text(DateFormat('yyyy-MM-dd').format(_dueDate)),
                    onTap: () => _pickDate(isDue: true),
                  ),
                ),
              ],
            ),
            const Divider(),

            // Add Item Section
             const Text("Add Item", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            CustomTextField(
              label: "Description",
              hintText: "e.g. Logo design, Web development...",
              controller: _itemDescController,
              maxLines: 4,
            ),
            CustomTextField(
              label: "Amount (ZAR)",
              hintText: "e.g. 1500.00",
              controller: _itemAmountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            ElevatedButton(
              onPressed: _addItem,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("Add Item"),
            ),
            const SizedBox(height: 10),

            // Display Items
            if (items.isNotEmpty) ...[
              const Text("Invoice Items", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Column(
                children: items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return InvoiceItemTile(
                    item: item,
                    onRemove: () => _removeItem(index),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 16),

            // Tax and Total Section
            CustomTextField(
              label: "Tax (%)",
              hintText: "e.g. 15",
              controller: _taxController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Subtotal: ${formatCurrency(subtotal)}"),
                  Text("Tax: ${formatCurrency(tax)}"),
                  Text(
                    "Total: ${formatCurrency(total)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // Notes Section
            const SizedBox(height: 20),
            CustomTextField(
              label: "Notes",
              hintText: "e.g. Thank you for your business!",
              controller: _notesController,
              maxLines: 4,
            ),
            const SizedBox(height: 20),

            // Save and Share Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _saveInvoice,
                  icon: const Icon(Icons.save),
                  label: const Text("Save"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _shareInvoice,
                  icon: const Icon(Icons.share),
                  label: const Text("Share"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

