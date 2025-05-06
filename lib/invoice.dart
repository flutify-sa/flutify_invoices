class InvoiceItem {
  String description;
  double amount;

  InvoiceItem({required this.description, required this.amount});
}

class Invoice {
  String company;
  String name;
  String mobile;
  String email;

  String customerName;
  String customerMobile;
  String customerEmail;

  DateTime invoiceDate;
  DateTime dueDate;

  List<InvoiceItem> items;
  double taxPercent;
  String notes;

  Invoice({
    required this.company,
    required this.name,
    required this.mobile,
    required this.email,
    required this.customerName,
    required this.customerMobile,
    required this.customerEmail,
    required this.invoiceDate,
    required this.dueDate,
    required this.items,
    required this.taxPercent,
    required this.notes,
  });

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.amount);
  double get taxAmount => subtotal * (taxPercent / 100);
  double get total => subtotal + taxAmount;
}
