import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'invoice.dart';
import 'custom_text_field.dart';
import 'invoice_item_tile.dart';

class InvoiceFormScreen extends StatefulWidget {
  const InvoiceFormScreen({super.key});

  @override
  State<InvoiceFormScreen> createState() => _InvoiceFormScreenState();
}

class _InvoiceFormScreenState extends State<InvoiceFormScreen> {
  final _companyController = TextEditingController();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();

  final _customerNameController = TextEditingController();
  final _customerMobileController = TextEditingController();
  final _customerEmailController = TextEditingController();

  final _taxController = TextEditingController(text: "15");
  final _notesController = TextEditingController();

  final _itemDescController = TextEditingController();
  final _itemAmountController = TextEditingController();

  List<InvoiceItem> items = [];

  DateTime _invoiceDate = DateTime.now();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));

  final _currencyFormatter = NumberFormat.currency(locale: 'en_ZA', symbol: 'R');

  void _addItem() {
    final description = _itemDescController.text.trim();
    final amount = double.tryParse(_itemAmountController.text) ?? 0.0;

    if (description.isEmpty || amount <= 0) return;

    setState(() {
      items.add(InvoiceItem(description: description, amount: amount));
      _itemDescController.clear();
      _itemAmountController.clear();
    });
  }

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.amount);
  double get tax => subtotal * (double.tryParse(_taxController.text) ?? 0) / 100;
  double get total => subtotal + tax;

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

  void _saveInvoice() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Invoice saved (not implemented)")),
    );
  }

  void _shareInvoice() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Invoice shared (not implemented)")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutify Invoice"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              'assets/valknut.png',
              fit: BoxFit.contain,
              height: 50,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("From", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            CustomTextField(
              label: "My Company",
              hintText: "e.g. Flutify Solutions",
              controller: _companyController,
            ),
            CustomTextField(
              label: "My Name",
              hintText: "e.g. John Doe",
              controller: _nameController,
            ),
            CustomTextField(
              label: "My Mobile",
              hintText: "e.g. +27 71 234 5678",
              controller: _mobileController,
              keyboardType: TextInputType.phone,
            ),
            CustomTextField(
              label: "My Email",
              hintText: "e.g. john@example.com",
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

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
            const Text("Add Item", style: TextStyle(fontWeight: FontWeight.bold)),
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

            if (items.isNotEmpty)
              ...items.map((item) => InvoiceItemTile(description: item.description, amount: item.amount)),

            const SizedBox(height: 16),
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
                  Text("Subtotal: ${_currencyFormatter.format(subtotal)}"),
                  Text("Tax: ${_currencyFormatter.format(tax)}"),
                  Text(
                    "Total: ${_currencyFormatter.format(total)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            CustomTextField(
              label: "Notes",
              hintText: "e.g. Thank you for your business!",
              controller: _notesController,
              maxLines: 4,
            ),
            const SizedBox(height: 20),
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
