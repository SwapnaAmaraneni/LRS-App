import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/base_api_client.dart';
import 'package:lrsofficer/models/payment_details_payload.dart';
import 'package:lrsofficer/models/payment_details_resposne.dart';
import 'package:lrsofficer/res/constants/api_constants.dart';

class PaymentDetailsRepository {
  final _baseClient = BaseApiClient();
  Future<PaymentDetailsResponse?> clusterPaymentDetailsRepo(
      BuildContext context, PaymentDetailsPayload request) async {
    try {
      final token = CancelToken();
      final response = await _baseClient.postCall(
          ApiConstants.clusterPaymentDetailsCalc, request.toJson(), token);
      return PaymentDetailsResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }
}
