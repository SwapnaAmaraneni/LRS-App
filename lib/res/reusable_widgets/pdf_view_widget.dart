import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:lrsofficer/data/base_api_client.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/utils/file_path_check_utils.dart';
import 'package:lrsofficer/view/pdf_view.dart';

class BuildDocumentView extends StatelessWidget {
  const BuildDocumentView({
    super.key,
    required this.title,
    required this.pdfUrl,
  });

  final String title;
  final String pdfUrl; // can be local path OR remote half-path

  Future<void> _openDocument(BuildContext context) async {
    if (pdfUrl.isEmpty) {
      ErrorCustomCupertinoAlert()
          .showAlert(context, message: "Invalid PDF URL");
      return;
    }

    String filePathOrUrl = pdfUrl;

    // ✅ Case 1: Local file (directly exists on device)
    if (File(filePathOrUrl).existsSync()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfView(
            pdfUrl: filePathOrUrl,
            title: title,
          ),
        ),
      );
      return;
    }

    //case 2 is base64
    if (isValidBase64(filePathOrUrl)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfView(
            pdfUrl: filePathOrUrl,
            title: title,
          ),
        ),
      );
      return;
    }

    try {
      final response = await BaseApiClient().getFile(
        pdfUrl,
        CancelToken(),
      );

      if (response.statusCode == 200) {
        if (!context.mounted) return;
        final fullUrl = response.realUri.toString();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfView(
              pdfUrl: fullUrl,
              title: title,
            ),
          ),
        );
      } else {
        if (!context.mounted) return;
        ErrorCustomCupertinoAlert()
            .showAlert(context, message: "File not available on server");
      }
    } on DioException catch (e) {
      String userMessage = "Something went wrong while loading the file.";

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        userMessage = "Connection timed out. Please try again.";
      } else if (e.type == DioExceptionType.badResponse) {
        userMessage = "Server returned an error. Please try later.";
      } else if (e.type == DioExceptionType.cancel) {
        userMessage = "Request was cancelled.";
      } else if (e.error is SocketException) {
        userMessage = "No Internet connection. Please check your network.";
      }

      // Log actual error for developers
      if (!kReleaseMode) {
        debugPrint("DioException: ${e.message} | StackTrace: ${e.stackTrace}");
      }

      // Show user-friendly alert
      ErrorCustomCupertinoAlert().showAlert(
        context,
        message: userMessage,
      );
    } catch (e, stackTrace) {
      // Log unexpected errors
      if (!kReleaseMode) debugPrint("Unexpected error: $e\n$stackTrace");

      // Show safe message to user
      ErrorCustomCupertinoAlert().showAlert(
        context,
        message: "Unexpected error occurred. Please try again.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 2, child: Text(title)),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _openDocument(context),
                child: const Text('View'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
