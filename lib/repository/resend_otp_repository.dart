import 'package:dio/dio.dart';
import 'package:lrsofficer/data/base_api_client.dart';
import 'package:lrsofficer/models/resend_otp_response.dart';
import 'package:flutter/material.dart';
import '../models/resend_otp_payload.dart';
import '../res/constants/api_constants.dart';

class ResendOTPRepository {
  final _baseApiClinet = BaseApiClient();
  Future<ResendOTPResponse?> getResendOTPRepo(
      BuildContext context, ResendOTPPayload payload) async {
    try {
      final token = CancelToken();

      final response = await _baseApiClinet.postCall(
          ApiConstants.resendOtp, payload.toJson(), token);
      return ResendOTPResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }
}
