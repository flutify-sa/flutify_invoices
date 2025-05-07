// ignore_for_file: avoid_print, unused_import

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'invoice_details_screen.dart';

class InvoiceSaver {
  static Future<void> saveInvoice({
    required BuildContext context,
    required List<InvoiceItem> items,
    required DateTime invoiceDate,
    required DateTime dueDate,
    required String taxPercent,
    required String notes,
    required double subtotal,
    required double tax,
    required double total,
    required String customerName,
    required String customerEmail,
    required String customerMobile,
  }) async {
    try {
      print("Starting the invoice save process...");

      final pdf = pw.Document();

      // Add a page to the PDF
      print("Adding a page to the PDF...");
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Flutify Business Info
                pw.Text("Dmitri Dumas", style: const pw.TextStyle(fontSize: 12)),
                pw.Text("079 934 5962", style: const pw.TextStyle(fontSize: 12)),
                pw.Text("dmitri@flutify.co.za", style: const pw.TextStyle(fontSize: 12)),
                pw.Text("flutify.co.za", style: const pw.TextStyle(fontSize: 12)),
                pw.SizedBox(height: 8),
                pw.Text("Flutify (Pty) Ltd", style: const pw.TextStyle(fontSize: 12)),
                pw.Text("Registration Number: 2025/326018/07", style: const pw.TextStyle(fontSize: 12)),
                pw.Text("Taxpayer Ref No: 9470850224", style: const pw.TextStyle(fontSize: 12)),
                pw.SizedBox(height: 16),
                pw.Divider(),

                // Customer Info Section
                pw.Text("Bill To:", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.Text(customerName, style: const pw.TextStyle(fontSize: 12)),
                pw.Text(customerEmail, style: const pw.TextStyle(fontSize: 12)),
                pw.Text(customerMobile, style: const pw.TextStyle(fontSize: 12)),
                pw.SizedBox(height: 16),

                // Invoice Header
                pw.Text('Invoice', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Text('Invoice Date: ${invoiceDate.toLocal()}'),
                pw.Text('Due Date: ${dueDate.toLocal()}'),
                pw.Text('Tax Rate: $taxPercent%'),
                pw.SizedBox(height: 10),

                // Items
                pw.Text('Items:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 8),
                ...items.map(
                  (item) {
                    return pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Expanded(child: pw.Text(item.description)),
                        pw.Text('R${item.amount.toStringAsFixed(2)}'),
                      ],
                    );
                  },
                ),

                // Totals
                pw.SizedBox(height: 12),
                pw.Divider(),
                pw.Text('Subtotal: R${subtotal.toStringAsFixed(2)}'),
                pw.Text('Tax: R${tax.toStringAsFixed(2)}'),
                pw.Text(
                  'Total: R${total.toStringAsFixed(2)}',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),

                // Notes
                pw.SizedBox(height: 10),
                pw.Text('Notes: $notes'),
              ],
            );
          },
        ),
      );

      // Get file path
      final directory = await getApplicationDocumentsDirectory();
      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Invoice PDF',
        fileName: 'invoice.pdf',
        allowedExtensions: ['pdf'],
        type: FileType.custom,
        initialDirectory: directory.path,
      );

      if (result != null) {
        final file = File(result);
        await file.writeAsBytes(await pdf.save());

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invoice saved as PDF at $result')),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File save canceled')),
          );
        }
      }
    } catch (e, stackTrace) {
      print("Error during invoice save: $e\n$stackTrace");

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving invoice: $e')),
        );
      }
    }
  }
}
