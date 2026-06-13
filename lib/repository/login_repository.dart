import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/base_api_client.dart';
import 'package:lrsofficer/models/login/login_payload.dart';
import 'package:lrsofficer/models/login/login_response.dart';
import '../res/constants/api_constants.dart';

class LoginRepository {
  final _baseApiClinet = BaseApiClient();
  Future<OfficerLoginResponse?> loginApi(
      BuildContext context, OfficerLoginPayload loginPayload) async {
    try {
      final token = CancelToken();
      final response = await _baseApiClinet.postCall(
          ApiConstants.loginEndPoint, loginPayload.toJson(), token);
      return OfficerLoginResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }
}
