import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/base_api_client.dart';
import 'package:lrsofficer/models/dashboard/dashboard_payload.dart';
import 'package:lrsofficer/models/new_flow/fifp_applications_list_response.dart';
import 'package:lrsofficer/models/new_flow/remarks_submit_payload.dart';
import 'package:lrsofficer/models/new_flow/remarks_submit_response.dart';
import 'package:lrsofficer/res/constants/api_constants.dart';

class FeeInitimatedUnpaidRepository {
  final _baseApiClinet = BaseApiClient();
  Future<FifpApplicationsListResponse?> feeIntimatedUnpaidApi(
      BuildContext context, DashboardPayload payload) async {
    try {
      final token = CancelToken();
      final response = await _baseApiClinet.postCall(
          ApiConstants.feeIntimatedEndPoint, payload.toJson(), token);
      return FifpApplicationsListResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<SubmitFeeIntimatedRemarksResponse?> remarksSubmitRepo(
      BuildContext context, SubmitFeeIntimatedRemarksPayload payload) async {
    try {
      final token = CancelToken();
      final response = await _baseApiClinet.postCall(
          ApiConstants.remarksSubmit, payload.toJson(), token);
      return SubmitFeeIntimatedRemarksResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }
}
