import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/models/version_check/version_check_response.dart';
import '../data/base_api_client.dart';
import '../res/constants/api_constants.dart';

class SplashRepository {
  final _baseApiClinet = BaseApiClient();
  Future<VersionCheckResponse?> versionCheckRepo(BuildContext context) async {
    try {
      String? platformType;
      if (Platform.isAndroid) {
        platformType = "android";
      } else if (Platform.isIOS) {
        platformType = "ios";
      }
      final token = CancelToken();

      final response = await _baseApiClinet.getCallWithNoPayload(context,
          ApiConstants.versionCheckEndPoint, {"Type": platformType}, token);
      return VersionCheckResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }
}
