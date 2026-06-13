import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/base_api_client.dart';
import 'package:lrsofficer/models/cluster_wise_appl_list_request.dart';
import 'package:lrsofficer/models/cluster_wise_appl_list_response.dart';
import 'package:lrsofficer/models/plots_layouts/village_wise_applications_count_request.dart';
import 'package:lrsofficer/models/plots_layouts/villagewise_applications_count_response.dart';
import 'package:lrsofficer/models/list_of_cluster_count_request.dart';
import 'package:lrsofficer/models/list_of_cluster_count_response.dart';
import 'package:lrsofficer/res/constants/api_constants.dart';

class Phase2ShortfallVillagewiseListRepository {
  final _baseClient = BaseApiClient();
  Future<VillageWiseSurveyNumbersResponse?> getVillagewiseList(
      BuildContext context, VillageWiseSurveyNumbersRequest request) async {
    try {
      final token = CancelToken();
      final response = await _baseClient.postCall(
          ApiConstants.phase2ShortfallVillagewiseListEndPoint,
          request.toJson(),
          token);
      return VillageWiseSurveyNumbersResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<ListofClusterCountResponse?> getSurveyNowiseList(
      BuildContext context, ListofClusterCountResquest request) async {
    try {
      final token = CancelToken();
      final response = await _baseClient.postCall(
          ApiConstants.phase2ShortfallSurveyNowiseListEndPoint,
          request.toJson(),
          token);
      return ListofClusterCountResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<ClusterwiseApplicationListResponse?> getClusterwiseList(
      BuildContext context, ClusterwiseApplicationListRequest request) async {
    final token = CancelToken();
    final response = await _baseClient.postCall(
        ApiConstants.phase2ShortfallClusterwiseListEndPoint,
        request.toJson(),
        token);
    return ClusterwiseApplicationListResponse.fromJson(response);
  }
}
