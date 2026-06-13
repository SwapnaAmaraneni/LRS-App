import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/base_api_client.dart';
import 'package:lrsofficer/models/dashboard/dashboard_payload.dart';
import 'package:lrsofficer/models/igrs/igrs_application_response_model.dart';
import 'package:lrsofficer/res/constants/api_constants.dart';

class IGRSApplicationsListRepository {
  final _baseApiClinet = BaseApiClient();
  Future<IGRSApplicationResponseModel?> igrsApplicationApi(
      BuildContext context, DashboardPayload payload) async {
    try {
      final token = CancelToken();
      final response = await _baseApiClinet.postCall(
          ApiConstants.igrsApplicationList, payload.toJson(), token);
      return IGRSApplicationResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }
}
