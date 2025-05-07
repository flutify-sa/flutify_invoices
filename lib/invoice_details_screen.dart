import 'package:flutify_invoice/invoice_saver.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'custom_textfield.dart'; // Import the new file

// Helper function for currency formatting
String formatCurrency(double amount) {
  final currencyFormatter = NumberFormat.currency(locale: 'en_ZA', symbol: 'R');
  return currencyFormatter.format(amount);
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
  String description;
  double amount;

  InvoiceItem({required this.description, required this.amount});

  @override
  String toString() {
    return 'InvoiceItem{description: $description, amount: $amount}';
  }
}

class InvoiceDetailsScreen extends StatefulWidget {
  final List<InvoiceItem> items;
  final DateTime invoiceDate;
  final DateTime dueDate;
  final TextEditingController taxController;
  final void Function({required bool isDue}) onPickDate;
  final void Function(int index) onRemoveItem;
  final TextEditingController notesController;
  final TextEditingController itemDescController;
  final TextEditingController itemAmountController;
  final void Function() onAddItem;

  const InvoiceDetailsScreen({
    super.key,
    required this.items,
    required this.invoiceDate,
    required this.dueDate,
    required this.taxController,
    required this.onPickDate,
    required this.onRemoveItem,
    required this.notesController,
    required this.itemDescController,
    required this.itemAmountController,
    required this.onAddItem,
  });

  @override
  State<InvoiceDetailsScreen> createState() => _InvoiceDetailsScreenState();
}

class _InvoiceDetailsScreenState extends State<InvoiceDetailsScreen> {
  // Getters for calculated values
  double get _subtotal =>
      widget.items.fold(0.0, (sum, item) => sum + item.amount);
  double get _tax =>
      _subtotal * (double.tryParse(widget.taxController.text) ?? 0) / 100;
  double get _total => _subtotal + _tax;

 void _saveInvoice() {
  InvoiceSaver.saveInvoice(
    context: context,
    items: widget.items,
    invoiceDate: widget.invoiceDate,
    dueDate: widget.dueDate,
    taxPercent: widget.taxController.text,
    notes: widget.notesController.text,
    subtotal: _subtotal,
    tax: _tax,
    total: _total,
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Invoice Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Invoice Details Section
              const Text("Invoice Details",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text("Invoice Date"),
                      subtitle: Text(DateFormat('yyyy-MM-dd')
                          .format(widget.invoiceDate)),
                      onTap: () => widget.onPickDate(isDue: false),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text("Due Date"),
                      subtitle:
                          Text(DateFormat('yyyy-MM-dd').format(widget.dueDate)),
                      onTap: () => widget.onPickDate(isDue: true),
                    ),
                  ),
                ],
              ),
              const Divider(),
              // Add Item Section
              const Text("Add Item",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              CustomTextField(
                label: "Description",
                hintText: "e.g. Logo design, Web development...",
                controller: widget.itemDescController,
                maxLines: 2,
              ),
              CustomTextField(
                label: "Amount (ZAR)",
                hintText: "e.g. 1500.00",
                controller: widget.itemAmountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              ElevatedButton(
                onPressed: widget.onAddItem,
             style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    backgroundColor: Colors.blue.shade200,
    foregroundColor: Colors.black,
  ),
                child: const Text("Add Item"),
              ),
              const SizedBox(height: 10),
              // Display Items
              if (widget.items.isNotEmpty) ...[
                const Text("Invoice Items",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Column(
                  children: widget.items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return InvoiceItemTile(
                      item: item,
                      onRemove: () => widget.onRemoveItem(index),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 16),
              // Tax and Total Section
              CustomTextField(
                label: "Tax (%)",
                hintText: "e.g. 15",
                controller: widget.taxController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) {
                  // Use a local setState to rebuild this widget when tax changes.
                  setState(() {});
                },
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Subtotal: ${formatCurrency(_subtotal)}"),
                    Text("Tax: ${formatCurrency(_tax)}"),
                    Text(
                      "Total: ${formatCurrency(_total)}",
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
                controller: widget.notesController,
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              // Save Button
              ElevatedButton.icon(
                onPressed: _saveInvoice,
                icon: const Icon(Icons.save),
                label: const Text("Save"),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  backgroundColor: Colors.blue.shade200,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}