import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/base_api_client.dart';
import 'package:lrsofficer/models/plots_layouts/villagewise_applications_count_response.dart';
import 'package:lrsofficer/models/plots_layouts/village_wise_applications_count_request.dart';
import 'package:lrsofficer/res/constants/api_constants.dart';

class VillageWiseApplicationsCountRepository {
  final _baseClient = BaseApiClient();
  Future<VillageWiseSurveyNumbersResponse?> clustterWisevillageCountRepo(
      BuildContext context, VillageWiseSurveyNumbersRequest request) async {
    try {
      final token = CancelToken();
      final response = await _baseClient.postCall(
          ApiConstants.clusterwiseVillageEndPoint, request.toJson(), token);
      return VillageWiseSurveyNumbersResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }
}
