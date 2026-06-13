import 'dart:convert';
import 'dart:io';

String convertToBase64(String? path) {
  if (path == null || path.isEmpty) {
    return ""; // Return an empty string or handle this case as needed
  }

  final file = File(path);
  if (!file.existsSync()) {
    return ""; // File does not exist, handle this case as needed
  }

  final bytes = file.readAsBytesSync();
  return base64Encode(bytes);
}
