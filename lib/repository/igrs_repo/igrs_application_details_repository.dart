import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/base_api_client.dart';
import 'package:lrsofficer/models/cluster_application_details_request.dart';
import 'package:lrsofficer/models/saved_applications/saved_application_details_response.dart';
import 'package:lrsofficer/res/constants/api_constants.dart';

class IGRSApplicationDetailsRepository {
  final _baseClient = BaseApiClient();
  Future<SavedApplicationDetailsResponse?> applicationDetailsApi(
      BuildContext context, ClusterApplicationDetailsRequest request) async {
    try {
      final token = CancelToken();
      final response = await _baseClient.postCall(
          ApiConstants.igrsApplicationDetails, request.toJson(), token);
      return SavedApplicationDetailsResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }
}
