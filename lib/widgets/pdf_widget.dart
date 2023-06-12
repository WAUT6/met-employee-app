import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:metapp/utilities/generics/get_arguments.dart';

class PdfWidget extends StatelessWidget {
  const PdfWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final url = context.getArgument<String>() as String;
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: const PDF().fromUrl(
        url,
        placeholder: (double progress) => Center(child: Text('$progress %')),
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      ),
    );
  }
}
