import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../services/cloud/firebase/cloud_order_item.dart';

class Invoice {
  final PdfColor baseColor;
  final PdfColor accentColor;
  final Iterable<CloudOrderItem> items;
  final String customerName;

  Invoice({
    required this.baseColor,
    required this.accentColor,
    required this.items,
    required this.customerName,
  });

  static const PdfColor _darkColor = PdfColors.blueGrey800;
  static const PdfColor _lightColor = PdfColors.white;

  PdfColor get _baseTextColor => baseColor.isLight ? _lightColor : _darkColor;
  // PdfColor get _accentTextColor =>
  //     accentColor.isLight ? _lightColor : _darkColor;

  Future<Uint8List> buildPdf({
    required PdfPageFormat pageFormat,
  }) async {
    final doc = pw.Document();

    final font = await rootBundle.load("assets/fonts/OpenSans-Regular.ttf");
    final ttf = pw.Font.ttf(font);
    final fontBold = await rootBundle.load("assets/fonts/OpenSans-Bold.ttf");
    final ttfBold = pw.Font.ttf(fontBold);
    final fontItalic =
        await rootBundle.load("assets/fonts/OpenSans-Italic.ttf");
    final ttfItalic = pw.Font.ttf(fontItalic);

    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildTheme(
          pageFormat,
          ttf,
          ttfBold,
          ttfItalic,
        ),
        build: (context) {
          return [
            _contentTable(context),
          ];
        },
      ),
    );
    return await doc.save();
  }

  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = [
      'ID#',
      'Item Name',
      'Packaging',
      'Quantity',
    ];
    return pw.TableHelper.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: baseColor,
      ),
      headerHeight: 25,
      cellHeight: 40,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.center,
      },
      headerStyle: pw.TextStyle(
        color: _baseTextColor,
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: _darkColor,
        fontSize: 10,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: accentColor,
            width: .5,
          ),
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        items.length,
        (row) => List<String>.generate(
          tableHeaders.length,
          (col) => items.toList()[row].getIndex(col),
        ),
      ),
    );
  }
}

pw.PageTheme _buildTheme(
    PdfPageFormat pageFormat, pw.Font base, pw.Font bold, pw.Font italic) {
  return pw.PageTheme(
    pageFormat: pageFormat,
    theme: pw.ThemeData.withFont(
      base: base,
      bold: bold,
      italic: italic,
    ),
  );
}
