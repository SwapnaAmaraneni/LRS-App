import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/base_api_client.dart';
import 'package:lrsofficer/models/certifiedcopy_payload.dart';
import 'package:lrsofficer/models/certifiedcopy_response.dart';
import 'package:lrsofficer/models/get_certified_copy_response.dart';
import 'package:lrsofficer/res/constants/api_constants.dart';

class DownloadDocumentRepository {
  final _baseClient = BaseApiClient();
  Future<CertifiedCopyResponse?> downloadDocumentRepo(
      BuildContext context, CertifiedCopyPayload request) async {
    try {
      final token = CancelToken();
      final response = await _baseClient.postCallWithHeaders(
          ApiConstants.certifiedCopyEndpoint, request.toJson(), token);
      return CertifiedCopyResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<GetCertifiedCopyResponse?> apiDownloadDocumentRepo(
      BuildContext context, CertifiedCopyPayload request) async {
    try {
      final token = CancelToken();
      final response = await _baseClient.postCall(
          ApiConstants.getCertifiedCopy, request.toJson(), token);
      return GetCertifiedCopyResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }
}
