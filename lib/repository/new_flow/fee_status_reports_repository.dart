import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/base_api_client.dart';
import 'package:lrsofficer/models/dashboard/dashboard_payload.dart';
import 'package:lrsofficer/models/new_flow/fee_status_report_response.dart';
import 'package:lrsofficer/res/constants/api_constants.dart';

class FeeStatusReportsRepository {
  final _baseApiClinet = BaseApiClient();
  Future<FeeStatusReportResponse?> feeStatusApi(
      BuildContext context, DashboardPayload payload) async {
    try {
      final token = CancelToken();
      final response = await _baseApiClinet.postCall(
          ApiConstants.feeStatusEndPoint, payload.toJson(), token);
      return FeeStatusReportResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }
}
