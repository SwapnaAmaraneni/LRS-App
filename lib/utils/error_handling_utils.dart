import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../res/CustomAlerts/custom_error_alert.dart';

class ErrorHandlingUtils {
  static String handleError(dynamic e, BuildContext context) {
    String msg = "";
    if (e is DioException) {
      if (e.type == DioExceptionType.badResponse) {
        final responseBody = e.response?.data;
        if (responseBody != null) {
          final jsonData = json.encode(responseBody);
          msg = getErrorMessage(jsonData);
        }
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        msg = "Connection timed out";
      } else {
        msg = "Something went wrong, Please try again later";
      }
    } else if (e is SocketException) {
      msg = "Something went wrong, Please try again later";
    } else {
      msg = "Something went wrong, Please try again later";
    }
    return msg;
  }

  static String getErrorMessage(String jsonData) {
    try {
      final parsedJson = json.decode(jsonData);
      return parsedJson['error']['message'];
    } catch (e) {
      return "Something went wrong, Please try again later";
    }
  }

  void showErrorDialog(BuildContext context, String errorMessage,
      {void Function()? onPressed}) {
    return ErrorCustomCupertinoAlert().showAlert(
      context,
      message: errorMessage,
      onPressed: onPressed ??
          () {
            Navigator.pop(context);
          },
    );
  }
}
