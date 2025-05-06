import 'package:flutter/material.dart';

// Customer Info Widget
class CustomerInfoSection extends StatelessWidget {
  final TextEditingController customerNameController;
  final TextEditingController customerMobileController;
  final TextEditingController customerEmailController;

  const CustomerInfoSection({super.key, 
    required this.customerNameController,
    required this.customerMobileController,
    required this.customerEmailController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Customer Info", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        CustomTextField(
          label: "Customer Name",
          hintText: "e.g. Jane Smith",
          controller: customerNameController,
        ),
        CustomTextField(
          label: "Customer Mobile",
          hintText: "e.g. +27 82 987 6543",
          controller: customerMobileController,
          keyboardType: TextInputType.phone,
        ),
        CustomTextField(
          label: "Customer Email",
          hintText: "e.g. jane@clientmail.com",
          controller: customerEmailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
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
