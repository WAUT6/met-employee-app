import 'dart:typed_data';

import 'package:metapp/services/cloud/cloud_order_item.dart';
import 'package:metapp/utilities/pdf_converter/invoice.dart';
import 'package:pdf/pdf.dart';

class InvoicePDF {
  final Iterable<CloudOrderItem> items;
  final String customerName;

  const InvoicePDF({
    required this.items,
    required this.customerName,
  });
  Future<Uint8List> generateInvoice(
    PdfPageFormat pageFormat,
  ) async {
    final Invoice invoice = Invoice(
      baseColor: PdfColors.teal,
      accentColor: PdfColors.blueGrey800,
      items: items,
      customerName: customerName,
    );

    return await invoice.buildPdf(
      pageFormat: pageFormat,
    );
  }
}
