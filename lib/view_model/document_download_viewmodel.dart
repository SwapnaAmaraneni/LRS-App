import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/models/certifiedcopy_payload.dart';
import 'package:lrsofficer/models/get_certified_copy_response.dart';
import 'package:lrsofficer/repository/download_document_repository.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/api_error_codes.dart';
import 'package:lrsofficer/utils/error_handling_utils.dart';
import 'package:lrsofficer/utils/internet.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';

class DocumentDownloadViewModel with ChangeNotifier {
  GetCertifiedCopyResponse? result;

  TextEditingController sroCodeController = TextEditingController();

  bool isLoaderVisible = false;
  bool get getLoaderVisibilityStatus => isLoaderVisible;
  void setLoaderVisibleStatus(bool status) {
    isLoaderVisible = status;
    notifyListeners();
  }

  clearAll () {
    result = null;
    sroCodeController.clear();
    isLoaderVisible = false;
    notifyListeners();
  }

  Future<void> docVM(BuildContext context,
      {required String sroCode,
      required String saleDeedNo,
      required String saleDeedyear}) async {
    try {
      CertifiedCopyPayload payload = CertifiedCopyPayload(
          bookNo: "1",
          rdoctNo: saleDeedNo,
          ryear: saleDeedyear,
          srCode: sroCode);
      if (await internetCheck()) {
        setLoaderVisibleStatus(true);
        result = null;
        if (!context.mounted) return;
        final response = await DownloadDocumentRepository()
            .apiDownloadDocumentRepo(context, payload);
        setLoaderVisibleStatus(false);
        if (response?.responseCode == ApiErrorCodes.success) {
          result = response;
        } else if (response?.responseCode == ApiErrorCodes.badRequest) {
          if (!context.mounted) return;
          response?.pdfBas64 = null;
          ErrorCustomCupertinoAlert().showAlert(
            context,
            message: response?.responseMsg ?? "",
            onPressed: () async {
              Navigator.of(context).pop();
            },
          );
        } else if (response?.responseCode == ApiErrorCodes.sessionExpired) {
          if (!context.mounted) return;
          response?.pdfBas64 = null;
          ErrorCustomCupertinoAlert().showAlert(
            context,
            message: response?.responseMsg ?? "",
            onPressed: () async {
              await LocalStoreHelper().removeData(SharedPrefConstants.mpin);
              if (!context.mounted) return;
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          );
        } else {
          if (!context.mounted) return;
          response?.pdfBas64 = null;
          ErrorCustomCupertinoAlert().showAlert(
            context,
            message: response?.responseMsg ?? "",
            onPressed: () async {
              Navigator.of(context).pop();
            },
          );
        }
      } else {
        if (!context.mounted) return;
        ErrorCustomCupertinoAlert().showAlert(
          context,
          message: "internetCheck".tr(),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        );
      }
    } on DioException catch (dioError) {
      setLoaderVisibleStatus(false);
      if (!context.mounted) return;
      String errorMessage = ErrorHandlingUtils.handleError(dioError, context);
      ErrorHandlingUtils().showErrorDialog(context, errorMessage);
    } catch (error) {
      setLoaderVisibleStatus(false);
      if (!context.mounted) return;
      String errorMessage = ErrorHandlingUtils.handleError(error, context);
      ErrorHandlingUtils().showErrorDialog(context, errorMessage);
    } finally {
      setLoaderVisibleStatus(false);
    }
    notifyListeners();
  }
}
