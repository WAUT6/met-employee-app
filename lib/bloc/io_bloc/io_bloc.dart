import 'dart:io';

import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metapp/bloc/io_bloc/io_events.dart';
import 'package:metapp/bloc/io_bloc/io_states.dart';
import 'package:metapp/utilities/pdf_converter/invoice_pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';

class IoBloc extends Bloc<IoEvent, IoState> {
  IoBloc() : super(const IoStateInitialized()) {
    on<IoEventWantsToDownloadOrderAsPdf>(
      (event, emit) async {
        emit(const IoStateDownloadingPdf());
        try {
          final InvoicePDF invoiceInstance = InvoicePDF(
            items: event.items,
            customerName: event.customerName,
          );
          final pdfFile =
              await invoiceInstance.generateInvoice(PdfPageFormat.a4);

          final directory = await getExternalStorageDirectory();
          final file = File("${directory?.path}/${event.customerName}.pdf");
          final fileWritten = await file.writeAsBytes(pdfFile);
          final data = fileWritten.readAsBytesSync();
          final DocumentFileSavePlus saver = DocumentFileSavePlus();
          saver.saveFile(
            data,
            '${event.customerName}.pdf',
            'appliation/pdf',
          );

          emit(
            const IoStateInitialized(),
          );
        } catch (e) {
          emit(const IoStateInitialized());
        }
      },
    );

    on<IoEventWantsToShareOrderAsPdf>(
      (event, emit) async {
        try {
          final invoice = InvoicePDF(
            items: event.items,
            customerName: event.customerName,
          );

          final pdfFile = await invoice.generateInvoice(PdfPageFormat.a4);
          final directory = await getExternalStorageDirectory();
          final file = File("${directory?.path}/${event.customerName}.pdf");
          final fileWritten = await file.writeAsBytes(pdfFile);
          emit(
            IoStateAwaitingUserSelection(pdf: fileWritten),
          );
        } catch (e) {
          emit(const IoStateInitialized());
        }
      },
    );
  }
}
