import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/models/dashboard/dashboard_payload.dart';
import 'package:lrsofficer/models/dashboard/dashboard_response.dart';
import 'package:lrsofficer/res/constants/api_constants.dart';
import '../data/base_api_client.dart';

class DashboardRepository {
  final _baseApiClinet = BaseApiClient();
  Future<DashboardResponse?> dashboardRepo(
      BuildContext context, DashboardPayload payload) async {
    try {
      final token = CancelToken();
      final response = await _baseApiClinet.postCall(
        ApiConstants.dynamicMenuNew,
        payload.toJson(),
        token,
      );
      return DashboardResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }
}
