import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/base_api_client.dart';
import 'package:lrsofficer/models/cluster_application_details_request.dart';
import 'package:lrsofficer/models/cluster_application_details_response.dart';
import 'package:lrsofficer/models/cluster_wise_appl_list_request.dart';
import 'package:lrsofficer/models/cluster_wise_appl_list_response.dart';
import 'package:lrsofficer/res/constants/api_constants.dart';

class ShortfallApplDetailsRepository {
  final _baseClient = BaseApiClient();
  Future<ClusterApplicationDetailsResponse?> shortfallApplDetailsRepo(
      BuildContext context, ClusterApplicationDetailsRequest request) async {
    try {
      final token = CancelToken();
      final response = await _baseClient.postCall(
          ApiConstants.applicationDetailsPrhibited, request.toJson(), token);
      return ClusterApplicationDetailsResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<ClusterwiseApplicationListResponse?> shortfallApplListRepo(
      BuildContext context, ClusterwiseApplicationListRequest request) async {
    try {
      final token = CancelToken();
      final response = await _baseClient.postCall(
          ApiConstants.clusterwiseApplicationListProhibited,
          request.toJson(),
          token);
      return ClusterwiseApplicationListResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }
}
