import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/base_api_client.dart';
import 'package:lrsofficer/models/recommendation_details_request.dart';
import 'package:lrsofficer/models/recommendation_details_response.dart';
import 'package:lrsofficer/res/constants/api_constants.dart';

class RecommendationsRepository {
  final _baseClient = BaseApiClient();
  Future<RecommendationDetailsResponse?> getRecommendationDetails(
      BuildContext context, RecommendationDetailsRequest request) async {
    try {
      final token = CancelToken();

      final response = await _baseClient.postCall(
          ApiConstants.recommendationDetails, request.toJson(), token);
      return RecommendationDetailsResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }
}
