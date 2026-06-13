import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/base_api_client.dart';
import 'package:lrsofficer/models/update_mobile_no_request.dart';
import 'package:lrsofficer/models/update_mobile_no_response.dart';
import 'package:lrsofficer/res/constants/api_constants.dart';

class UpdateMobileNoRepository {
  final _baseApiClinet = BaseApiClient();
  Future<UpdateMobileNoResponse?> updateMobileRepo(
      BuildContext context, UpdateMobileNoRequest request) async {
    try {
      final token = CancelToken();

      final response = await _baseApiClinet.postCall(
          ApiConstants.updateMobileNo, request.toJson(), token);
      return UpdateMobileNoResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }
}
