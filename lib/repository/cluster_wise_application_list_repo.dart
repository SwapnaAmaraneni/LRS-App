import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/base_api_client.dart';
import 'package:lrsofficer/models/cluster_wise_appl_list_request.dart';
import 'package:lrsofficer/models/cluster_wise_appl_list_response.dart';
import 'package:lrsofficer/res/constants/api_constants.dart';

class ClusterwiseApplListRepository {
  final _baseClient = BaseApiClient();
  Future<ClusterwiseApplicationListResponse?> clusterwiseApplListRepo(
      BuildContext context, ClusterwiseApplicationListRequest request) async {
    try {
      final token = CancelToken();
      final response = await _baseClient.postCall(
          ApiConstants.clusterwiseApplicationList, request.toJson(), token);
      return ClusterwiseApplicationListResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }
}
