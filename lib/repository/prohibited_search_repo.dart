import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/base_api_client.dart';
import 'package:lrsofficer/models/cluster_wise_appl_list_response.dart';
import 'package:lrsofficer/models/search_payload.dart';
import 'package:lrsofficer/res/constants/api_constants.dart';

class ProhibitedSearchApplicationRepository {
  final _baseClient = BaseApiClient();
  Future<ClusterwiseApplicationListResponse?> serachApplicationById(
      BuildContext context, SearchApplicationPayload request) async {
    try {
      final token = CancelToken();

      final response = await _baseClient.postCall(
          ApiConstants.searchProhibitedApplication, request.toJson(), token);
      return ClusterwiseApplicationListResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }
}
