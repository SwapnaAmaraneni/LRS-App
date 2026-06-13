import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:lrsofficer/res/constants/api_constants.dart';

String getNormalizedPath(String? value) {
  final urlPattern = r'^(http|https):\/\/([\w.]+\/?)\S*';

  if (value == null || value.isEmpty) return "";

  // Case 1: Local file (absolute path must exist)
  final file = File(value);
  if (file.existsSync()) {
    return file.path;
  }

  // Case 2: Full URL or relative URL
  if (value.isNotEmpty) {
    final regex = RegExp(urlPattern);
    if (regex.hasMatch(value)) {
      // Full URL
      return value;
    } else {
      // Relative URL → build full URL
      return value;
    }
  }
  // Case 3: Invalid → return ""
  return "";
}

/// Checks if a given string looks like a Base64 encoded image
bool isBase64Image(String data) {
  try {
    final decoded = base64Decode(data);
    return decoded.isNotEmpty;
  } catch (_) {
    return false;
  }
}

/// 🔹 Helper to process either a base64 string, URL, or local file
Future<String> processFileOrUrl(String? fileOrUrl) async {
  if (fileOrUrl == null || fileOrUrl.isEmpty) return "";

  // 1️⃣ Already Base64 → return as is
  if (isValidBase64(fileOrUrl)) return fileOrUrl;

  // 2️⃣ Full URL → return as is
  if (fileOrUrl.startsWith("http")) return fileOrUrl;

  // 3️⃣ Local file → convert to Base64
  final localFile = File(fileOrUrl);
  if (localFile.existsSync()) {
    try {
      return base64Encode(await localFile.readAsBytes());
    } catch (e) {
      if (!kReleaseMode) debugPrint("Error reading local file: $e");
      return "";
    }
  }

  // 4️⃣ Partial server path → prepend base URL
  // Make sure your API expects something like: GET https://server/GetFile?fileName=partialPath
  final normalizedPath = fileOrUrl.replaceAll("\\", "/"); // normalize slashes
  return "${ApiConstants.filesImagesBaseUrl}GetFile?fileName=$normalizedPath";
}

/// 🔹 Wrapper to process images
Future<String> processImage(String img) async => await processFileOrUrl(img);

String setCompleteUrl(String? docPath) {
  if (docPath == null || docPath.isEmpty) return "";

  // Case 1: Local file (absolute path must exist)
  final file = File(docPath);
  if (file.existsSync()) {
    return file.path;
  }

  if (isValidBase64(docPath)) {
    return docPath; // Return as is if it's a valid Base64 string
  }

  // Case 2: Full URL or relative URL
  if (docPath.isNotEmpty) {
    final urlPattern = r'^(http|https):\/\/([\w.]+\/?)\S*';

    final regex = RegExp(urlPattern);
    if (regex.hasMatch(docPath)) {
      // Full URL
      return docPath;
    } else {
      // Relative URL → build full URL
      return "${ApiConstants.filesImagesBaseUrl}GetFile?fileName=$docPath";
    }
  }
  return "";
}

bool isValidBase64(String? base64String) {
  if (base64String == null || base64String.isEmpty) {
    return false;
  }
  try {
    base64Decode(base64String);
    return true;
  } catch (e) {
    return false;
  }
}
