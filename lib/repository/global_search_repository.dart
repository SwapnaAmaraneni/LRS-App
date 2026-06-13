import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/base_api_client.dart';
import 'package:lrsofficer/models/dashboard/dashboard_payload.dart';
import 'package:lrsofficer/models/global_search/global_search_masters_response.dart';
import 'package:lrsofficer/models/global_search/global_search_officer_details_payload.dart';
import 'package:lrsofficer/models/global_search/global_search_officer_details_response.dart';
import 'package:lrsofficer/models/global_search/global_search_payload.dart';
import 'package:lrsofficer/models/global_search/global_search_response.dart';
import 'package:lrsofficer/res/constants/api_constants.dart';

class GlobalSearchRepository {
  final _baseClient = BaseApiClient();
  Future<GetGlobalSearchMastersResponse?> getGlobalSearchMastersApi(
      BuildContext context, DashboardPayload request) async {
    try {
      final token = CancelToken();
      final response = await _baseClient.postCall(
          ApiConstants.globalSearchMasters, request.toJson(), token);
      return GetGlobalSearchMastersResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<GlobalSearchResponse?> globalSearchApi(
      BuildContext context, GlobalSearchPayload request) async {
    try {
      final token = CancelToken();
      final response = await _baseClient.postCall(
          ApiConstants.globalSearch, request.toJson(), token);
      return GlobalSearchResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<GlobalSearchOfficerDetailsResponse?> globalSearchOfficerListApi(
      BuildContext context, GlobalSearchOfficerDetailsPayload request) async {
    try {
      final token = CancelToken();
      final response = await _baseClient.postCall(
          ApiConstants.globalSearchOfficersList, request.toJson(), token);
      return GlobalSearchOfficerDetailsResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }
}
