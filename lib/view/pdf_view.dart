import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/res/reusable_widgets/app_bar_reusable.dart';
import 'package:lrsofficer/utils/file_path_check_utils.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfView extends StatefulWidget {
  final String pdfUrl;
  final String title;
  const PdfView({super.key, required this.pdfUrl, required this.title});

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (!kReleaseMode) debugPrint("PDFURL:: ${widget.pdfUrl}");

    /* 
    File(pdfUrl).existsSync()
          ? SfPdfViewer.file(File(pdfUrl))
     */
    return Scaffold(
      appBar: AppBarReusable(title: widget.title),
      body: (widget.pdfUrl.startsWith("http"))
          ? SfPdfViewer.network(
              widget.pdfUrl,
              key: _pdfViewerKey,
              onDocumentLoadFailed: (details) {
                ErrorCustomCupertinoAlert().showAlert(
                  context,
                  message: "Cannot open document. ${details.description}",
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                );
              },
            )
          : (File(widget.pdfUrl).existsSync()
              ? SfPdfViewer.file(File(widget.pdfUrl))
              : (isValidBase64(widget.pdfUrl))
                  ? SfPdfViewer.memory(base64Decode(widget.pdfUrl),
                      key: _pdfViewerKey)
                  : Center(child: Text("File not found"))),
    );
  }
}
