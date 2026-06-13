import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/base_api_client.dart';
import 'package:lrsofficer/models/saved_applications/saved_application_details_payload.dart';
import 'package:lrsofficer/models/saved_applications/saved_application_details_response.dart';
import 'package:lrsofficer/models/saved_applications/saved_applications_list_payload.dart';
import 'package:lrsofficer/models/saved_applications/saved_applications_list_response.dart';
import 'package:lrsofficer/res/constants/api_constants.dart';

class SavedApplicationsRepository {
  final _baseClient = BaseApiClient();
  Future<SavedApplicationsListResponse?> getSavedApplicationsRepo(
      BuildContext context, SavedApplicationsListPayload request) async {
    try {
      final token = CancelToken();

      final response = await _baseClient.postCall(
          ApiConstants.savedApplicationsListEndPoint, request.toJson(), token);
      return SavedApplicationsListResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<SavedApplicationDetailsResponse?> getSavedApplicationDetails(
      BuildContext context, SavedApplicationDetailsPayload request) async {
    try {
      final token = CancelToken();

      final response = await _baseClient.postCall(
          ApiConstants.savedApplicationsDetailsEndPoint,
          request.toJson(),
          token);
      return SavedApplicationDetailsResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }
}
