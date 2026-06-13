import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import '../res/constants/api_constants.dart';

class BaseApiClient {
  late final Dio _client = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 120),
      receiveTimeout: const Duration(seconds: 120),
      sendTimeout: const Duration(seconds: 120),
    ),
  )..interceptors.addAll([
      CustomInterceptor(this),
      LoggingInterceptor(),
    ]);

  late final Dio _clientArcGis = Dio(
    BaseOptions(
      baseUrl: ApiConstants.arcgisBaseurl,
      connectTimeout: const Duration(seconds: 120),
      receiveTimeout: const Duration(seconds: 120),
      sendTimeout: const Duration(seconds: 120),
    ),
  )..interceptors.addAll([
      CustomInterceptor(this),
      LoggingInterceptor(),
    ]);

  late final Dio _clientCertifiedCopy = Dio(
    BaseOptions(
      baseUrl: ApiConstants.certifiedCopyBaseUrl,
      connectTimeout: const Duration(seconds: 120),
      receiveTimeout: const Duration(seconds: 120),
      sendTimeout: const Duration(seconds: 120),
    ),
  )..interceptors.addAll([
      CustomInterceptor(this),
      LoggingInterceptor(),
    ]);

  late final Dio _clientFile = Dio(
    BaseOptions(
      baseUrl: ApiConstants.filesImagesBaseUrl,
      connectTimeout: const Duration(seconds: 120),
      receiveTimeout: const Duration(seconds: 120),
    ),
  )..interceptors.addAll([
      CustomInterceptor(this),
      LoggingInterceptor(shouldLogResponse: false),
    ]);

  void _cancelPreviousRequest(CancelToken? token) {
    if (AppConstants.activeToken != null && AppConstants.activeToken != token) {
      AppConstants.activeToken!.cancel("Cancelled due to new request");
      log("Previous request canceled.");
    }
  }

  bool _isCancelledRequest(DioException error) {
    // check if this error is due to cancellation
    return CancelToken.isCancel(error) ||
        (error.message?.toLowerCase().contains("cancelled") ?? false);
  }

  Future<dynamic> postCallWithFormdata(
    String url,
    dynamic payload,
    bool authorization,
    CancelToken token,
  ) async {
    _cancelPreviousRequest(
        AppConstants.activeToken); // Cancel any previous request
    AppConstants.activeToken = token; // Use the provided cancel token

    try {
      final response = await _clientArcGis.post(
        url,
        data: payload,
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Authorization': authorization
                ? 'Ftq5BFf3iEcJxl8eQZPnzc_zPadsO5xlPrV2_OYnQYfqmZnZIG-ryJnz3ywrzcN9'
                : '',
          },
        ),
        cancelToken: AppConstants.activeToken, // Attach the cancel token
      );

      AppLogger().logDebug("payload $payload");
      return response.data;
    } on DioException catch (error) {
      if (_isCancelledRequest(error)) {
        if (!kReleaseMode) {
          if (!kReleaseMode) {
            debugPrint("Request cancelled intentionally — ignoring.");
          }
        }
        return null; // don’t throw an error
      }
      return Future.error(error);
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<dynamic> postCall(
    String url,
    Map<String, dynamic> payload,
    CancelToken token,
  ) async {
    _cancelPreviousRequest(
        AppConstants.activeToken); // Cancel any previous request
    AppConstants.activeToken = token; // Use the provided cancel token

    try {
      final response = await _client.post(
        url,
        data: payload,
        cancelToken: AppConstants.activeToken, // Attach the cancel token
      );
      return response.data;
    } on DioException catch (error) {
      if (_isCancelledRequest(error)) {
        if (!kReleaseMode) {
          if (!kReleaseMode) {
            debugPrint("Request cancelled intentionally — ignoring.");
          }
        }
        return null; // don’t throw an error
      }
      return Future.error(error);
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<dynamic> getCall(
    String url,
    Map<String, dynamic> payload,
    CancelToken token,
  ) async {
    _cancelPreviousRequest(
        AppConstants.activeToken); // Cancel any previous request
    AppConstants.activeToken = token; // Use the provided cancel token

    try {
      final response = await _client.get(
        url,
        queryParameters: payload,
        cancelToken: AppConstants.activeToken, // Attach the cancel token
      );

      AppLogger().logDebug("payload $payload");
      return response.data;
    } on DioException catch (error) {
      if (_isCancelledRequest(error)) {
        if (!kReleaseMode) {
          if (!kReleaseMode) {
            debugPrint("Request cancelled intentionally — ignoring.");
          }
        }
        return null; // don’t throw an error
      }
      return Future.error(error);
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<dynamic> getCallWithNoPayload(
    BuildContext context,
    String url,
    Map<String, dynamic>? params,
    CancelToken token,
  ) async {
    _cancelPreviousRequest(
        AppConstants.activeToken); // Cancel any previous request
    AppConstants.activeToken = token; // Use the provided cancel token

    try {
      final response = await _client.get(
        url,
        queryParameters: params,
        cancelToken: AppConstants.activeToken, // Attach the cancel token
      );

      return response.data;
    } on DioException catch (error) {
      if (_isCancelledRequest(error)) {
        if (!kReleaseMode) {
          if (!kReleaseMode) {
            debugPrint("Request cancelled intentionally — ignoring.");
          }
        }
        return null; // don’t throw an error
      }
      return Future.error(error);
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<dynamic> postCallWithHeaders(
    String url,
    dynamic payload,
    CancelToken token,
  ) async {
    _cancelPreviousRequest(
        AppConstants.activeToken); // Cancel any previous request
    AppConstants.activeToken = token; // Use the provided cancel token
    try {
      final response = await _clientCertifiedCopy.post(
        url,
        data: payload,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'userid': 'CDMA',
            'hashkey': '8043de91c4df595966b0b082b0cd3e8543e71bf5=',
          },
        ),
        cancelToken: AppConstants.activeToken, // Attach the cancel token
      );

      AppLogger().logDebug("payload $payload");
      return response.data;
    } on DioException catch (error) {
      if (_isCancelledRequest(error)) {
        if (!kReleaseMode) {
          if (!kReleaseMode) {
            debugPrint("Request cancelled intentionally — ignoring.");
          }
        }
        return null; // don’t throw an error
      }
      return Future.error(error);
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<dynamic> getFile(String fileName, CancelToken token) async {
    try {
      final response = await _clientFile.get(
        "GetFile",
        queryParameters: {"fileName": fileName},
        cancelToken: token,
      );
      return response;
    } on DioException catch (error) {
      if (_isCancelledRequest(error)) {
        if (!kReleaseMode) {
          if (!kReleaseMode) {
            debugPrint("Request cancelled intentionally — ignoring.");
          }
        }
        return null; // don’t throw an error
      }
      return Future.error(error);
    }
  }
}

class CustomInterceptor extends Interceptor {
  final BaseApiClient apiClient;

  CustomInterceptor(this.apiClient);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Custom-Header'] = 'custom value';
    super.onRequest(options, handler);
  }
}

class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({this.shouldLogResponse = true});
  final bool shouldLogResponse;
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      log("Sending URL: ${options.uri}");
      log("Sending payload: ${jsonEncode(options.data)}");
      log("Sending Headers: ${jsonEncode(options.headers)}");
    } else {
      AppLogger().logDebug("Sending URL: ${options.uri}");
      AppLogger().logDebug("Sending payload: ${jsonEncode(options.data)}");
      AppLogger().logDebug("Sending Headers: ${jsonEncode(options.headers)}}");
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode && shouldLogResponse) {
      log("Received response: ${jsonEncode(response.data)}");
    } else {
      AppLogger().logDebug("Received response: ${jsonEncode(response.data)}");
    }
    super.onResponse(response, handler);
  }
}
