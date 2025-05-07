// ignore_for_file: avoid_print

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'invoice_details_screen.dart'; // Import the correct file

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
                pw.Text('Invoice', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Text('Invoice Date: ${invoiceDate.toLocal()}'),
                pw.Text('Due Date: ${dueDate.toLocal()}'),
                pw.Text('Tax Rate: $taxPercent%'),
                pw.SizedBox(height: 10),
                pw.Text('Items:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ...items.map(
                  (item) {
                    print("Adding item: ${item.description} with amount: R${item.amount}");
                    return pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(item.description),
                        pw.Text('R${item.amount.toStringAsFixed(2)}'),
                      ],
                    );
                  },
                ),
                pw.SizedBox(height: 10),
                pw.Text('Subtotal: R${subtotal.toStringAsFixed(2)}'),
                pw.Text('Tax: R${tax.toStringAsFixed(2)}'),
                pw.Text('Total: R${total.toStringAsFixed(2)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Text('Notes: $notes'),
              ],
            );
          },
        ),
      );

      // Get file path from the user
      print("Attempting to save the file...");
      final directory = await getApplicationDocumentsDirectory();
      print("Got the application directory: ${directory.path}");

      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Invoice PDF',
        fileName: 'invoice.pdf',
        allowedExtensions: ['pdf'], // Specify PDF extension
        type: FileType.custom, // Set the file type to custom
        initialDirectory: directory.path,
      );

      if (result != null) {
        print("User selected file path: $result");

        final file = File(result);
        await file.writeAsBytes(await pdf.save());

        // Only show snackbar if the context is still valid
        if (context.mounted) {
          print("Invoice saved successfully, showing snackbar...");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invoice saved as PDF at $result')),
          );
        }
      } else {
        print("User canceled the file save operation.");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File save canceled')),
          );
        }
      }
    } catch (e, stackTrace) {
      print("Error during invoice save: $e");
      print("Stack trace: $stackTrace");

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving invoice: $e')),
        );
      }
    }
  }
}
