import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/base_api_client.dart';
import 'package:lrsofficer/models/list_of_cluster_count_request.dart';
import 'package:lrsofficer/models/list_of_cluster_count_response.dart';
import 'package:lrsofficer/res/constants/api_constants.dart';

class ListOfClusterCountRepository {
  final _baseClient = BaseApiClient();
  Future<ListofClusterCountResponse?> listOfclusterCountRepo(
      BuildContext context, ListofClusterCountResquest request) async {
    try {
      final token = CancelToken();
      final response = await _baseClient.postCall(
          ApiConstants.clusterListCountEndPoint, request.toJson(), token);
      return ListofClusterCountResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }
}
