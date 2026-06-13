import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/base_api_client.dart';
import 'package:lrsofficer/models/check_details_payload.dart';
import 'package:lrsofficer/models/check_details_response.dart';
import 'package:lrsofficer/models/questionare_dropdown_request.dart';
import 'package:lrsofficer/models/questionare_dropdown_response.dart';
import 'package:lrsofficer/res/constants/api_constants.dart';

class FifpCheckDetailsRepository {
  final _baseClient = BaseApiClient();
  Future<CheckDetailsResponse?> fifpCheckDetailsRepo(
      BuildContext context, CheckDetailsPayload request) async {
    try {
      final token = CancelToken();
      final response = await _baseClient.postCall(
          ApiConstants.fifpCheckList, request.toJson(), token);
      return CheckDetailsResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<QuestionareDropdownResponse?> questionsDropDownRepo(
      BuildContext context, QuestionareDropdownRequest request) async {
    try {
      final token = CancelToken();
      final response = await _baseClient.postCall(
          ApiConstants.quesDropdown, request.toJson(), token);
      return QuestionareDropdownResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }
}
