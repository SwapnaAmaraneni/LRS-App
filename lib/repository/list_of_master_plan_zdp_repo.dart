import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/base_api_client.dart';
import 'package:lrsofficer/models/list_of_master_plan_zdp_request.dart';
import 'package:lrsofficer/models/list_of_master_plan_zdp_response.dart';
import 'package:lrsofficer/res/constants/api_constants.dart';

class ListMasterPlanZDPRepository {
  final _baseClient = BaseApiClient();
  Future<ListOfMasterPlanZDPResponse?> getListMasterPlanZDPDetails(
      BuildContext context, ListOfMasterPlanZDPRequest request) async {
    try {
      final token = CancelToken();
      final response = await _baseClient.postCall(
          ApiConstants.listOfMasterPlanZDP, request.toJson(), token);
      return ListOfMasterPlanZDPResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }
}
